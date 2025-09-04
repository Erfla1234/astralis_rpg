import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flame/game.dart';

class IntroScreen extends FlameGame {
  late TextComponent titleText;
  late TextComponent subtitleText;
  late TextComponent tapText;
  late List<StarParticle> stars;
  late AstralSilhouette astralSilhouette;
  
  bool _transitionStarted = false;
  double _fadeAlpha = 0.0;
  double _time = 0;
  
  @override
  Color backgroundColor() => const Color(0xFF0A0E27); // Deep night blue
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Create starfield background
    _createStarfield();
    
    // Add mystical particle effects
    _createMysticalParticles();
    
    // Create title with glow effect
    titleText = TextComponent(
      text: 'ASTRALIS',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 8,
          shadows: [
            Shadow(color: Color(0xFF9D4EDD), blurRadius: 20, offset: Offset(0, 0)),
            Shadow(color: Color(0xFF7B2CBF), blurRadius: 30, offset: Offset(0, 0)),
          ],
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.3),
      anchor: Anchor.center,
    );
    
    // Add floating animation to title
    titleText.add(
      MoveByEffect(
        Vector2(0, -10),
        EffectController(
          duration: 3,
          reverseDuration: 3,
          infinite: true,
        ),
      ),
    );
    
    await add(titleText);
    
    // Create subtitle
    subtitleText = TextComponent(
      text: 'Where bonds transcend capture',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 24,
          fontStyle: FontStyle.italic,
          color: Colors.white.withOpacity(0.8),
          letterSpacing: 2,
          shadows: const [
            Shadow(color: Color(0xFF5A189A), blurRadius: 10),
          ],
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.4),
      anchor: Anchor.center,
    );
    
    subtitleText.add(
      OpacityEffect.fadeIn(
        EffectController(duration: 2, startDelay: 1),
      ),
    );
    
    await add(subtitleText);
    
    // Add mystical Astral silhouette
    astralSilhouette = AstralSilhouette(
      position: Vector2(size.x / 2, size.y * 0.65),
    );
    await add(astralSilhouette);
    
    // Create tap to continue text with pulsing effect
    tapText = TextComponent(
      text: 'Tap to begin your journey',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 18,
          color: Colors.white.withOpacity(0.6),
          shadows: const [
            Shadow(color: Colors.purpleAccent, blurRadius: 5),
          ],
        ),
      ),
      position: Vector2(size.x / 2, size.y * 0.85),
      anchor: Anchor.center,
    );
    
    // Pulsing effect
    tapText.add(
      SequenceEffect([
        OpacityEffect.to(
          1.0,
          EffectController(duration: 1.5),
        ),
        OpacityEffect.to(
          0.3,
          EffectController(duration: 1.5),
        ),
      ], infinite: true),
    );
    
    await add(tapText);
    
    // Add glowing orbs floating around
    _createFloatingOrbs();
  }
  
  void _createStarfield() {
    final random = math.Random();
    for (int i = 0; i < 100; i++) {
      final star = CircleComponent(
        radius: random.nextDouble() * 2 + 0.5,
        paint: Paint()..color = Colors.white.withOpacity(random.nextDouble() * 0.8 + 0.2),
        position: Vector2(
          random.nextDouble() * size.x,
          random.nextDouble() * size.y,
        ),
      );
      
      // Add twinkling effect
      star.add(
        SequenceEffect([
          OpacityEffect.to(
            0.2,
            EffectController(duration: random.nextDouble() * 2 + 1),
          ),
          OpacityEffect.to(
            1.0,
            EffectController(duration: random.nextDouble() * 2 + 1),
          ),
        ], infinite: true),
      );
      
      add(star);
    }
  }
  
  void _createMysticalParticles() {
    // Create floating particles that drift upward
    final random = math.Random();
    
    for (int i = 0; i < 20; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (isMounted) {
          add(
            ParticleSystemComponent(
              particle: AcceleratedParticle(
                acceleration: Vector2(0, -20),
                speed: Vector2(
                  random.nextDouble() * 40 - 20,
                  -random.nextDouble() * 30 - 10,
                ),
                position: Vector2(
                  random.nextDouble() * size.x,
                  size.y + 20,
                ),
                child: CircleParticle(
                  radius: random.nextDouble() * 3 + 1,
                  paint: Paint()
                    ..color = Color.lerp(
                      const Color(0xFF9D4EDD),
                      const Color(0xFF5A189A),
                      random.nextDouble(),
                    )!.withOpacity(0.6)
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
                ),
              ),
            ),
          );
        }
      });
    }
  }
  
  void _createFloatingOrbs() {
    final colors = [
      const Color(0xFF9D4EDD), // Purple
      const Color(0xFF5A189A), // Deep purple
      const Color(0xFF7B2CBF), // Violet
      const Color(0xFFC77DFF), // Light purple
    ];
    
    for (int i = 0; i < 5; i++) {
      final orb = FloatingOrb(
        position: Vector2(
          size.x * (0.2 + i * 0.15),
          size.y * 0.6 + math.sin(i * math.pi / 3) * 50,
        ),
        color: colors[i % colors.length],
      );
      add(orb);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    
    // Create continuous particle stream
    if (_time > 0.5) {
      _time = 0;
      _createMysticalParticles();
    }
  }
  
  @override
  void onTapDown(info) {
    if (!_transitionStarted) {
      _transitionStarted = true;
      _startGameTransition();
    }
  }
  
  void _startGameTransition() {
    // Create dramatic transition effect
    add(
      RectangleComponent(
        size: size,
        paint: Paint()..color = Colors.white.withOpacity(0),
        priority: 1000,
      )..add(
        SequenceEffect([
          OpacityEffect.to(
            1.0,
            EffectController(duration: 0.5),
          ),
          OpacityEffect.to(
            0,
            EffectController(duration: 0.5),
          ),
        ]),
      ),
    );
  }
  
  void _loadMainGame() {
    // Transition to main game
    // Navigator pushes to game screen
  }
}

// Mystical Astral silhouette with glow
class AstralSilhouette extends PositionComponent {
  late CircleComponent core;
  late List<CircleComponent> glowLayers;
  double _time = 0;
  
  AstralSilhouette({required Vector2 position}) : super(position: position);
  
  @override
  Future<void> onLoad() async {
    // Create glowing layers
    glowLayers = [];
    
    // Outer glow layers
    for (int i = 3; i >= 0; i--) {
      final layer = CircleComponent(
        radius: 30 + i * 15.0,
        paint: Paint()
          ..color = const Color(0xFF9D4EDD).withOpacity(0.1 * (4 - i) / 4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
        anchor: Anchor.center,
      );
      glowLayers.add(layer);
      add(layer);
    }
    
    // Core
    core = CircleComponent(
      radius: 25,
      paint: Paint()
        ..shader = const RadialGradient(
          colors: [
            Color(0xFFE0AAFF),
            Color(0xFFC77DFF),
            Color(0xFF9D4EDD),
          ],
        ).createShader(const Rect.fromLTWH(-25, -25, 50, 50))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      anchor: Anchor.center,
    );
    
    add(core);
    
    // Add pulsing animation
    core.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.2),
          EffectController(duration: 2, curve: Curves.easeInOut),
        ),
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 2, curve: Curves.easeInOut),
        ),
      ], infinite: true),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    
    // Rotate glow layers
    for (int i = 0; i < glowLayers.length; i++) {
      glowLayers[i].angle = _time * (0.2 + i * 0.1) * (i.isEven ? 1 : -1);
    }
  }
}

// Floating orbs with trail effect
class FloatingOrb extends PositionComponent {
  final Color color;
  final List<Vector2> trail = [];
  static const int maxTrailLength = 10;
  double _time = 0;
  late Vector2 _basePosition;
  
  FloatingOrb({
    required Vector2 position,
    required this.color,
  }) : super(position: position) {
    _basePosition = position.clone();
  }
  
  @override
  Future<void> onLoad() async {
    // Main orb
    add(
      CircleComponent(
        radius: 8,
        paint: Paint()
          ..color = color
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        anchor: Anchor.center,
      ),
    );
    
    // Inner glow
    add(
      CircleComponent(
        radius: 4,
        paint: Paint()
          ..color = Colors.white.withOpacity(0.8),
        anchor: Anchor.center,
      ),
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    
    // Float in figure-8 pattern
    position = _basePosition + Vector2(
      math.sin(_time * 0.8) * 30,
      math.sin(_time * 1.6) * 15,
    );
    
    // Update trail
    trail.insert(0, position.clone());
    if (trail.length > maxTrailLength) {
      trail.removeLast();
    }
  }
  
  @override
  void render(Canvas canvas) {
    // Render trail
    for (int i = 1; i < trail.length; i++) {
      final paint = Paint()
        ..color = color.withOpacity(0.3 * (1 - i / maxTrailLength))
        ..strokeWidth = 2;
      
      if (i > 0) {
        canvas.drawLine(
          trail[i - 1].toOffset(),
          trail[i].toOffset(),
          paint,
        );
      }
    }
    
    super.render(canvas);
  }
}

// Star particle for background
class StarParticle {
  Vector2 position;
  double size;
  double brightness;
  double twinkleSpeed;
  
  StarParticle({
    required this.position,
    required this.size,
    required this.brightness,
    required this.twinkleSpeed,
  });
}