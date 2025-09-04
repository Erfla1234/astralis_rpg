import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/services.dart';
import '../components/player.dart';
import '../components/npc_component.dart';
import '../components/astral_component.dart';
import '../models/npc.dart';
import '../models/astral.dart';

class TiledMapManager extends Component {
  late TiledComponent tiledMap;
  final String mapName;
  final Function(String) onRegionChange;
  
  // Spawn points from Tiled object layers
  final List<Vector2> npcSpawnPoints = [];
  final List<Vector2> astralSpawnPoints = [];
  final List<Vector2> itemSpawnPoints = [];
  final Vector2? playerSpawnPoint;
  
  TiledMapManager({
    required this.mapName,
    required this.onRegionChange,
    this.playerSpawnPoint,
  });
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    try {
      // Load the Tiled map
      tiledMap = await TiledComponent.load(
        '$mapName.tmx',
        Vector2.all(16), // Tile size
      );
      
      await add(tiledMap);
      
      // Process object layers for spawn points and interactions
      _processObjectLayers();
      
      // Set up collision layers
      _setupCollisions();
      
      // Initialize region triggers
      _setupRegionTriggers();
      
    } catch (e) {
      print('Error loading Tiled map: $e');
      // Fall back to procedural generation if Tiled map not found
      await _createProceduralMap();
    }
  }
  
  void _processObjectLayers() {
    final map = tiledMap.tileMap;
    
    // Process spawn layers
    for (final layer in map.layers) {
      if (layer.name == 'NPCSpawns') {
        for (final obj in (layer as ObjectLayer).objects) {
          npcSpawnPoints.add(Vector2(obj.x, obj.y));
          _spawnNPCAtPosition(obj);
        }
      } else if (layer.name == 'AstralSpawns') {
        for (final obj in (layer as ObjectLayer).objects) {
          astralSpawnPoints.add(Vector2(obj.x, obj.y));
          _spawnAstralAtPosition(obj);
        }
      } else if (layer.name == 'Items') {
        for (final obj in (layer as ObjectLayer).objects) {
          itemSpawnPoints.add(Vector2(obj.x, obj.y));
          _createItemAtPosition(obj);
        }
      } else if (layer.name == 'Triggers') {
        for (final obj in (layer as ObjectLayer).objects) {
          _createTriggerZone(obj);
        }
      }
    }
  }
  
  void _setupCollisions() {
    final map = tiledMap.tileMap;
    
    // Find collision layer
    final collisionLayer = map.layers.firstWhere(
      (layer) => layer.name == 'Collision',
      orElse: () => map.layers.first,
    );
    
    if (collisionLayer is TileLayer) {
      // Create collision hitboxes for solid tiles
      for (var y = 0; y < collisionLayer.height; y++) {
        for (var x = 0; x < collisionLayer.width; x++) {
          final tile = collisionLayer.tiles[y][x];
          if (tile != null && tile.tileId != 0) {
            // Add collision component at this position
            final position = Vector2(x * 16.0, y * 16.0);
            final collisionBox = RectangleHitbox(
              position: position,
              size: Vector2.all(16),
            );
            add(collisionBox);
          }
        }
      }
    }
  }
  
  void _setupRegionTriggers() {
    // Define region boundaries for triggering events
    final regionTriggers = {
      'grove_to_tide': Rect.fromLTWH(400, 600, 100, 50),
      'tide_to_hollow': Rect.fromLTWH(800, 400, 100, 50),
      'hollow_to_ore': Rect.fromLTWH(1000, 800, 100, 50),
    };
    
    for (final entry in regionTriggers.entries) {
      final trigger = RegionTrigger(
        area: entry.value,
        onEnter: () => onRegionChange(entry.key),
      );
      add(trigger);
    }
  }
  
  void _spawnNPCAtPosition(TiledObject obj) {
    // Get NPC type from Tiled properties
    final npcType = obj.properties['type'] as String? ?? 'villager';
    final npcName = obj.properties['name'] as String? ?? 'Unknown';
    
    // Create NPC based on Tiled data
    final npc = NPC(
      id: 'tiled_${obj.id}',
      name: npcName,
      role: _getNPCRoleFromString(npcType),
      description: obj.properties['description'] as String? ?? 'A mysterious figure.',
      position: Vector2(obj.x, obj.y),
      dialogueTrees: _createDialogueFromTiled(obj),
    );
    
    final npcComponent = NPCComponent(npc: npc);
    add(npcComponent);
  }
  
  void _spawnAstralAtPosition(TiledObject obj) {
    final astralType = obj.properties['type'] as String? ?? 'neutral';
    final astralName = obj.properties['name'] as String? ?? 'Wild Astral';
    
    final astral = Astral(
      id: 'tiled_${obj.id}',
      name: astralName,
      type: _getAstralTypeFromString(astralType),
      personality: _getPersonalityFromString(obj.properties['personality'] as String? ?? 'gentle'),
      description: obj.properties['description'] as String? ?? 'A wild Astral roams here.',
      position: Vector2(obj.x, obj.y),
    );
    
    final astralComponent = AstralComponent(astral: astral);
    add(astralComponent);
  }
  
  void _createItemAtPosition(TiledObject obj) {
    // Create collectible items or interactive objects
    final itemType = obj.properties['type'] as String? ?? 'potion';
    final itemName = obj.properties['name'] as String? ?? 'Unknown Item';
    
    // TODO: Implement item system
  }
  
  void _createTriggerZone(TiledObject obj) {
    final triggerType = obj.properties['trigger'] as String? ?? 'event';
    final triggerAction = obj.properties['action'] as String? ?? '';
    
    // Create trigger zones for cutscenes, battles, etc.
  }
  
  NPCRole _getNPCRoleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'elder':
        return NPCRole.elder;
      case 'merchant':
        return NPCRole.merchant;
      case 'rival':
        return NPCRole.rival;
      case 'guardian':
        return NPCRole.guardian;
      case 'priest':
        return NPCRole.priest;
      case 'scholar':
        return NPCRole.scholar;
      case 'guide':
        return NPCRole.guide;
      default:
        return NPCRole.villager;
    }
  }
  
  AstralType _getAstralTypeFromString(String type) {
    switch (type.toLowerCase()) {
      case 'flame':
        return AstralType.flame;
      case 'water':
        return AstralType.water;
      case 'earth':
        return AstralType.earth;
      case 'wind':
        return AstralType.wind;
      case 'electric':
        return AstralType.electric;
      case 'ice':
        return AstralType.ice;
      case 'nature':
        return AstralType.nature;
      case 'shadow':
        return AstralType.shadow;
      case 'crystal':
        return AstralType.crystal;
      default:
        return AstralType.luminous;
    }
  }
  
  AstralPersonality _getPersonalityFromString(String personality) {
    switch (personality.toLowerCase()) {
      case 'gentle':
        return AstralPersonality.gentle;
      case 'brave':
        return AstralPersonality.brave;
      case 'playful':
        return AstralPersonality.playful;
      case 'wise':
        return AstralPersonality.wise;
      case 'mysterious':
        return AstralPersonality.mysterious;
      case 'protective':
        return AstralPersonality.protective;
      case 'energetic':
        return AstralPersonality.energetic;
      case 'calm':
        return AstralPersonality.calm;
      case 'curious':
        return AstralPersonality.curious;
      case 'noble':
        return AstralPersonality.noble;
      default:
        return AstralPersonality.gentle;
    }
  }
  
  Map<String, DialogueTree> _createDialogueFromTiled(TiledObject obj) {
    // Parse dialogue from Tiled properties
    final greeting = obj.properties['greeting'] as String? ?? 'Hello, traveler.';
    final response1 = obj.properties['response1'] as String? ?? 'Nice to meet you.';
    final response2 = obj.properties['response2'] as String? ?? 'Take care on your journey.';
    
    return {
      'default': DialogueTree(
        greeting: greeting,
        options: [
          DialogueOption(
            text: 'Tell me about this area.',
            response: response1,
          ),
          DialogueOption(
            text: 'Do you have any advice?',
            response: response2,
          ),
        ],
      ),
    };
  }
  
  // Fallback procedural generation if no Tiled map
  Future<void> _createProceduralMap() async {
    // Create a basic tilemap programmatically
    final tileSize = 32.0;
    final mapWidth = 50;
    final mapHeight = 50;
    
    // Generate terrain layers
    for (var y = 0; y < mapHeight; y++) {
      for (var x = 0; x < mapWidth; x++) {
        final position = Vector2(x * tileSize, y * tileSize);
        
        // Create terrain tile based on position
        final terrainType = _getTerrainType(x, y, mapWidth, mapHeight);
        final tile = RectangleComponent(
          position: position,
          size: Vector2.all(tileSize),
          paint: Paint()..color = terrainType.color,
        );
        
        add(tile);
      }
    }
  }
  
  TerrainType _getTerrainType(int x, int y, int width, int height) {
    // Simple terrain generation logic
    if (x < width * 0.3) {
      return TerrainType.grove; // Left side is Grove
    } else if (x > width * 0.7 && y > height * 0.6) {
      return TerrainType.ore; // Bottom-right is Ore
    } else if (y < height * 0.3 && x > width * 0.6) {
      return TerrainType.hollow; // Top-right is Hollow
    } else if (y > height * 0.5 && x < width * 0.5) {
      return TerrainType.tide; // Bottom-left is Tide
    }
    
    return TerrainType.neutral;
  }
}

enum TerrainType {
  grove(color: Color(0xFF2D5016)), // Forest green
  tide(color: Color(0xFF1E40AF)),  // Ocean blue
  hollow(color: Color(0xFF374151)), // Dark gray
  ore(color: Color(0xFF7C2D12)),    // Bronze
  neutral(color: Color(0xFF4A5568)); // Neutral gray
  
  final Color color;
  const TerrainType({required this.color});
}

class RegionTrigger extends RectangleComponent {
  final VoidCallback onEnter;
  bool hasTriggered = false;
  
  RegionTrigger({
    required Rect area,
    required this.onEnter,
  }) : super(
    position: Vector2(area.left, area.top),
    size: Vector2(area.width, area.height),
    paint: Paint()..color = const Color(0x00000000), // Invisible
  );
  
  void checkPlayerCollision(Vector2 playerPos) {
    if (!hasTriggered && containsPoint(playerPos)) {
      hasTriggered = true;
      onEnter();
    } else if (!containsPoint(playerPos)) {
      hasTriggered = false;
    }
  }
}