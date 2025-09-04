import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../components/player.dart';
import '../models/astral.dart';

class HudOverlay extends Component {
  final Player player;
  late RectangleComponent background;
  late TextComponent playerNameText;
  late TextComponent locationText;
  late List<AstralStatusBar> astralBars;
  late MiniMapComponent miniMap;
  
  // Animation properties
  double _pulseTime = 0;
  bool _showNotification = false;
  String _notificationText = '';
  
  HudOverlay({required this.player});
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Create semi-transparent background
    background = RectangleComponent(
      size: Vector2(800, 120),
      position: Vector2(0, 0),
      paint: Paint()
        ..color = const Color(0xFF0A0E27).withOpacity(0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      priority: 100,
    );
    add(background);
    
    // Add gradient border
    final borderGradient = RectangleComponent(
      size: Vector2(800, 4),
      position: Vector2(0, 116),
      paint: Paint()
        ..shader = const LinearGradient(
          colors: [
            Color(0xFF9D4EDD),
            Color(0xFF5A189A),
            Color(0xFF240046),
          ],
        ).createShader(const Rect.fromLTWH(0, 0, 800, 4)),
      priority: 101,
    );
    add(borderGradient);
    
    // Player name and status
    playerNameText = TextComponent(
      text: 'Aelira', // TODO: Get from player
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color(0xFF9D4EDD),
              blurRadius: 10,
            ),
          ],
        ),
      ),
      position: Vector2(20, 20),
      priority: 102,
    );
    add(playerNameText);
    
    // Location text
    locationText = TextComponent(
      text: 'Grove of Beginnings',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(0.8),
          fontStyle: FontStyle.italic,
        ),
      ),
      position: Vector2(20, 50),
      priority: 102,
    );
    add(locationText);
    
    // Astral status bars
    astralBars = [];
    _updateAstralBars();
    
    // Mini-map
    miniMap = MiniMapComponent(player: player);
    miniMap.position = Vector2(680, 20);
    add(miniMap);
    
    // Add pulsing effect to border
    borderGradient.add(
      SequenceEffect([
        OpacityEffect.to(
          0.7,
          EffectController(duration: 2),
        ),
        OpacityEffect.to(
          1.0,
          EffectController(duration: 2),
        ),
      ], infinite: true),
    );
  }
  
  void _updateAstralBars() {
    // Remove old bars
    for (final bar in astralBars) {
      bar.removeFromParent();
    }
    astralBars.clear();
    
    // Add bars for bonded Astrals
    for (int i = 0; i < player.bondedAstrals.length && i < 3; i++) {
      final astral = player.bondedAstrals[i];
      final bar = AstralStatusBar(
        astral: astral,
        position: Vector2(250 + i * 120, 25),
      );
      astralBars.add(bar);
      add(bar);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    _pulseTime += dt;
    
    // Update Astral bars if team changed
    if (astralBars.length != player.bondedAstrals.length) {
      _updateAstralBars();
    }
    
    // Handle notifications
    if (_showNotification) {
      _updateNotification(dt);
    }
  }
  
  void _updateNotification(double dt) {
    // Fade out notification after 3 seconds
    // Implementation for notification display would go here
  }
  
  void showNotification(String message, {Color color = Colors.white}) {
    _notificationText = message;
    _showNotification = true;
    
    // Create notification component
    final notification = NotificationComponent(
      text: message,
      color: color,
      position: Vector2(400, 150),
    );
    
    add(notification);
  }
  
  void updateLocation(String location) {
    locationText.text = location;
  }
}

class AstralStatusBar extends PositionComponent {
  final Astral astral;
  late RectangleComponent background;
  late RectangleComponent healthBar;
  late RectangleComponent bondBar;
  late TextComponent nameText;
  late CircleComponent portrait;
  
  AstralStatusBar({
    required this.astral,
    required Vector2 position,
  }) : super(position: position);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Background
    background = RectangleComponent(
      size: Vector2(100, 60),
      paint: Paint()
        ..color = const Color(0xFF240046).withOpacity(0.7)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    add(background);
    
    // Border
    final border = RectangleComponent(
      size: Vector2(100, 60),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withOpacity(0.3),
    );
    add(border);
    
    // Portrait
    portrait = CircleComponent(
      radius: 12,
      position: Vector2(15, 15),
      paint: Paint()..color = _getSpeciesColor(),
      anchor: Anchor.center,
    );
    add(portrait);
    
    // Name
    nameText = TextComponent(
      text: astral.nickname.length > 8 
          ? '${astral.nickname.substring(0, 8)}...'
          : astral.nickname,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(32, 8),
    );
    add(nameText);
    
    // Health bar background
    final healthBg = RectangleComponent(
      size: Vector2(60, 6),
      position: Vector2(32, 25),
      paint: Paint()..color = Colors.red.withOpacity(0.3),
    );
    add(healthBg);
    
    // Health bar
    healthBar = RectangleComponent(
      size: Vector2(60 * (astral.currentHP / astral.maxHP), 6),
      position: Vector2(32, 25),
      paint: Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF00FF00), Color(0xFF32CD32)],
        ).createShader(const Rect.fromLTWH(0, 0, 60, 6)),
    );
    add(healthBar);
    
    // Bond bar background
    final bondBg = RectangleComponent(
      size: Vector2(60, 4),
      position: Vector2(32, 35),
      paint: Paint()..color = const Color(0xFF9D4EDD).withOpacity(0.3),
    );
    add(bondBg);
    
    // Bond bar
    bondBar = RectangleComponent(
      size: Vector2(60 * (astral.bondLevel / 100), 4),
      position: Vector2(32, 35),
      paint: Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFF9D4EDD), Color(0xFFC77DFF)],
        ).createShader(const Rect.fromLTWH(0, 0, 60, 4)),
    );
    add(bondBar);
    
    // Level text
    final levelText = TextComponent(
      text: 'Lv.${astral.level}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 8,
          color: Colors.white,
        ),
      ),
      position: Vector2(32, 45),
    );
    add(levelText);
  }
  
  Color _getSpeciesColor() {
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
    
    // Update health bar
    final healthPercent = astral.currentHP / astral.maxHP;
    healthBar.size.x = 60 * healthPercent;
    
    // Update bond bar
    final bondPercent = astral.bondLevel / 100;
    bondBar.size.x = 60 * bondPercent;
    
    // Add glow effect when bond is high
    if (astral.bondLevel > 75) {
      portrait.paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    }
  }
}

class MiniMapComponent extends PositionComponent {
  final Player player;
  late RectangleComponent mapBackground;
  late CircleComponent playerDot;
  final List<CircleComponent> objectDots = [];
  
  MiniMapComponent({required this.player});
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Map background
    mapBackground = RectangleComponent(
      size: Vector2(80, 80),
      paint: Paint()
        ..color = const Color(0xFF0A0E27).withOpacity(0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1),
    );
    add(mapBackground);
    
    // Border
    final border = RectangleComponent(
      size: Vector2(80, 80),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF9D4EDD).withOpacity(0.6),
    );
    add(border);
    
    // Player dot
    playerDot = CircleComponent(
      radius: 3,
      position: Vector2(40, 40),
      paint: Paint()..color = Colors.white,
      anchor: Anchor.center,
    );
    add(playerDot);
    
    // Add pulsing effect to player dot
    playerDot.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.3),
          EffectController(duration: 0.8),
        ),
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 0.8),
        ),
      ], infinite: true),
    );
  }
  
  void addObjectMarker(Vector2 worldPosition, Color color) {
    // Convert world position to minimap coordinates
    final mapPos = Vector2(
      (worldPosition.x / 800) * 80,
      (worldPosition.y / 600) * 80,
    );
    
    final marker = CircleComponent(
      radius: 2,
      position: mapPos,
      paint: Paint()..color = color,
      anchor: Anchor.center,
    );
    
    objectDots.add(marker);
    add(marker);
  }
  
  void clearMarkers() {
    for (final dot in objectDots) {
      dot.removeFromParent();
    }
    objectDots.clear();
  }
}

class NotificationComponent extends PositionComponent {
  final String text;
  final Color color;
  late TextComponent textComponent;
  late RectangleComponent background;
  double _lifespan = 3.0;
  
  NotificationComponent({
    required this.text,
    required this.color,
    required Vector2 position,
  }) : super(position: position);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Background
    background = RectangleComponent(
      size: Vector2(text.length * 8.0 + 20, 40),
      paint: Paint()
        ..color = const Color(0xFF240046).withOpacity(0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      anchor: Anchor.center,
    );
    add(background);
    
    // Text
    textComponent = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(color: Colors.black, blurRadius: 2),
          ],
        ),
      ),
      anchor: Anchor.center,
    );
    add(textComponent);
    
    // Slide in animation
    add(
      MoveByEffect(
        Vector2(0, -20),
        EffectController(duration: 0.5, curve: Curves.easeOut),
      ),
    );
    
    // Fade out after lifespan
    add(
      SequenceEffect([
        ScaleEffect.by(
          Vector2.all(1.1),
          EffectController(duration: 0.2),
        ),
        ScaleEffect.by(
          Vector2.all(1.0 / 1.1),
          EffectController(duration: 0.2),
        ),
        OpacityEffect.to(
          0,
          EffectController(duration: 1.0, startDelay: _lifespan - 1),
          onComplete: () => removeFromParent(),
        ),
      ]),
    );
  }
}

class HealthGlobe extends CircleComponent {
  final double maxValue;
  final double currentValue;
  final Color primaryColor;
  final Color secondaryColor;
  
  HealthGlobe({
    required this.maxValue,
    required this.currentValue,
    required this.primaryColor,
    required this.secondaryColor,
    required double radius,
    required Vector2 position,
  }) : super(
    radius: radius,
    position: position,
    anchor: Anchor.center,
  );
  
  @override
  void render(Canvas canvas) {
    final rect = Rect.fromCircle(center: Offset.zero, radius: radius);
    
    // Background circle
    final bgPaint = Paint()
      ..color = secondaryColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset.zero, radius, bgPaint);
    
    // Fill based on current/max ratio
    final fillPercent = currentValue / maxValue;
    final sweepAngle = 2 * math.pi * fillPercent;
    
    final fillPaint = Paint()
      ..shader = RadialGradient(
        colors: [primaryColor, secondaryColor],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
    
    canvas.drawArc(
      rect,
      -math.pi / 2, // Start from top
      sweepAngle,
      true,
      fillPaint,
    );
    
    // Outer ring
    final ringPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset.zero, radius, ringPaint);
  }
}