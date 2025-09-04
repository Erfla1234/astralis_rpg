import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../models/astral.dart';
import '../components/player.dart';
import '../effects/particle_effects.dart';

class BondingOverlay extends Component {
  final Astral astral;
  final Player player;
  final Function(bool success) onComplete;
  
  late RectangleComponent background;
  late RectangleComponent panel;
  late TextComponent titleText;
  late TextComponent astralNameText;
  late TextComponent instructionText;
  late CircleComponent astralPortrait;
  late BondMeter bondMeter;
  late List<InteractionButton> actionButtons;
  
  // Bonding mini-game state
  int currentBondPoints = 0;
  int maxBondPoints = 100;
  int actionCount = 0;
  int maxActions = 5;
  bool isComplete = false;
  double _animationTime = 0;
  
  // Interaction results
  final List<String> responses = [];
  final List<BondingAction> availableActions = [];
  
  BondingOverlay({
    required this.astral,
    required this.player,
    required this.onComplete,
  }) : super(priority: 200);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Semi-transparent background
    background = RectangleComponent(
      size: Vector2(800, 600),
      paint: Paint()..color = Colors.black.withOpacity(0.7),
    );
    add(background);
    
    // Main panel
    panel = RectangleComponent(
      size: Vector2(600, 400),
      position: Vector2(100, 100),
      paint: Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF240046),
            Color(0xFF10002B),
            Color(0xFF5A189A),
          ],
        ).createShader(const Rect.fromLTWH(0, 0, 600, 400))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    add(panel);
    
    // Panel border with glow
    final border = RectangleComponent(
      size: Vector2(600, 400),
      position: Vector2(100, 100),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(0xFF9D4EDD)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    add(border);
    
    // Title
    titleText = TextComponent(
      text: 'Bonding Encounter',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color(0xFF9D4EDD),
              blurRadius: 15,
            ),
          ],
        ),
      ),
      position: Vector2(400, 130),
      anchor: Anchor.center,
    );
    add(titleText);
    
    // Astral name
    astralNameText = TextComponent(
      text: 'Wild ${astral.species}',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 24,
          color: Colors.white.withOpacity(0.9),
          fontStyle: FontStyle.italic,
        ),
      ),
      position: Vector2(400, 170),
      anchor: Anchor.center,
    );
    add(astralNameText);
    
    // Astral portrait with glow
    astralPortrait = CircleComponent(
      radius: 60,
      position: Vector2(250, 280),
      paint: Paint()
        ..shader = RadialGradient(
          colors: [
            _getAstralColor().withOpacity(0.8),
            _getAstralColor().withOpacity(0.4),
            Colors.transparent,
          ],
        ).createShader(const Rect.fromCircle(center: Offset.zero, radius: 60))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      anchor: Anchor.center,
    );
    add(astralPortrait);
    
    // Inner portrait
    final innerPortrait = CircleComponent(
      radius: 40,
      position: Vector2(250, 280),
      paint: Paint()..color = _getAstralColor(),
      anchor: Anchor.center,
    );
    add(innerPortrait);
    
    // Bond meter
    bondMeter = BondMeter(
      position: Vector2(400, 250),
      currentBond: currentBondPoints,
      maxBond: maxBondPoints,
    );
    add(bondMeter);
    
    // Instructions
    instructionText = TextComponent(
      text: 'Choose how to interact with this Astral.\nShow care and understanding to build trust.',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      position: Vector2(400, 320),
      anchor: Anchor.center,
    );
    add(instructionText);
    
    // Initialize available actions
    _initializeActions();
    
    // Create action buttons
    _createActionButtons();
    
    // Add floating particles around the Astral
    _addAmbientEffects();
    
    // Entry animation
    panel.add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(duration: 0.5, curve: Curves.elasticOut),
      ),
    );
    
    // Make portrait pulse
    astralPortrait.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.1),
          EffectController(duration: 1.5),
        ),
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 1.5),
        ),
      ], infinite: true),
    );
  }
  
  void _initializeActions() {
    // Based on Astral personality, different actions are more effective
    availableActions.addAll([
      BondingAction(
        name: 'Show Care',
        description: 'Offer food and gentle attention',
        bondGain: 15 + math.Random().nextInt(10),
        icon: '🌱',
      ),
      BondingAction(
        name: 'Observe Quietly',
        description: 'Watch respectfully from a distance',
        bondGain: 8 + math.Random().nextInt(8),
        icon: '👁️',
      ),
      BondingAction(
        name: 'Gentle Approach',
        description: 'Move slowly and speak softly',
        bondGain: 12 + math.Random().nextInt(12),
        icon: '🤲',
      ),
      BondingAction(
        name: 'Share Energy',
        description: 'Extend your spiritual aura',
        bondGain: 10 + math.Random().nextInt(15),
        icon: '✨',
      ),
    ]);
    
    // Adjust effectiveness based on Astral personality
    _adjustActionsForPersonality();
  }
  
  void _adjustActionsForPersonality() {
    switch (astral.personality.toLowerCase()) {
      case 'curious':
        availableActions[1].bondGain += 5; // Observe Quietly more effective
        break;
      case 'cautious':
        availableActions[2].bondGain += 5; // Gentle Approach more effective
        break;
      case 'playful':
        availableActions[0].bondGain += 5; // Show Care more effective
        break;
      case 'wise':
        availableActions[3].bondGain += 5; // Share Energy more effective
        break;
    }
  }
  
  void _createActionButtons() {
    actionButtons = [];
    
    for (int i = 0; i < availableActions.length; i++) {
      final action = availableActions[i];
      final button = InteractionButton(
        action: action,
        position: Vector2(150 + (i % 2) * 250, 380 + (i ~/ 2) * 60),
        onPressed: () => _performAction(action),
      );
      
      actionButtons.add(button);
      add(button);
    }
  }
  
  void _performAction(BondingAction action) {
    if (isComplete || actionCount >= maxActions) return;
    
    actionCount++;
    currentBondPoints = math.min(maxBondPoints, currentBondPoints + action.bondGain);
    
    // Update bond meter
    bondMeter.updateBond(currentBondPoints);
    
    // Generate response based on action effectiveness
    String response = _generateResponse(action);
    responses.add(response);
    
    // Update instruction text with response
    instructionText.text = response;
    
    // Add visual effect
    _addActionEffect(action);
    
    // Check if bonding is complete
    if (currentBondPoints >= maxBondPoints || actionCount >= maxActions) {
      _completeBonding();
    } else {
      // Update remaining actions
      _updateActionButtons();
    }
  }
  
  String _generateResponse(BondingAction action) {
    final effectiveness = action.bondGain;
    final astralName = astral.species;
    
    if (effectiveness >= 20) {
      return '$astralName responds very positively! Trust is building quickly.';
    } else if (effectiveness >= 15) {
      return '$astralName seems pleased with your approach.';
    } else if (effectiveness >= 10) {
      return '$astralName acknowledges your effort cautiously.';
    } else {
      return '$astralName is unsure about your intentions.';
    }
  }
  
  void _addActionEffect(BondingAction action) {
    // Create particle effect based on action type
    ParticleSystemComponent? effect;
    
    switch (action.name) {
      case 'Show Care':
        effect = ParticleEffects.createHealingEffect(astralPortrait.position);
        break;
      case 'Gentle Approach':
        effect = ParticleEffects.createBondingEffect(astralPortrait.position);
        break;
      case 'Share Energy':
        effect = ParticleEffects.createPurifyEffect(astralPortrait.position);
        break;
      default:
        // Sparkle effect for other actions
        effect = _createSparkleEffect();
    }
    
    if (effect != null) {
      add(effect);
    }
    
    // Make portrait react
    astralPortrait.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.2),
          EffectController(duration: 0.3),
        ),
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 0.3),
        ),
      ]),
    );
  }
  
  ParticleSystemComponent _createSparkleEffect() {
    return ParticleSystemComponent(
      position: astralPortrait.position,
      particle: Particle.generate(
        count: 15,
        lifespan: 2,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, -30),
          speed: Vector2(
            math.Random().nextDouble() * 100 - 50,
            -math.Random().nextDouble() * 50 - 25,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 2 + math.Random().nextDouble() * 3,
            paint: Paint()
              ..color = Colors.white.withOpacity(0.8)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
          ),
        ),
      ),
    );
  }
  
  void _updateActionButtons() {
    // Disable used actions or update based on progress
    final actionsLeft = maxActions - actionCount;
    instructionText.text += '\n\nActions remaining: $actionsLeft';
  }
  
  void _completeBonding() {
    isComplete = true;
    
    // Disable action buttons
    for (final button in actionButtons) {
      button.setEnabled(false);
    }
    
    bool success = currentBondPoints >= 60; // Need at least 60% bond
    
    if (success) {
      instructionText.text = 'Success! ${astral.species} trusts you and wishes to join your journey!';
      
      // Create celebration effect
      final celebration = ParticleEffects.createEvolutionEffect(astralPortrait.position);
      add(celebration);
      
      // Make portrait glow brighter
      astralPortrait.paint = Paint()
        ..color = _getAstralColor()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 25);
      
    } else {
      instructionText.text = '${astral.species} remains wary. Perhaps try a different approach next time.';
    }
    
    // Add completion button
    _addCompletionButton(success);
  }
  
  void _addCompletionButton(bool success) {
    final buttonText = success ? 'Welcome to the team!' : 'Maybe next time';
    
    final completionButton = InteractionButton(
      action: BondingAction(
        name: buttonText,
        description: '',
        bondGain: 0,
        icon: success ? '✅' : '❌',
      ),
      position: Vector2(400, 450),
      onPressed: () => _exitBonding(success),
    );
    
    add(completionButton);
  }
  
  void _exitBonding(bool success) {
    // Exit animation
    panel.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(0.8),
          EffectController(duration: 0.3),
        ),
        OpacityEffect.to(
          0,
          EffectController(duration: 0.2),
        ),
      ], onComplete: () {
        removeFromParent();
        onComplete(success);
      }),
    );
    
    background.add(
      OpacityEffect.to(
        0,
        EffectController(duration: 0.5),
      ),
    );
  }
  
  void _addAmbientEffects() {
    // Add floating particles around the scene
    for (int i = 0; i < 10; i++) {
      Future.delayed(Duration(milliseconds: i * 300), () {
        if (!isRemoved) {
          final particle = ParticleSystemComponent(
            position: Vector2(
              120 + math.Random().nextDouble() * 560,
              120 + math.Random().nextDouble() * 360,
            ),
            particle: AcceleratedParticle(
              acceleration: Vector2(0, -20),
              speed: Vector2(
                math.Random().nextDouble() * 30 - 15,
                -math.Random().nextDouble() * 20 - 10,
              ),
              position: Vector2.zero(),
              child: CircleParticle(
                radius: 2,
                paint: Paint()
                  ..color = _getAstralColor().withOpacity(0.4)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
              ),
              lifespan: 5,
            ),
          );
          
          add(particle);
        }
      });
    }
  }
  
  Color _getAstralColor() {
    switch (astral.species.toLowerCase()) {
      case 'tuki':
        return const Color(0xFF90EE90);
      case 'cindcub':
        return const Color(0xFFFF6347);
      case 'rylotl':
        return const Color(0xFF1E90FF);
      case 'rowletch':
        return const Color(0xFF8B4513);
      case 'peavee':
        return const Color(0xFFFFD700);
      default:
        return const Color(0xFF9D4EDD);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _animationTime += dt;
  }
  
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _exitBonding(false);
        return true;
      }
      
      // Number keys for quick action selection
      if (event.logicalKey == LogicalKeyboardKey.digit1 && !isComplete) {
        if (availableActions.isNotEmpty) _performAction(availableActions[0]);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit2 && !isComplete) {
        if (availableActions.length > 1) _performAction(availableActions[1]);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit3 && !isComplete) {
        if (availableActions.length > 2) _performAction(availableActions[2]);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit4 && !isComplete) {
        if (availableActions.length > 3) _performAction(availableActions[3]);
        return true;
      }
    }
    
    return false;
  }
}

class BondingAction {
  final String name;
  final String description;
  int bondGain;
  final String icon;
  
  BondingAction({
    required this.name,
    required this.description,
    required this.bondGain,
    required this.icon,
  });
}

class BondMeter extends PositionComponent {
  final double maxBond;
  double currentBond;
  late RectangleComponent background;
  late RectangleComponent fillBar;
  late TextComponent valueText;
  
  BondMeter({
    required Vector2 position,
    required this.currentBond,
    required this.maxBond,
  }) : super(position: position);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Background
    background = RectangleComponent(
      size: Vector2(200, 20),
      paint: Paint()..color = Colors.black.withOpacity(0.5),
      anchor: Anchor.center,
    );
    add(background);
    
    // Border
    final border = RectangleComponent(
      size: Vector2(200, 20),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withOpacity(0.8),
      anchor: Anchor.center,
    );
    add(border);
    
    // Fill bar
    fillBar = RectangleComponent(
      size: Vector2((currentBond / maxBond) * 196, 16),
      position: Vector2(-98, -8),
      paint: Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF9D4EDD),
            Color(0xFFC77DFF),
            Color(0xFFE0AAFF),
          ],
        ).createShader(const Rect.fromLTWH(0, 0, 196, 16)),
    );
    add(fillBar);
    
    // Value text
    valueText = TextComponent(
      text: '${currentBond.toInt()}/${maxBond.toInt()}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(0, 25),
    );
    add(valueText);
  }
  
  void updateBond(double newBond) {
    currentBond = newBond;
    
    // Animate the fill bar
    fillBar.add(
      SizeEffect.to(
        Vector2((currentBond / maxBond) * 196, 16),
        EffectController(duration: 0.5, curve: Curves.easeOut),
      ),
    );
    
    // Update text
    valueText.text = '${currentBond.toInt()}/${maxBond.toInt()}';
    
    // Add glow effect when bond is high
    if (currentBond / maxBond > 0.75) {
      fillBar.paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    }
  }
}

class InteractionButton extends PositionComponent {
  final BondingAction action;
  final VoidCallback onPressed;
  late RectangleComponent background;
  late TextComponent nameText;
  late TextComponent descriptionText;
  late TextComponent iconText;
  bool isEnabled = true;
  
  InteractionButton({
    required this.action,
    required Vector2 position,
    required this.onPressed,
  }) : super(position: position);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Background
    background = RectangleComponent(
      size: Vector2(180, 50),
      paint: Paint()
        ..color = const Color(0xFF5A189A).withOpacity(0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      anchor: Anchor.center,
    );
    add(background);
    
    // Border
    final border = RectangleComponent(
      size: Vector2(180, 50),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF9D4EDD),
      anchor: Anchor.center,
    );
    add(border);
    
    // Icon
    iconText = TextComponent(
      text: action.icon,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
      position: Vector2(-70, -10),
      anchor: Anchor.center,
    );
    add(iconText);
    
    // Name
    nameText = TextComponent(
      text: action.name,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(-20, -12),
    );
    add(nameText);
    
    // Description
    descriptionText = TextComponent(
      text: action.description,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 10,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      position: Vector2(-20, 5),
    );
    add(descriptionText);
    
    // Bond gain indicator
    final bondText = TextComponent(
      text: '+${action.bondGain}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFFFFD700),
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(60, -5),
      anchor: Anchor.center,
    );
    add(bondText);
  }
  
  void onTapDown() {
    if (!isEnabled) return;
    
    // Button press animation
    background.add(
      SequenceEffect([
        ColorEffect(
          const Color(0xFF7B2CBF),
          EffectController(duration: 0.1),
          opacityFrom: 0.8,
          opacityTo: 1.0,
        ),
        ColorEffect(
          const Color(0xFF5A189A),
          EffectController(duration: 0.1),
          opacityFrom: 1.0,
          opacityTo: 0.8,
        ),
      ]),
    );
    
    onPressed();
  }
  
  void setEnabled(bool enabled) {
    isEnabled = enabled;
    
    if (!enabled) {
      background.paint.color = Colors.grey.withOpacity(0.5);
      nameText.textRenderer = TextPaint(
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.5),
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }
}