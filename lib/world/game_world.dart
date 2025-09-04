import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../components/player.dart';
import '../models/astral.dart';
import '../models/npc.dart';
import '../systems/map_manager.dart';
import '../systems/sprite_manager.dart';
import '../effects/particle_effects.dart';
import '../ui/dialogue_overlay.dart';
import '../ui/hud_overlay.dart';
import '../ui/bonding_overlay.dart';

class GameWorld extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  late Player player;
  late MapManager mapManager;
  late SpriteManager spriteManager;
  late CameraComponent gameCamera;
  late HudOverlay hudOverlay;
  
  final List<Astral> wildAstrals = [];
  final List<NPC> npcs = [];
  final Set<LogicalKeyboardKey> pressedKeys = {};
  
  // Game state
  bool isInDialogue = false;
  bool isInBattle = false;
  bool isPaused = false;
  
  // Visual effects
  final List<ParticleSystemComponent> activeEffects = [];
  double _ambientTime = 0;
  
  @override
  Color backgroundColor() => const Color(0xFF1a1a2e);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Initialize systems
    await _initializeSystems();
    
    // Set up camera
    await _setupCamera();
    
    // Create game world
    await _createGameWorld();
    
    // Set up UI
    await _setupUI();
    
    // Start ambient systems
    _startAmbientSystems();
  }
  
  Future<void> _initializeSystems() async {
    // Initialize sprite manager
    spriteManager = SpriteManager();
    await spriteManager.initialize();
    
    // Initialize map manager
    mapManager = MapManager();
    await add(mapManager);
    
    print('Game systems initialized');
  }
  
  Future<void> _setupCamera() async {
    gameCamera = CameraComponent.withFixedResolution(
      width: 800,
      height: 600,
    );
    
    // Add smooth camera follow behavior
    gameCamera.viewfinder.visibleGameSize = Vector2(800, 600);
    
    await add(gameCamera);
  }
  
  Future<void> _createGameWorld() async {
    // Create player
    player = Player(
      position: Vector2(400, 300),
    );
    
    await gameCamera.viewport.add(player);
    
    // Load starting map
    await mapManager.loadMap('starting_grove');
    
    // Position player at spawn point
    player.position = mapManager.getSpawnPosition();
    
    // Create initial NPCs and wild Astrals
    await _populateWorld();
    
    // Set camera to follow player
    gameCamera.follow(player, maxSpeed: 200);
    
    print('Game world created with player at ${player.position}');
  }
  
  Future<void> _populateWorld() async {
    // Add Elder Kaelan NPC
    final elderKaelan = NPC(
      position: Vector2(350, 250),
      name: 'Elder Kaelan',
      dialogue: [
        'Welcome to the Grove of Beginnings, young Shaman.',
        'Here, the first bonds between human and Astral are formed.',
        'Remember, trust is the foundation of all true partnerships.',
        'Show care to the Astrals, and they will respond in kind.',
      ],
      npcType: NPCType.elder,
    );
    
    npcs.add(elderKaelan);
    await gameCamera.viewport.add(elderKaelan);
    
    // Add wild Astrals for bonding
    await _spawnWildAstrals();
  }
  
  Future<void> _spawnWildAstrals() async {
    final astralPositions = [
      Vector2(300, 400),
      Vector2(500, 350),
      Vector2(250, 450),
    ];
    
    for (int i = 0; i < astralPositions.length; i++) {
      final species = ['Tuki', 'Cindcub', 'Rylotl'][i % 3];
      final astral = Astral.fromSpecies(
        species: species,
        level: 1 + math.Random().nextInt(3),
        position: astralPositions[i],
      );
      
      wildAstrals.add(astral);
      await gameCamera.viewport.add(astral);
      
      // Add gentle glow effect around wild Astrals
      _addAstralAura(astral);
    }
    
    print('Spawned ${wildAstrals.length} wild Astrals');
  }
  
  void _addAstralAura(Astral astral) {
    final aura = ParticleSystemComponent(
      position: astral.position,
      particle: CircleParticle(
        radius: 25,
        paint: Paint()
          ..color = _getAstralElementColor(astral.species).withOpacity(0.1)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15),
        lifespan: double.infinity,
      ),
    );
    
    gameCamera.viewport.add(aura);
    activeEffects.add(aura);
    
    // Make aura follow the Astral
    aura.add(
      MoveToEffect(
        astral.position,
        EffectController(duration: 0.1),
      ),
    );
  }
  
  Color _getAstralElementColor(String species) {
    switch (species.toLowerCase()) {
      case 'tuki':
        return const Color(0xFF90EE90); // Light green
      case 'cindcub':
        return const Color(0xFFFF6347); // Tomato red
      case 'rylotl':
        return const Color(0xFF1E90FF); // Dodger blue
      case 'rowletch':
        return const Color(0xFF8B4513); // Saddle brown
      case 'peavee':
        return const Color(0xFFFFD700); // Gold
      default:
        return const Color(0xFF9D4EDD); // Purple
    }
  }
  
  Future<void> _setupUI() async {
    // Create HUD overlay
    hudOverlay = HudOverlay(player: player);
    await add(hudOverlay);
    
    print('UI systems initialized');
  }
  
  void _startAmbientSystems() {
    // Add periodic ambient effects
    add(
      TimerComponent(
        period: 5.0,
        repeat: true,
        onTick: _addAmbientEffects,
      ),
    );
    
    // Add dynamic lighting cycle
    add(
      TimerComponent(
        period: 0.1,
        repeat: true,
        onTick: _updateLighting,
      ),
    );
  }
  
  void _addAmbientEffects() {
    if (isPaused || isInBattle) return;
    
    // Add random environmental effects
    final effects = [
      _createFireflies,
      _createWindParticles,
      _createMagicSparkles,
    ];
    
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
        count: 5,
        lifespan: 8,
        generator: (i) => MovingParticle(
          from: Vector2.zero(),
          to: Vector2(
            math.Random().nextDouble() * 100 - 50,
            math.Random().nextDouble() * 100 - 50,
          ),
          child: ScalingParticle(
            to: 0,
            child: CircleParticle(
              radius: 2,
              paint: Paint()
                ..color = const Color(0xFFFFFF00).withOpacity(0.8)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
            ),
          ),
          curve: Curves.easeInOut,
        ),
      ),
    );
    
    gameCamera.viewport.add(fireflies);
    activeEffects.add(fireflies);
  }
  
  void _createWindParticles() {
    final windEffect = ParticleSystemComponent(
      position: Vector2(
        player.position.x - 100,
        player.position.y + math.Random().nextDouble() * 100 - 50,
      ),
      particle: Particle.generate(
        count: 8,
        lifespan: 4,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(20, 0),
          speed: Vector2(
            30 + math.Random().nextDouble() * 20,
            math.Random().nextDouble() * 20 - 10,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 1,
            paint: Paint()
              ..color = Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(windEffect);
    activeEffects.add(windEffect);
  }
  
  void _createMagicSparkles() {
    final sparkles = ParticleSystemComponent(
      position: Vector2(
        player.position.x + math.Random().nextDouble() * 150 - 75,
        player.position.y + math.Random().nextDouble() * 150 - 75,
      ),
      particle: Particle.generate(
        count: 12,
        lifespan: 3,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(0, -30),
          speed: Vector2(
            math.Random().nextDouble() * 40 - 20,
            -math.Random().nextDouble() * 20 - 10,
          ),
          position: Vector2.zero(),
          child: CircleParticle(
            radius: 1.5,
            paint: Paint()
              ..color = const Color(0xFF9D4EDD).withOpacity(0.7)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
          ),
        ),
      ),
    );
    
    gameCamera.viewport.add(sparkles);
    activeEffects.add(sparkles);
  }
  
  void _updateLighting() {
    _ambientTime += 0.1;
    // Could implement day/night cycle here
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (isPaused) return;
    
    // Handle player input
    _handleInput(dt);
    
    // Update interactions
    _updateInteractions();
    
    // Clean up expired effects
    _cleanupEffects();
  }
  
  void _handleInput(double dt) {
    if (isInDialogue || isInBattle) return;
    
    Vector2 movement = Vector2.zero();
    const speed = 150.0;
    
    // Movement input
    if (pressedKeys.contains(LogicalKeyboardKey.keyW) || 
        pressedKeys.contains(LogicalKeyboardKey.arrowUp)) {
      movement.y -= speed * dt;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyS) || 
        pressedKeys.contains(LogicalKeyboardKey.arrowDown)) {
      movement.y += speed * dt;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyA) || 
        pressedKeys.contains(LogicalKeyboardKey.arrowLeft)) {
      movement.x -= speed * dt;
    }
    if (pressedKeys.contains(LogicalKeyboardKey.keyD) || 
        pressedKeys.contains(LogicalKeyboardKey.arrowRight)) {
      movement.x += speed * dt;
    }
    
    // Apply movement
    if (movement != Vector2.zero()) {
      final newPosition = player.position + movement;
      
      // Check boundaries and collisions
      if (mapManager.isWalkable(newPosition)) {
        player.position = newPosition;
        player.updateMovement(pressedKeys);
        
        // Add footstep effects
        if (math.Random().nextDouble() < 0.1) {
          _addFootstepEffect();
        }
      }
    }
  }
  
  void _addFootstepEffect() {
    final footstep = ParticleEffects.createFootstepDust(
      Vector2(player.position.x, player.position.y + 16),
    );
    
    gameCamera.viewport.add(footstep);
    activeEffects.add(footstep);
  }
  
  void _updateInteractions() {
    // Check NPC interactions
    for (final npc in npcs) {
      if (player.position.distanceTo(npc.position) < 40) {
        npc.showInteractionIndicator();
        
        // Auto-interact when space is pressed
        if (pressedKeys.contains(LogicalKeyboardKey.space)) {
          _interactWithNPC(npc);
        }
      } else {
        npc.hideInteractionIndicator();
      }
    }
    
    // Check Astral interactions
    for (final astral in wildAstrals) {
      if (player.position.distanceTo(astral.position) < 35) {
        // Show interaction possibility
        if (pressedKeys.contains(LogicalKeyboardKey.space)) {
          _interactWithAstral(astral);
        }
      }
    }
  }
  
  void _interactWithNPC(NPC npc) {
    if (isInDialogue) return;
    
    isInDialogue = true;
    
    // Create dialogue overlay
    final dialogueOverlay = DialogueOverlay(
      npc: npc,
      onComplete: () {
        isInDialogue = false;
      },
    );
    
    add(dialogueOverlay);
  }
  
  void _interactWithAstral(Astral astral) {
    if (isInDialogue || isInBattle) return;
    
    // Create bonding interaction
    isInDialogue = true;
    
    // Add bonding effect
    final bondEffect = ParticleEffects.createBondingEffect(astral.position);
    gameCamera.viewport.add(bondEffect);
    activeEffects.add(bondEffect);
    
    // Create bonding overlay
    final bondingOverlay = BondingOverlay(
      astral: astral,
      player: player,
      onComplete: (bool success) {
        isInDialogue = false;
        
        if (success) {
          // Astral was successfully bonded
          _handleSuccessfulBond(astral);
        }
      },
    );
    
    add(bondingOverlay);
  }
  
  void _handleSuccessfulBond(Astral astral) {
    // Remove from wild Astrals
    wildAstrals.remove(astral);
    astral.removeFromParent();
    
    // Add to player's team
    // player.bondedAstrals.add(astral); // TODO: Implement bonded astrals list
    
    // Create celebration effect
    final celebrationEffect = ParticleEffects.createEvolutionEffect(astral.position);
    gameCamera.viewport.add(celebrationEffect);
    activeEffects.add(celebrationEffect);
    
    print('${astral.nickname} has been bonded!!');
  }
  
  void _cleanupEffects() {
    activeEffects.removeWhere((effect) {
      if (effect.isRemoved) {
        return true;
      }
      return false;
    });
  }
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    pressedKeys.clear();
    pressedKeys.addAll(keysPressed);
    
    // Handle special keys
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _togglePause();
        return true;
      }
      
      if (event.logicalKey == LogicalKeyboardKey.keyI) {
        _openInventory();
        return true;
      }
      
      if (event.logicalKey == LogicalKeyboardKey.keyM) {
        _openMap();
        return true;
      }
    }
    
    return true;
  }
  
  void _togglePause() {
    isPaused = !isPaused;
    print('Game ${isPaused ? 'paused' : 'unpaused'}');
  }
  
  void _openInventory() {
    // TODO: Implement inventory overlay
    print('Opening inventory...');
  }
  
  void _openMap() {
    // TODO: Implement map overlay
    print('Opening map...');
  }
  
  // Map transition
  Future<void> changeMap(String newMapName, Vector2 spawnPosition) async {
    // Add transition effect
    final transition = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.black.withOpacity(0),
      priority: 1000,
    );
    
    add(transition);
    
    transition.add(
      OpacityEffect.to(
        1.0,
        EffectController(duration: 0.5),
        onComplete: () async {
          // Change map
          await mapManager.loadMap(newMapName);
          
          // Move player
          player.position = spawnPosition;
          
          // Clear old effects
          for (final effect in activeEffects) {
            effect.removeFromParent();
          }
          activeEffects.clear();
          
          // Fade back in
          transition.add(
            OpacityEffect.to(
              0.0,
              EffectController(duration: 0.5),
              onComplete: () => transition.removeFromParent(),
            ),
          );
        },
      ),
    );
  }
  
  @override
  void onRemove() {
    for (final effect in activeEffects) {
      effect.removeFromParent();
    }
    activeEffects.clear();
    super.onRemove();
  }
}