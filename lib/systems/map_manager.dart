import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:tiled/tiled.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MapManager extends Component {
  static final MapManager _instance = MapManager._internal();
  factory MapManager() => _instance;
  MapManager._internal();
  
  TiledComponent? currentMap;
  String? currentMapName;
  final Map<String, TiledComponent> _loadedMaps = {};
  final Map<String, MapData> _mapConfigs = {};
  
  // Map configurations for each region
  static const Map<String, MapConfig> mapConfigs = {
    'starting_grove': MapConfig(
      path: 'maps/starting_grove.tmx',
      spawnX: 400,
      spawnY: 300,
      backgroundMusic: 'grove_ambient.ogg',
      encounters: ['tuki', 'cindcub'],
      npcs: ['elder_kaelan'],
    ),
    'temple_district': MapConfig(
      path: 'maps/temple_district.tmx',
      spawnX: 200,
      spawnY: 400,
      backgroundMusic: 'temple_mystical.ogg',
      encounters: ['rylotl', 'rowletch'],
      npcs: ['temple_guardian'],
    ),
    'crystal_caves': MapConfig(
      path: 'maps/crystal_caves.tmx',
      spawnX: 100,
      spawnY: 200,
      backgroundMusic: 'cave_echoes.ogg',
      encounters: ['peavee', 'voidlit'],
      npcs: ['cave_scholar'],
    ),
    'astral_peak': MapConfig(
      path: 'maps/astral_peak.tmx',
      spawnX: 300,
      spawnY: 100,
      backgroundMusic: 'peak_winds.ogg',
      encounters: ['orelyx', 'oreilla'],
      npcs: ['peak_master'],
    ),
    'syn_facility': MapConfig(
      path: 'maps/syn_facility.tmx',
      spawnX: 500,
      spawnY: 300,
      backgroundMusic: 'facility_tension.ogg',
      encounters: ['syn_phantom'],
      npcs: ['facility_guard'],
    ),
  };
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initializeMapConfigs();
  }
  
  void _initializeMapConfigs() {
    for (final entry in mapConfigs.entries) {
      _mapConfigs[entry.key] = MapData(
        name: entry.key,
        config: entry.value,
      );
    }
  }
  
  // Load a map by name
  Future<void> loadMap(String mapName) async {
    if (currentMapName == mapName) return;
    
    try {
      // Remove current map
      if (currentMap != null) {
        currentMap!.removeFromParent();
      }
      
      // Load new map
      if (_loadedMaps.containsKey(mapName)) {
        currentMap = _loadedMaps[mapName];
      } else {
        final mapConfig = mapConfigs[mapName];
        if (mapConfig == null) {
          print('Map config not found: $mapName');
          _createPlaceholderMap(mapName);
          return;
        }
        
        try {
          currentMap = await TiledComponent.load(mapConfig.path, Vector2.all(16));
          _loadedMaps[mapName] = currentMap!;
        } catch (e) {
          print('Failed to load Tiled map: ${mapConfig.path}, creating placeholder');
          _createPlaceholderMap(mapName);
          return;
        }
      }
      
      if (currentMap != null && parent != null) {
        await parent!.add(currentMap!);
      }
      
      currentMapName = mapName;
      
      // Set up map-specific elements
      _setupMapElements(mapName);
      
    } catch (e) {
      print('Error loading map $mapName: $e');
      _createPlaceholderMap(mapName);
    }
  }
  
  // Create placeholder map when Tiled assets are missing
  void _createPlaceholderMap(String mapName) {
    final mapConfig = mapConfigs[mapName];
    if (mapConfig == null) return;
    
    // Create a procedural placeholder map
    final placeholderMap = PlaceholderMap(
      mapName: mapName,
      config: mapConfig,
    );
    
    currentMap = placeholderMap;
    if (parent != null) {
      parent!.add(currentMap!);
    }
    
    currentMapName = mapName;
    _setupMapElements(mapName);
  }
  
  void _setupMapElements(String mapName) {
    final config = mapConfigs[mapName];
    if (config == null) return;
    
    // Add ambient particles based on map type
    _addAmbientEffects(mapName);
    
    // Set encounter rates
    _setupEncounters(config.encounters);
    
    print('Loaded map: $mapName with spawn at (${config.spawnX}, ${config.spawnY})');
  }
  
  void _addAmbientEffects(String mapName) {
    // Different ambient effects for each map type
    switch (mapName) {
      case 'starting_grove':
        _addNatureParticles();
        break;
      case 'temple_district':
        _addMysticalAura();
        break;
      case 'crystal_caves':
        _addCrystalGlints();
        break;
      case 'astral_peak':
        _addWindEffects();
        break;
      case 'syn_facility':
        _addTechEffects();
        break;
    }
  }
  
  void _addNatureParticles() {
    // Floating leaves and pollen
    if (parent == null) return;
    
    final particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: 15,
        lifespan: 8,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(5 + math.Random().nextDouble() * 10, 0),
          speed: Vector2(
            math.Random().nextDouble() * 20 - 10,
            -math.Random().nextDouble() * 30 - 10,
          ),
          position: Vector2(
            math.Random().nextDouble() * 800,
            600,
          ),
          child: CircleParticle(
            radius: 2 + math.Random().nextDouble() * 3,
            paint: Paint()
              ..color = Color.lerp(
                const Color(0xFF90EE90),
                const Color(0xFFFFFFE0),
                math.Random().nextDouble(),
              )!.withOpacity(0.7),
          ),
        ),
      ),
    );
    
    parent!.add(particleSystem);
  }
  
  void _addMysticalAura() {
    // Glowing orbs and energy wisps
    if (parent == null) return;
    
    final particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: 10,
        lifespan: 12,
        generator: (i) => MovingParticle(
          from: Vector2(
            math.Random().nextDouble() * 800,
            math.Random().nextDouble() * 600,
          ),
          to: Vector2(
            math.Random().nextDouble() * 800,
            math.Random().nextDouble() * 600,
          ),
          child: CircleParticle(
            radius: 4 + math.Random().nextDouble() * 6,
            paint: Paint()
              ..color = const Color(0xFF9D4EDD).withOpacity(0.4)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
          ),
          curve: Curves.easeInOut,
        ),
      ),
    );
    
    parent!.add(particleSystem);
  }
  
  void _addCrystalGlints() {
    // Sparkling crystal reflections
    if (parent == null) return;
    
    final particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: 20,
        lifespan: 3,
        generator: (i) => ScalingParticle(
          to: 0,
          child: CircleParticle(
            radius: 1 + math.Random().nextDouble() * 2,
            paint: Paint()
              ..color = Colors.cyan.withOpacity(0.8)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
          ),
          lifespan: 0.5,
        ),
      ),
      position: Vector2(
        math.Random().nextDouble() * 800,
        math.Random().nextDouble() * 600,
      ),
    );
    
    parent!.add(particleSystem);
  }
  
  void _addWindEffects() {
    // Wind-carried particles
    if (parent == null) return;
    
    final particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: 25,
        lifespan: 6,
        generator: (i) => AcceleratedParticle(
          acceleration: Vector2(30, 0),
          speed: Vector2(
            math.Random().nextDouble() * 50 + 20,
            math.Random().nextDouble() * 20 - 10,
          ),
          position: Vector2(-50, math.Random().nextDouble() * 600),
          child: CircleParticle(
            radius: 1,
            paint: Paint()
              ..color = Colors.white.withOpacity(0.3),
          ),
        ),
      ),
    );
    
    parent!.add(particleSystem);
  }
  
  void _addTechEffects() {
    // Digital/synthetic effects
    if (parent == null) return;
    
    final particleSystem = ParticleSystemComponent(
      particle: Particle.generate(
        count: 12,
        lifespan: 4,
        generator: (i) => MovingParticle(
          from: Vector2(
            math.Random().nextDouble() * 800,
            600,
          ),
          to: Vector2(
            math.Random().nextDouble() * 800,
            -50,
          ),
          child: RectangleParticle(
            size: Vector2(2, 8),
            paint: Paint()
              ..color = const Color(0xFF00FFFF).withOpacity(0.6)
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
          ),
        ),
      ),
    );
    
    parent!.add(particleSystem);
  }
  
  void _setupEncounters(List<String> encounters) {
    // Set up encounter system for current map
    print('Setting up encounters: ${encounters.join(', ')}');
  }
  
  // Get spawn position for current map
  Vector2 getSpawnPosition() {
    if (currentMapName == null) return Vector2(400, 300);
    
    final config = mapConfigs[currentMapName!];
    return Vector2(config?.spawnX ?? 400, config?.spawnY ?? 300);
  }
  
  // Check if position is walkable
  bool isWalkable(Vector2 position) {
    // For now, always walkable. In full implementation,
    // this would check collision layers from Tiled map
    return true;
  }
  
  // Get current map data
  MapData? getCurrentMapData() {
    if (currentMapName == null) return null;
    return _mapConfigs[currentMapName!];
  }
  
  // Clear loaded maps cache
  void clearCache() {
    for (final map in _loadedMaps.values) {
      map.removeFromParent();
    }
    _loadedMaps.clear();
  }
  
  @override
  void onRemove() {
    clearCache();
    super.onRemove();
  }
}

// Map configuration data
class MapConfig {
  final String path;
  final double spawnX;
  final double spawnY;
  final String backgroundMusic;
  final List<String> encounters;
  final List<String> npcs;
  
  const MapConfig({
    required this.path,
    required this.spawnX,
    required this.spawnY,
    required this.backgroundMusic,
    required this.encounters,
    required this.npcs,
  });
}

// Runtime map data
class MapData {
  final String name;
  final MapConfig config;
  final Map<String, dynamic> properties;
  
  MapData({
    required this.name,
    required this.config,
    this.properties = const {},
  });
}

// Placeholder map component when Tiled assets are missing
class PlaceholderMap extends TiledComponent {
  final String mapName;
  final MapConfig config;
  
  PlaceholderMap({
    required this.mapName,
    required this.config,
  }) : super.fromTiledMap(
    TiledMap(
      map: Map(),
      tileMap: TileMap(
        map: {},
        tilesets: [],
        width: 50,
        height: 50,
        tileWidth: 16,
        tileHeight: 16,
      ),
    ),
    Vector2.all(16),
  );
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Create placeholder terrain
    _createPlaceholderTerrain();
  }
  
  void _createPlaceholderTerrain() {
    final random = math.Random();
    
    // Create terrain based on map type
    Color terrainColor;
    Color accentColor;
    
    switch (mapName) {
      case 'starting_grove':
        terrainColor = const Color(0xFF228B22);
        accentColor = const Color(0xFF32CD32);
        break;
      case 'temple_district':
        terrainColor = const Color(0xFF8A2BE2);
        accentColor = const Color(0xFF9370DB);
        break;
      case 'crystal_caves':
        terrainColor = const Color(0xFF4169E1);
        accentColor = const Color(0xFF00BFFF);
        break;
      case 'astral_peak':
        terrainColor = const Color(0xFF708090);
        accentColor = const Color(0xFFB0C4DE);
        break;
      case 'syn_facility':
        terrainColor = const Color(0xFF2F4F4F);
        accentColor = const Color(0xFF008B8B);
        break;
      default:
        terrainColor = const Color(0xFF556B2F);
        accentColor = const Color(0xFF9ACD32);
    }
    
    // Create base terrain
    final baseTerrain = RectangleComponent(
      size: Vector2(800, 600),
      paint: Paint()..color = terrainColor,
    );
    add(baseTerrain);
    
    // Add terrain features
    for (int i = 0; i < 20; i++) {
      final feature = RectangleComponent(
        size: Vector2(
          20 + random.nextDouble() * 40,
          20 + random.nextDouble() * 40,
        ),
        position: Vector2(
          random.nextDouble() * 760,
          random.nextDouble() * 560,
        ),
        paint: Paint()..color = accentColor.withOpacity(0.7),
      );
      add(feature);
    }
    
    // Add boundary markers
    _addBoundaryMarkers();
  }
  
  void _addBoundaryMarkers() {
    // Add visual boundaries
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Top border
    add(RectangleComponent(
      size: Vector2(800, 2),
      position: Vector2(0, 0),
      paint: borderPaint,
    ));
    
    // Bottom border
    add(RectangleComponent(
      size: Vector2(800, 2),
      position: Vector2(0, 598),
      paint: borderPaint,
    ));
    
    // Left border
    add(RectangleComponent(
      size: Vector2(2, 600),
      position: Vector2(0, 0),
      paint: borderPaint,
    ));
    
    // Right border
    add(RectangleComponent(
      size: Vector2(2, 600),
      position: Vector2(798, 0),
      paint: borderPaint,
    ));
  }
}