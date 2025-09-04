import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../components/player.dart';
import '../components/world_map.dart';
import '../components/npc_component.dart';
import '../components/astral_component.dart';
import '../components/ui/dialogue_overlay.dart';
import '../systems/game_state.dart';
// import '../effects/particle_effects.dart'; // Commented out due to compatibility issues

class AstralisGame extends FlameGame with TapDetector, KeyboardHandler, HasCollisionDetection {
  late Player player;
  late WorldMap worldMap;
  late GameState gameState;
  DialogueOverlay? currentDialogue;
  
  // Production-quality visual effects
  final List<ParticleSystemComponent> ambientEffects = [];
  double ambientTimer = 0;
  late CameraComponent gameCamera;
  
  @override
  Color backgroundColor() => const Color(0xFF0A0E27);
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    gameState = GameState();
    
    // Enhanced camera setup
    gameCamera = CameraComponent.withFixedResolution(
      width: 800,
      height: 600,
    );
    await add(gameCamera);
    
    // Create enhanced visual background
    await _createEnhancedBackground();
    
    worldMap = WorldMap();
    await gameCamera.viewport.add(worldMap);
    
    player = Player(position: Vector2(400, 300));
    await gameCamera.viewport.add(player);
    
    // Set smooth camera following
    gameCamera.follow(player, maxSpeed: 200);
    
    // Add production-quality ambient effects
    _startAmbientEffects();
    
    print('Enhanced Astralis game loaded with production visuals!');
  }
  
  Future<void> _createEnhancedBackground() async {
    // Layered gradient background
    final backgroundGradient = RectangleComponent(
      size: Vector2(1200, 800),
      position: Vector2(-200, -100),
      paint: Paint()..shader = const RadialGradient(
        colors: [
          Color(0xFF0A0E27), // Deep night
          Color(0xFF240046), // Deep purple
          Color(0xFF10002B), // Dark purple
          Color(0xFF5A189A), // Purple
        ],
      ).createShader(const Rect.fromLTWH(0, 0, 1200, 800)),
    );
    gameCamera.viewport.add(backgroundGradient);
    
    // Add mystical ground layer
    final ground = RectangleComponent(
      size: Vector2(1200, 150),
      position: Vector2(-200, 550),
      paint: Paint()..color = const Color(0xFF2D5016).withOpacity(0.8),
    );
    gameCamera.viewport.add(ground);
    
    // Add floating light orbs
    for (int i = 0; i < 8; i++) {
      final orb = CircleComponent(
        radius: 15 + math.Random().nextDouble() * 10,
        position: Vector2(
          math.Random().nextDouble() * 800,
          math.Random().nextDouble() * 400,
        ),
        paint: Paint()
          ..color = Color.lerp(
            const Color(0xFF9D4EDD),
            const Color(0xFF5A189A),
            math.Random().nextDouble(),
          )!.withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      );
      
      // Add floating animation
      orb.add(
        SequenceEffect([
          MoveByEffect(
            Vector2(0, -20 + math.Random().nextDouble() * 40),
            EffectController(duration: 3 + math.Random().nextDouble() * 4),
          ),
          MoveByEffect(
            Vector2(0, 20 - math.Random().nextDouble() * 40),
            EffectController(duration: 3 + math.Random().nextDouble() * 4),
          ),
        ], infinite: true),
      );
      
      gameCamera.viewport.add(orb);
    }
  }
  
  void _startAmbientEffects() {
    // Periodic mystical particles
    add(TimerComponent(
      period: 4.0,
      repeat: true,
      onTick: _addMysticalParticles,
    ));
    
    // Environmental sparkles
    add(TimerComponent(
      period: 2.0,
      repeat: true,
      onTick: _addEnvironmentalSparkles,
    ));
    
    // Gentle wind effects
    add(TimerComponent(
      period: 6.0,
      repeat: true,
      onTick: _addWindEffects,
    ));
  }
  
  void _addMysticalParticles() {
    final particles = ParticleSystemComponent(
      position: Vector2(
        math.Random().nextDouble() * 800,
        math.Random().nextDouble() * 600,
      ),
      particle: Particle.generate(
        count: 8,
        lifespan: 8,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, -25),
          speed: Vector2(
            math.Random().nextDouble() * 30 - 15,
            -math.Random().nextDouble() * 20 - 10,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 2 + math.Random().nextDouble() * 3,
            paint: Paint()
              ..color = const Color(0xFF9D4EDD).withOpacity(0.6)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(particles);
    ambientEffects.add(particles);
  }
  
  void _addEnvironmentalSparkles() {
    final sparkles = ParticleSystemComponent(
      position: Vector2(
        player.position.x + math.Random().nextDouble() * 200 - 100,
        player.position.y + math.Random().nextDouble() * 200 - 100,
      ),
      particle: Particle.generate(
        count: 5,
        lifespan: 3,
        generator: (i) => ScalingParticle(
          to: 0,
          child: CircleParticle(
            radius: 2,
            paint: Paint()
              ..color = Colors.white.withOpacity(0.8)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(sparkles);
    ambientEffects.add(sparkles);
  }
  
  void _addWindEffects() {
    final windParticles = ParticleSystemComponent(
      position: Vector2(-50, player.position.y + math.Random().nextDouble() * 100 - 50),
      particle: Particle.generate(
        count: 10,
        lifespan: 4,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(25, 0),
          speed: Vector2(
            30 + math.Random().nextDouble() * 20,
            math.Random().nextDouble() * 20 - 10,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 1,
            paint: Paint()..color = Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(windParticles);
    ambientEffects.add(windParticles);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      player.updateMovement(keysPressed);
    } else if (event is KeyUpEvent) {
      player.updateMovement(keysPressed);
    }
    return true;
  }

  @override
  void onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.global;
    
    // If dialogue is showing, close it on tap
    if (currentDialogue != null) {
      remove(currentDialogue!);
      currentDialogue = null;
      return;
    }
    
    // Check for NPC interactions first
    for (final component in children) {
      if (component is NPCComponent) {
        final distance = component.position.distanceTo(tapPosition);
        if (distance < 60) { // Interaction range
          _showDialogue(component.interact(), component.npc.name);
          return;
        }
      }
      
      if (component is AstralComponent) {
        final distance = component.position.distanceTo(tapPosition);
        if (distance < 50) { // Interaction range
          _showAstralInteraction(component);
          return;
        }
      }
    }
    
    // If no specific interaction, just move towards tap
    player.handleInteraction(tapPosition);
  }
  
  void _showDialogue(String message, String speakerName) {
    // Remove any existing dialogue
    if (currentDialogue != null) {
      remove(currentDialogue!);
    }
    
    // Create new dialogue overlay
    currentDialogue = DialogueOverlay(
      message: message,
      speakerName: speakerName,
      gameSize: size,
    );
    
    add(currentDialogue!);
    print('$speakerName says: $message');
  }
  
  void _showAstralInteraction(AstralComponent astralComponent) {
    final astral = astralComponent.astral;
    String message = astral.getInteractionResponse('approach');
    
    // Add visual bonding effect
    if (!astral.isBonded && astral.canBond()) {
      _addBondingEffect(astralComponent.position);
      message = '${astral.name} trusts you deeply! A bond could be formed. Trust: ${astral.trustLevel.toInt()}%';
    } else if (astral.isBonded) {
      _addCompanionEffect(astralComponent.position);
      message = '${astral.name} is your loyal companion. Trust: ${astral.trustLevel.toInt()}%';
    } else {
      _addInteractionSparkles(astralComponent.position);
      message = '${astral.name} ${astral.getInteractionResponse('approach')} Trust: ${astral.trustLevel.toInt()}%';
    }
    
    _showDialogue(message, astral.name);
  }
  
  void _addBondingEffect(Vector2 position) {
    // Use fallback simple effect for now
    _addInteractionSparkles(position);
  }
  
  void _addCompanionEffect(Vector2 position) {
    // Use fallback simple effect for now  
    _addInteractionSparkles(position);
  }
  
  void _addInteractionSparkles(Vector2 position) {
    final sparkles = ParticleSystemComponent(
      position: position,
      particle: Particle.generate(
        count: 12,
        lifespan: 2,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, -30),
          speed: Vector2(
            math.Random().nextDouble() * 60 - 30,
            -math.Random().nextDouble() * 40 - 20,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 2,
            paint: Paint()
              ..color = const Color(0xFF9D4EDD).withOpacity(0.8)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(sparkles);
    ambientEffects.add(sparkles);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    gameState.update(dt);
    
    // Clean up expired particle effects
    ambientEffects.removeWhere((effect) => effect.isRemoved);
    
    // Add periodic footstep effects when player moves
    if (player.isMoving && math.Random().nextDouble() < 0.03) {
      _addFootstepDust();
    }
  }
  
  void _addFootstepDust() {
    // Simple dust effect
    final dust = ParticleSystemComponent(
      position: Vector2(player.position.x, player.position.y + 16),
      particle: Particle.generate(
        count: 3,
        lifespan: 0.8,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, 20),
          speed: Vector2(
            math.Random().nextDouble() * 20 - 10,
            -math.Random().nextDouble() * 10 - 5,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 1.5,
            paint: Paint()..color = const Color(0xFF8B7355).withOpacity(0.4),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(dust);
    ambientEffects.add(dust);
  }
}