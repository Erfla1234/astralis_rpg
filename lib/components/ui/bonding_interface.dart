import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../../models/astral.dart';
import '../../models/relic.dart';
import '../../systems/bonding_system.dart';

class BondingInterface extends StatefulWidget {
  final Astral astral;
  final List<Relic> availableRelics;
  final Function(BondingResult) onBondingComplete;

  const BondingInterface({
    super.key,
    required this.astral,
    required this.availableRelics,
    required this.onBondingComplete,
  });

  @override
  State<BondingInterface> createState() => _BondingInterfaceState();
}

class _BondingInterfaceState extends State<BondingInterface>
    with TickerProviderStateMixin {
  late AnimationController _bondMeterController;
  late AnimationController _glowController;
  late Animation<double> _bondMeterAnimation;
  late Animation<double> _glowAnimation;

  Relic? selectedRelic;
  bool isAttempting = false;
  String statusMessage = '';

  @override
  void initState() {
    super.initState();
    
    _bondMeterController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _bondMeterAnimation = Tween<double>(
      begin: 0.0,
      end: widget.astral.trustLevel / 100.0,
    ).animate(CurvedAnimation(
      parent: _bondMeterController,
      curve: Curves.easeInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    selectedRelic = widget.availableRelics.isNotEmpty ? widget.availableRelics.first : null;
    _bondMeterController.forward();
  }

  @override
  void dispose() {
    _bondMeterController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.purple.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.withOpacity(0.5),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAstralDisplay(),
          const SizedBox(height: 16),
          _buildBondMeter(),
          const SizedBox(height: 16),
          _buildRelicSelector(),
          const SizedBox(height: 16),
          _buildBondingActions(),
          const SizedBox(height: 16),
          _buildStatusMessage(),
          const SizedBox(height: 16),
          _buildControlButtons(),
        ],
      ),
    );
  }

  Widget _buildAstralDisplay() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getAstralColor(),
                boxShadow: [
                  BoxShadow(
                    color: _getAstralColor().withOpacity(_glowAnimation.value),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.astral.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          widget.astral.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          widget.astral.personality.name.toUpperCase(),
          style: TextStyle(
            color: Colors.purple.shade200,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBondMeter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Bond Level',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            Text(
              '${widget.astral.trustLevel.toInt()}/100',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _bondMeterAnimation,
          builder: (context, child) {
            return Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade300, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _bondMeterAnimation.value,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.astral.canBond() ? Colors.amber : Colors.blue,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRelicSelector() {
    if (widget.availableRelics.isEmpty) {
      return const Text(
        'No relics available',
        style: TextStyle(color: Colors.red, fontSize: 14),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Relic',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: widget.availableRelics.map((relic) {
            final isSelected = selectedRelic?.id == relic.id;
            return GestureDetector(
              onTap: () => setState(() => selectedRelic = relic),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: relic.color,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'x${relic.bondingPower ~/ 10}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (selectedRelic != null) ...[
          const SizedBox(height: 8),
          Text(
            selectedRelic!.name,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            selectedRelic!.getFlavorText(),
            style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildBondingActions() {
    if (selectedRelic == null) return const SizedBox.shrink();

    final availableActions = BondingSystem.getAvailableActions(
      widget.astral,
      widget.availableRelics,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bonding Actions',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableActions.map((action) {
            return _buildActionButton(action);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButton(BondingAction action) {
    Color buttonColor;
    IconData icon;

    switch (action) {
      case BondingAction.showCare:
        buttonColor = Colors.green;
        icon = Icons.favorite;
        break;
      case BondingAction.battleBond:
        buttonColor = Colors.blue;
        icon = Icons.flash_on;
        break;
      case BondingAction.relicEnergy:
        buttonColor = Colors.purple;
        icon = Icons.auto_awesome;
        break;
      default:
        buttonColor = Colors.grey;
        icon = Icons.touch_app;
    }

    return ElevatedButton.icon(
      onPressed: isAttempting ? null : () => _attemptBonding(action),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        BondingSystem.getActionDescription(action),
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _buildStatusMessage() {
    if (statusMessage.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(
        statusMessage,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          icon: const Icon(Icons.close),
          label: const Text('Exit'),
        ),
        if (widget.astral.canBond() && !widget.astral.isBonded)
          ElevatedButton.icon(
            onPressed: isAttempting ? null : _finalBond,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            icon: const Icon(Icons.handshake),
            label: const Text('Form Bond'),
          ),
      ],
    );
  }

  void _attemptBonding(BondingAction action) {
    if (selectedRelic == null) return;

    setState(() {
      isAttempting = true;
      statusMessage = 'Attempting to bond...';
    });

    final result = BondingSystem.attemptBonding(
      widget.astral,
      action,
      selectedRelic!,
    );

    setState(() {
      isAttempting = false;
      statusMessage = result.message;
    });

    // Update bond meter animation
    _bondMeterAnimation = Tween<double>(
      begin: _bondMeterAnimation.value,
      end: widget.astral.trustLevel / 100.0,
    ).animate(CurvedAnimation(
      parent: _bondMeterController,
      curve: Curves.easeInOut,
    ));

    _bondMeterController.reset();
    _bondMeterController.forward();

    // If bonding was achieved, notify parent
    if (result.bondAchieved) {
      Future.delayed(const Duration(seconds: 2), () {
        widget.onBondingComplete(result);
      });
    }
  }

  void _finalBond() {
    if (!widget.astral.canBond() || selectedRelic == null) return;

    final result = BondingResult(
      success: true,
      trustChange: 0,
      message: '${widget.astral.name} has chosen to bond with you!',
      bondAchieved: true,
    );

    widget.astral.isBonded = true;
    widget.onBondingComplete(result);
  }

  Color _getAstralColor() {
    switch (widget.astral.type) {
      case AstralType.luminous:
        return Colors.yellow;
      case AstralType.shadow:
        return Colors.purple;
      case AstralType.crystal:
        return Colors.cyan;
      case AstralType.flame:
        return Colors.orange;
      case AstralType.water:
        return Colors.blue;
      case AstralType.earth:
        return Colors.brown;
      case AstralType.wind:
        return Colors.lightBlue;
      case AstralType.electric:
        return Colors.yellow;
      case AstralType.ice:
        return Colors.lightBlue;
      case AstralType.nature:
        return Colors.green;
    }
  }
}