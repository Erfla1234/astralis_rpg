import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../components/player.dart';
import '../models/astral.dart';
import '../models/npc.dart';
import '../effects/particle_effects.dart';

class AstralisGameEnhanced extends FlameGame with HasKeyboardHandlerComponents, HasCollisionDetection {
  late Player player;
  late CameraComponent gameCamera;
  
  final List<Astral> wildAstrals = [];
  final List<NPC> npcs = [];
  final Set<LogicalKeyboardKey> pressedKeys = {};
  
  // Enhanced visual elements
  final List<ParticleSystemComponent> ambientEffects = [];
  double _ambientTime = 0;
  bool isInInteraction = false;
  
  @override
  Color backgroundColor() => const Color(0xFF0A0E27);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Set up camera with smooth following
    await _setupCamera();
    
    // Create enhanced game world
    await _createEnhancedWorld();
    
    // Start ambient systems for production quality
    _startAmbientSystems();
    
    print('Enhanced Astralis game loaded with production visuals!');
  }
  
  Future<void> _setupCamera() async {
    gameCamera = CameraComponent.withFixedResolution(
      width: 800,
      height: 600,
    );
    
    gameCamera.viewfinder.visibleGameSize = Vector2(800, 600);
    await add(gameCamera);
  }
  
  Future<void> _createEnhancedWorld() async {
    // Create enhanced environment background
    _createEnvironmentBackground();
    
    // Create player with enhanced visuals
    player = Player(position: Vector2(400, 300));
    await gameCamera.viewport.add(player);
    
    // Set camera to smoothly follow player
    gameCamera.follow(player, maxSpeed: 200);
    
    // Create NPCs with enhanced presentations
    await _createEnhancedNPCs();
    
    // Spawn wild Astrals with visual flair
    await _spawnEnhancedAstrals();
    
    // Add environmental particle effects
    _addEnvironmentalEffects();
  }
  
  void _createEnvironmentBackground() {
    // Create layered background for depth
    final baseLayer = RectangleComponent(
      size: Vector2(1200, 800),
      position: Vector2(-200, -100),
      paint: Paint()..shader = const RadialGradient(
        colors: [
          Color(0xFF0A0E27), // Deep night
          Color(0xFF240046), // Deep purple
          Color(0xFF10002B), // Dark purple
        ],
      ).createShader(const Rect.fromLTWH(0, 0, 1200, 800)),
    );
    gameCamera.viewport.add(baseLayer);
    
    // Add ground texture
    final ground = RectangleComponent(
      size: Vector2(1200, 200),
      position: Vector2(-200, 500),
      paint: Paint()..color = const Color(0xFF2D5016).withOpacity(0.7),
    );
    gameCamera.viewport.add(ground);
    
    // Add mystical boundary glow
    _addBoundaryGlow();
  }
  
  void _addBoundaryGlow() {
    // Mystical boundary effects
    final boundaryEffect = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 15,
        generator: (i) => MovingParticle(
          from: Vector2(i * 40.0, 550),
          to: Vector2(i * 40.0 + math.Random().nextDouble() * 20 - 10, 530),
          child: CircleParticle(
            radius: 2 + math.Random().nextDouble() * 3,
            paint: Paint()
              ..color = const Color(0xFF9D4EDD).withOpacity(0.6)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
          ),
          curve: Curves.easeInOut,
        ),
      ),
    );
    
    gameCamera.viewport.add(boundaryEffect);
    ambientEffects.add(boundaryEffect);
  }
  
  Future<void> _createEnhancedNPCs() async {
    // Elder Kaelan with mystical aura
    final elder = EnhancedNPC(
      position: Vector2(300, 400),
      name: 'Elder Kaelan',
      color: const Color(0xFFD4AF37), // Gold
      dialogue: [
        'Welcome to the Grove of Beginnings, young Shaman.',
        'Here, the ancient art of bonding is learned.',
        'Show patience and understanding to the Astrals.',
        'True bonds are forged through trust, not force.',
      ],
    );
    
    npcs.add(elder);
    await gameCamera.viewport.add(elder);
    
    // Add mystical aura around elder
    _addNPCAura(elder);
  }
  
  void _addNPCAura(EnhancedNPC npc) {
    final aura = ParticleSystemComponent(
      position: npc.position,
      particle: CircleParticle(
        radius: 40,
        paint: Paint()
          ..color = npc.color.withOpacity(0.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
        lifespan: double.infinity,
      ),
    );
    
    gameCamera.viewport.add(aura);
    ambientEffects.add(aura);
    
    // Make aura follow NPC
    aura.add(
      MoveToEffect(
        npc.position,
        EffectController(duration: 0.1),
      ),
    );
  }
  
  Future<void> _spawnEnhancedAstrals() async {
    final astralData = [
      {'species': 'Tuki', 'pos': Vector2(500, 350), 'color': const Color(0xFF90EE90)},
      {'species': 'Cindcub', 'pos': Vector2(250, 450), 'color': const Color(0xFFFF6347)},
      {'species': 'Rylotl', 'pos': Vector2(600, 250), 'color': const Color(0xFF1E90FF)},
    ];
    
    for (final data in astralData) {
      final astral = EnhancedAstral(
        position: data['pos'] as Vector2,
        species: data['species'] as String,
        color: data['color'] as Color,
        level: 1 + math.Random().nextInt(3),
      );
      
      wildAstrals.add(astral);
      await gameCamera.viewport.add(astral);
      
      // Add gentle particle aura
      _addAstralAura(astral);
    }
    
    print('Spawned ${wildAstrals.length} enhanced Astrals');
  }
  
  void _addAstralAura(EnhancedAstral astral) {
    final aura = ParticleSystemComponent(
      position: astral.position,
      particle: CircleParticle(
        radius: 30,
        paint: Paint()
          ..color = astral.color.withOpacity(0.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
        lifespan: double.infinity,
      ),
    );
    
    gameCamera.viewport.add(aura);
    ambientEffects.add(aura);
  }
  
  void _addEnvironmentalEffects() {
    // Floating mystical particles
    _createFloatingParticles();
    
    // Gentle light beams
    _createLightBeams();
    
    // Environmental sparkles
    _createEnvironmentalSparkles();
  }
  
  void _createFloatingParticles() {
    for (int i = 0; i < 15; i++) {
      Future.delayed(Duration(milliseconds: i * 400), () {
        if (isMounted) {
          final particle = ParticleSystemComponent(
            position: Vector2(
              math.Random().nextDouble() * 800,
              600,
            ),
            particle: AcceleratedParticle(
              acceleration: Vector2(0, -20),
              speed: Vector2(
                math.Random().nextDouble() * 30 - 15,
                -math.Random().nextDouble() * 40 - 20,
              ),
              position: Vector2.zero(),
              child: CircleParticle(
                radius: 2 + math.Random().nextDouble() * 3,
                paint: Paint()
                  ..color = Color.lerp(
                    const Color(0xFF9D4EDD),
                    const Color(0xFF5A189A),
                    math.Random().nextDouble(),
                  )!.withOpacity(0.4)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
              ),
              lifespan: 8,
            ),
          );
          
          gameCamera.viewport.add(particle);
          ambientEffects.add(particle);
        }
      });
    }
  }
  
  void _createLightBeams() {
    for (int i = 0; i < 3; i++) {
      final beam = RectangleComponent(
        size: Vector2(8, 400),
        position: Vector2(200 + i * 200.0, 100),
        paint: Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Color(0xFFFFD700),
              Colors.transparent,
            ],
          ).createShader(const Rect.fromLTWH(0, 0, 8, 400))
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
      );
      
      // Add gentle swaying animation
      beam.add(
        SequenceEffect([
          MoveByEffect(
            Vector2(math.sin(i * math.pi / 3) * 20, 0),
            EffectController(duration: 4, curve: Curves.easeInOut),
          ),
          MoveByEffect(
            Vector2(-math.sin(i * math.pi / 3) * 20, 0),
            EffectController(duration: 4, curve: Curves.easeInOut),
          ),
        ], infinite: true),
      );
      
      gameCamera.viewport.add(beam);
    }
  }
  
  void _createEnvironmentalSparkles() {
    final sparkles = TimerComponent(
      period: 2.0,
      repeat: true,
      onTick: () {
        if (!isInInteraction) {
          final sparkle = ParticleSystemComponent(
            position: Vector2(
              math.Random().nextDouble() * 800,
              math.Random().nextDouble() * 600,
            ),
            particle: ScalingParticle(
              to: 0,
              child: CircleParticle(
                radius: 3,
                paint: Paint()
                  ..color = Colors.white.withOpacity(0.8)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
              ),
              lifespan: 1,
            ),
          );
          
          gameCamera.viewport.add(sparkle);
        }
      },
    );
    
    add(sparkles);
  }
  
  void _startAmbientSystems() {
    // Periodic ambient enhancement
    add(
      TimerComponent(
        period: 6.0,
        repeat: true,
        onTick: _addPeriodicAmbientEffects,
      ),
    );
  }
  
  void _addPeriodicAmbientEffects() {
    if (isInInteraction) return;
    
    // Add random magical effects
    final effects = [_createFireflies, _createMagicSparkles, _createWindEffect];
    final randomEffect = effects[math.Random().nextInt(effects.length)];
    randomEffect();
  }
  
  void _createFireflies() {
    final fireflies = ParticleSystemComponent(
      position: Vector2(
        player.position.x + math.Random().nextDouble() * 200 - 100,
        player.position.y + math.Random().nextDouble() * 200 - 100,
      ),
      particle: Particle.generate(
        count: 8,
        lifespan: 12,
        generator: (i) => MovingParticle(
          from: Vector2.zero(),
          to: Vector2(
            math.Random().nextDouble() * 150 - 75,
            math.Random().nextDouble() * 150 - 75,
          ),
          child: SequenceEffect([
            ScalingParticle(
              to: 1.2,
              child: CircleParticle(
                radius: 2,
                paint: Paint()
                  ..color = const Color(0xFFFFFF00).withOpacity(0.8)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
              ),
              lifespan: 0.5,
            ),
            ScalingParticle(
              to: 0.8,
              child: CircleParticle(
                radius: 2,
                paint: Paint()
                  ..color = const Color(0xFFFFFF00).withOpacity(0.6)
                  ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
              ),
              lifespan: 0.5,
            ),
          ], infinite: true),
          curve: Curves.easeInOut,
        ),
      ),
    );
    
    gameCamera.viewport.add(fireflies);
    ambientEffects.add(fireflies);
  }
  
  void _createMagicSparkles() {
    final sparkles = ParticleSystemComponent(
      position: Vector2(
        player.position.x + math.Random().nextDouble() * 100 - 50,
        player.position.y + math.Random().nextDouble() * 100 - 50,
      ),
      particle: Particle.generate(
        count: 20,
        lifespan: 4,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, -50),
          speed: Vector2(
            math.Random().nextDouble() * 60 - 30,
            -math.Random().nextDouble() * 30 - 15,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 1.5,
            paint: Paint()
              ..color = const Color(0xFF9D4EDD).withOpacity(0.7)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(sparkles);
    ambientEffects.add(sparkles);
  }
  
  void _createWindEffect() {
    final wind = ParticleSystemComponent(
      position: Vector2(-50, player.position.y + math.Random().nextDouble() * 100 - 50),
      particle: Particle.generate(
        count: 12,
        lifespan: 5,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(30, 0),
          speed: Vector2(
            40 + math.Random().nextDouble() * 20,
            math.Random().nextDouble() * 30 - 15,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 1,
            paint: Paint()
              ..color = Colors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(wind);
    ambientEffects.add(wind);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _ambientTime += dt;
    
    // Handle player input
    _handleMovementInput(dt);
    
    // Check for interactions
    _checkInteractions();
    
    // Clean up expired effects
    _cleanupExpiredEffects();
  }
  
  void _handleMovementInput(double dt) {
    if (isInInteraction) return;
    
    player.updateMovement(pressedKeys);
    
    // Add subtle footstep effects when moving
    if (player.isMoving && math.Random().nextDouble() < 0.05) {
      _addFootstepEffect();
    }
  }
  
  void _addFootstepEffect() {
    final footstep = ParticleEffects.createFootstepDust(
      Vector2(player.position.x, player.position.y + 16),
    );
    
    gameCamera.viewport.add(footstep);
    ambientEffects.add(footstep);
  }
  
  void _checkInteractions() {
    // Check NPC interactions
    for (final npc in npcs) {
      if (npc is EnhancedNPC) {
        if (player.position.distanceTo(npc.position) < 50) {
          npc.showInteractionHint();
          
          if (pressedKeys.contains(LogicalKeyboardKey.space)) {
            _startNPCInteraction(npc);
          }
        } else {
          npc.hideInteractionHint();
        }
      }
    }
    
    // Check Astral interactions
    for (final astral in wildAstrals) {
      if (astral is EnhancedAstral) {
        if (player.position.distanceTo(astral.position) < 45) {
          if (pressedKeys.contains(LogicalKeyboardKey.space)) {
            _startAstralBonding(astral);
          }
        }
      }
    }
  }
  
  void _startNPCInteraction(EnhancedNPC npc) {
    if (isInInteraction) return;
    
    isInInteraction = true;
    
    // Create simple dialogue display
    final dialogue = SimpleDialogue(
      npc: npc,
      onComplete: () {
        isInInteraction = false;
      },
    );
    
    add(dialogue);
  }
  
  void _startAstralBonding(EnhancedAstral astral) {
    if (isInInteraction) return;
    
    isInInteraction = true;
    
    // Create bonding visual effect
    final bondEffect = ParticleEffects.createBondingEffect(astral.position);
    gameCamera.viewport.add(bondEffect);
    ambientEffects.add(bondEffect);
    
    // Simple bonding interaction
    final bonding = SimpleBonding(
      astral: astral,
      onComplete: (bool success) {
        isInInteraction = false;
        
        if (success) {
          _completeBonding(astral);
        }
      },
    );
    
    add(bonding);
  }
  
  void _completeBonding(EnhancedAstral astral) {
    // Remove from wild
    wildAstrals.remove(astral);
    astral.removeFromParent();
    
    // Create celebration effect
    final celebration = ParticleEffects.createEvolutionEffect(astral.position);
    gameCamera.viewport.add(celebration);
    ambientEffects.add(celebration);
    
    print('${astral.species} has been successfully bonded!');
  }
  
  void _cleanupExpiredEffects() {
    ambientEffects.removeWhere((effect) => effect.isRemoved);
  }
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    pressedKeys.clear();
    pressedKeys.addAll(keysPressed);
    
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape && isInInteraction) {
        isInInteraction = false;
        return true;
      }
    }
    
    return true;
  }
}

// Enhanced NPC with visual effects
class EnhancedNPC extends NPC {
  final Color color;
  final List<String> dialogue;
  late RectangleComponent interactionHint;
  bool hintVisible = false;
  
  EnhancedNPC({
    required Vector2 position,
    required String name,
    required this.color,
    required this.dialogue,
  }) : super(position: position, name: name, npcType: NPCType.elder);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Enhanced visual representation
    add(CircleComponent(
      radius: 20,
      paint: Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      anchor: Anchor.center,
    ));
    
    // Inner glow
    add(CircleComponent(
      radius: 12,
      paint: Paint()
        ..color = Colors.white.withOpacity(0.6),
      anchor: Anchor.center,
    ));
    
    // Interaction hint
    interactionHint = RectangleComponent(
      size: Vector2(60, 20),
      position: Vector2(-30, -50),
      paint: Paint()
        ..color = const Color(0xFF240046).withOpacity(0.9),
    );
    
    final hintText = TextComponent(
      text: 'Press SPACE',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 10,
          color: Colors.white,
        ),
      ),
      position: Vector2(-25, -45),
    );
    
    interactionHint.add(hintText);
    interactionHint.opacity = 0;
    add(interactionHint);
  }
  
  void showInteractionHint() {
    if (!hintVisible) {
      hintVisible = true;
      interactionHint.add(
        OpacityEffect.to(1.0, EffectController(duration: 0.3)),
      );
    }
  }
  
  void hideInteractionHint() {
    if (hintVisible) {
      hintVisible = false;
      interactionHint.add(
        OpacityEffect.to(0.0, EffectController(duration: 0.3)),
      );
    }
  }
}

// Enhanced Astral with visual effects
class EnhancedAstral extends Astral {
  final Color color;
  
  EnhancedAstral({
    required Vector2 position,
    required String species,
    required this.color,
    required int level,
  }) : super(
    species: species,
    level: level,
    personality: AstralPersonality.curious,
    position: position,
  );
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Enhanced visual with species-appropriate color
    add(CircleComponent(
      radius: 16,
      paint: Paint()
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      anchor: Anchor.center,
    ));
    
    // Inner highlight
    add(CircleComponent(
      radius: 8,
      paint: Paint()
        ..color = Colors.white.withOpacity(0.4),
      anchor: Anchor.center,
    ));
    
    // Add gentle pulsing animation
    add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.1),
          EffectController(duration: 2, curve: Curves.easeInOut),
        ),
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 2, curve: Curves.easeInOut),
        ),
      ], infinite: true),
    );
  }
}

// Simple dialogue system
class SimpleDialogue extends Component {
  final EnhancedNPC npc;
  final VoidCallback onComplete;
  
  late RectangleComponent background;
  late TextComponent dialogueText;
  int currentIndex = 0;
  
  SimpleDialogue({required this.npc, required this.onComplete});
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Semi-transparent background
    background = RectangleComponent(
      size: Vector2(800, 600),
      paint: Paint()..color = Colors.black.withOpacity(0.6),
      priority: 1000,
    );
    add(background);
    
    // Dialogue box
    final dialogueBox = RectangleComponent(
      size: Vector2(600, 100),
      position: Vector2(100, 450),
      paint: Paint()
        ..color = const Color(0xFF240046).withOpacity(0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      priority: 1001,
    );
    add(dialogueBox);
    
    // Dialogue text
    dialogueText = TextComponent(
      text: npc.dialogue[currentIndex],
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      position: Vector2(120, 480),
      priority: 1002,
    );
    add(dialogueText);
    
    // Continue text
    final continueText = TextComponent(
      text: 'Press SPACE to continue, ESC to exit',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
      position: Vector2(120, 520),
      priority: 1002,
    );
    add(continueText);
  }
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        _nextDialogue();
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _exitDialogue();
        return true;
      }
    }
    return false;
  }
  
  void _nextDialogue() {
    currentIndex++;
    if (currentIndex >= npc.dialogue.length) {
      _exitDialogue();
    } else {
      dialogueText.text = npc.dialogue[currentIndex];
    }
  }
  
  void _exitDialogue() {
    removeFromParent();
    onComplete();
  }
}

// Simple bonding system
class SimpleBonding extends Component {
  final EnhancedAstral astral;
  final Function(bool) onComplete;
  
  late RectangleComponent background;
  late TextComponent bondText;
  int bondPoints = 0;
  int attempts = 0;
  
  SimpleBonding({required this.astral, required this.onComplete});
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Semi-transparent background
    background = RectangleComponent(
      size: Vector2(800, 600),
      paint: Paint()..color = Colors.black.withOpacity(0.6),
      priority: 1000,
    );
    add(background);
    
    // Bonding interface
    final bondingBox = RectangleComponent(
      size: Vector2(400, 200),
      position: Vector2(200, 200),
      paint: Paint()
        ..color = const Color(0xFF240046).withOpacity(0.9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      priority: 1001,
    );
    add(bondingBox);
    
    // Bond text
    bondText = TextComponent(
      text: 'Attempting to bond with ${astral.species}...\n\nPress SPACE to show care\nPress ESC to give up',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      position: Vector2(220, 240),
      priority: 1002,
    );
    add(bondText);
  }
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space) {
        _attemptBond();
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _exitBonding(false);
        return true;
      }
    }
    return false;
  }
  
  void _attemptBond() {
    attempts++;
    bondPoints += 20 + math.Random().nextInt(30);
    
    if (bondPoints >= 80) {
      bondText.text = '${astral.species} trusts you!\n\nBonding successful! 🎉';
      Future.delayed(const Duration(seconds: 2), () => _exitBonding(true));
    } else if (attempts >= 3) {
      bondText.text = '${astral.species} remains wary.\n\nMaybe try again later.';
      Future.delayed(const Duration(seconds: 2), () => _exitBonding(false));
    } else {
      bondText.text = '${astral.species} is warming up to you...\n\nBond: $bondPoints/80\nAttempts: $attempts/3\n\nPress SPACE to continue showing care';
    }
  }
  
  void _exitBonding(bool success) {
    removeFromParent();
    onComplete(success);
  }
}