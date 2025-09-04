import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ParticleEffects {
  static final math.Random _random = math.Random();
  
  // Bonding effect with swirling hearts and sparkles
  static ParticleSystemComponent createBondingEffect(Vector2 position) {
    return ParticleSystemComponent(
      position: position,
      particle: ComposedParticle(
        children: [
          // Hearts floating upward
          for (int i = 0; i < 10; i++)
            AcceleratedParticle(
              acceleration: Vector2(0, -50),
              speed: Vector2(
                _random.nextDouble() * 60 - 30,
                -_random.nextDouble() * 40 - 20,
              ),
              position: Vector2(
                _random.nextDouble() * 20 - 10,
                _random.nextDouble() * 20 - 10,
              ),
              child: RotatingParticle(
                to: _random.nextDouble() * math.pi * 2,
                child: ScalingParticle(
                  to: 0,
                  child: HeartParticle(
                    size: 15 + _random.nextDouble() * 10,
                    color: Color.lerp(
                      const Color(0xFFFF69B4),
                      const Color(0xFFFF1493),
                      _random.nextDouble(),
                    )!,
                  ),
                ),
              ),
            ),
          
          // Sparkles
          for (int i = 0; i < 20; i++)
            AcceleratedParticle(
              acceleration: Vector2(
                _random.nextDouble() * 20 - 10,
                _random.nextDouble() * 20 - 10,
              ),
              speed: Vector2(
                _random.nextDouble() * 100 - 50,
                _random.nextDouble() * 100 - 50,
              ),
              position: Vector2.zero(),
              child: CircleParticle(
                radius: 2 + _random.nextDouble() * 3,
                paint: Paint()
                  ..color = Colors.white.withOpacity(0.8)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
              ),
              lifespan: 2,
            ),
        ],
        lifespan: 3,
      ),
    );
  }
  
  // Purify effect with radiant light beams
  static ParticleSystemComponent createPurifyEffect(Vector2 position) {
    return ParticleSystemComponent(
      position: position,
      particle: ComposedParticle(
        children: [
          // Light beams radiating outward
          for (int i = 0; i < 12; i++)
            MovingParticle(
              from: Vector2.zero(),
              to: Vector2(
                math.cos(i * math.pi / 6) * 150,
                math.sin(i * math.pi / 6) * 150,
              ),
              child: ScalingParticle(
                to: 0,
                child: RectangleParticle(
                  size: Vector2(80, 4),
                  paint: Paint()
                    ..shader = const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0xFFFFD700),
                        Color(0xFFFFA500),
                        Colors.transparent,
                      ],
                    ).createShader(const Rect.fromLTWH(0, 0, 80, 4))
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
                ),
              ),
            ),
          
          // Central burst
          CircleParticle(
            radius: 30,
            paint: Paint()
              ..color = Colors.white
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
            lifespan: 0.5,
          ),
          
          // Golden particles
          for (int i = 0; i < 30; i++)
            AcceleratedParticle(
              acceleration: Vector2(0, 50),
              speed: Vector2(
                _random.nextDouble() * 200 - 100,
                _random.nextDouble() * -150 - 50,
              ),
              position: Vector2.zero(),
              child: CircleParticle(
                radius: 3 + _random.nextDouble() * 4,
                paint: Paint()
                  ..color = const Color(0xFFFFD700).withOpacity(0.8)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
              ),
              lifespan: 2.5,
            ),
        ],
        lifespan: 3,
      ),
    );
  }
  
  // Evolution effect with spiral energy
  static ParticleSystemComponent createEvolutionEffect(Vector2 position) {
    return ParticleSystemComponent(
      position: position,
      particle: ComposedParticle(
        children: [
          // Spiral energy
          for (int i = 0; i < 50; i++)
            MovingParticle(
              from: Vector2.zero(),
              to: Vector2(
                math.cos(i * 0.3) * (i * 3),
                math.sin(i * 0.3) * (i * 3),
              ),
              child: CircleParticle(
                radius: 5 - (i * 0.1),
                paint: Paint()
                  ..color = Color.lerp(
                    const Color(0xFF00FFFF),
                    const Color(0xFFFF00FF),
                    i / 50,
                  )!.withOpacity(0.8)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
              ),
              curve: Curves.easeInOut,
            ),
          
          // Energy rings
          for (int i = 0; i < 5; i++)
            ScalingParticle(
              to: 3,
              child: CircleParticle(
                radius: 20 + i * 15.0,
                paint: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = const Color(0xFF00FFFF).withOpacity(0.5 - i * 0.1)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
              ),
              lifespan: 2 + i * 0.2,
            ),
        ],
        lifespan: 4,
      ),
    );
  }
  
  // Battle hit effect
  static ParticleSystemComponent createHitEffect(Vector2 position, Color color) {
    return ParticleSystemComponent(
      position: position,
      particle: ComposedParticle(
        children: [
          // Impact burst
          for (int i = 0; i < 15; i++)
            AcceleratedParticle(
              acceleration: Vector2(0, 100),
              speed: Vector2(
                math.cos(i * math.pi * 2 / 15) * 100,
                math.sin(i * math.pi * 2 / 15) * 100,
              ),
              position: Vector2.zero(),
              child: ScalingParticle(
                to: 0,
                child: CircleParticle(
                  radius: 4 + _random.nextDouble() * 4,
                  paint: Paint()
                    ..color = color
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
                ),
              ),
              lifespan: 0.8,
            ),
          
          // Flash
          ScalingParticle(
            to: 2,
            child: CircleParticle(
              radius: 20,
              paint: Paint()
                ..color = Colors.white.withOpacity(0.8)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
            ),
            lifespan: 0.2,
          ),
        ],
        lifespan: 1,
      ),
    );
  }
  
  // Healing effect
  static ParticleSystemComponent createHealingEffect(Vector2 position) {
    return ParticleSystemComponent(
      position: position,
      particle: ComposedParticle(
        children: [
          // Healing sparkles rising
          for (int i = 0; i < 20; i++)
            AcceleratedParticle(
              acceleration: Vector2(0, -30),
              speed: Vector2(
                _random.nextDouble() * 40 - 20,
                -_random.nextDouble() * 60 - 20,
              ),
              position: Vector2(
                _random.nextDouble() * 40 - 20,
                _random.nextDouble() * 40 - 20,
              ),
              child: SequenceParticle(
                children: [
                  CircleParticle(
                    radius: 3,
                    paint: Paint()
                      ..color = const Color(0xFF00FF00).withOpacity(0.8)
                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
                    lifespan: 0.5,
                  ),
                  CircleParticle(
                    radius: 4,
                    paint: Paint()
                      ..color = const Color(0xFF00FF00).withOpacity(0.4)
                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
                    lifespan: 0.5,
                  ),
                ],
              ),
              lifespan: 2,
            ),
          
          // Healing aura
          ScalingParticle(
            to: 1.5,
            child: CircleParticle(
              radius: 40,
              paint: Paint()
                ..color = const Color(0xFF00FF00).withOpacity(0.2)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
            ),
            lifespan: 2,
          ),
        ],
        lifespan: 2.5,
      ),
    );
  }
  
  // Teleport effect
  static ParticleSystemComponent createTeleportEffect(Vector2 position) {
    return ParticleSystemComponent(
      position: position,
      particle: ComposedParticle(
        children: [
          // Vortex particles
          for (int i = 0; i < 30; i++)
            MovingParticle(
              from: Vector2(
                math.cos(i * math.pi / 15) * 50,
                math.sin(i * math.pi / 15) * 50,
              ),
              to: Vector2.zero(),
              child: RotatingParticle(
                to: math.pi * 4,
                child: CircleParticle(
                  radius: 3 + _random.nextDouble() * 3,
                  paint: Paint()
                    ..color = const Color(0xFF9D4EDD).withOpacity(0.8)
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
                ),
              ),
              curve: Curves.easeIn,
            ),
          
          // Portal effect
          for (int i = 0; i < 3; i++)
            ScalingParticle(
              from: 0.5,
              to: 2,
              child: CircleParticle(
                radius: 30,
                paint: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 2
                  ..color = const Color(0xFF9D4EDD).withOpacity(0.6 - i * 0.2)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
              ),
              lifespan: 1 + i * 0.3,
            ),
        ],
        lifespan: 1.5,
      ),
    );
  }
  
  // Footstep dust effect
  static ParticleSystemComponent createFootstepDust(Vector2 position) {
    return ParticleSystemComponent(
      position: position,
      particle: ComposedParticle(
        children: [
          for (int i = 0; i < 5; i++)
            AcceleratedParticle(
              acceleration: Vector2(0, 50),
              speed: Vector2(
                _random.nextDouble() * 20 - 10,
                -_random.nextDouble() * 10 - 5,
              ),
              position: Vector2(
                _random.nextDouble() * 10 - 5,
                0,
              ),
              child: CircleParticle(
                radius: 2 + _random.nextDouble() * 2,
                paint: Paint()
                  ..color = const Color(0xFF8B7355).withOpacity(0.4)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
              ),
              lifespan: 0.5,
            ),
        ],
        lifespan: 0.6,
      ),
    );
  }
}

// Custom heart particle
class HeartParticle extends Particle {
  final double size;
  final Color color;
  
  HeartParticle({
    required this.size,
    required this.color,
    super.lifespan,
  });
  
  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(0, size * 0.3)
      ..cubicTo(
        -size * 0.5, -size * 0.3,
        -size * 0.5, size * 0.3,
        0, size * 0.7,
      )
      ..cubicTo(
        size * 0.5, size * 0.3,
        size * 0.5, -size * 0.3,
        0, size * 0.3,
      );
    
    canvas.drawPath(path, paint);
  }
}