import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Enhanced Tiled Map Manager for Astralis RPG storyline and world traversal
/// 
/// This system handles:
/// - Loading Tiled maps (.tmx files) created with mapeditor.org
/// - Map transitions and storyline progression
/// - Collision detection and interactive objects
/// - Dynamic object spawning based on map data
/// - Multi-layer rendering with parallax effects
class TiledWorldManager extends Component {
  static final TiledWorldManager _instance = TiledWorldManager._internal();
  factory TiledWorldManager() => _instance;
  TiledWorldManager._internal();
  
  TiledComponent? currentMap;
  String? currentMapName;
  final Map<String, TiledComponent> _loadedMaps = {};
  final Map<String, StorylineMapData> _storyMaps = {};
  
  // Map configurations for Astralis storyline
  static const Map<String, StorylineMapConfig> storylineMapConfigs = {
    // Starting areas
    'grove_of_beginnings': StorylineMapConfig(
      path: 'maps/storyline/grove_of_beginnings.tmx',
      displayName: 'Grove of Beginnings',
      description: 'Where young Shamans first learn to bond with Astrals',
      spawnX: 400, spawnY: 300,
      backgroundMusic: 'grove_peaceful.ogg',
      region: StorylineRegion.startingLands,
      storyChapter: 1,
      encounters: ['tuki', 'cindcub'],
      npcs: ['elder_kaelan', 'instructor_mira'],
      requiredLevel: 1,
      connections: ['whispering_forest', 'temple_district'],
    ),
    
    'whispering_forest': StorylineMapConfig(
      path: 'maps/storyline/whispering_forest.tmx',
      displayName: 'Whispering Forest',
      description: 'Ancient woods where Astrals commune with nature',
      spawnX: 200, spawnY: 400,
      backgroundMusic: 'forest_mystical.ogg',
      region: StorylineRegion.startingLands,
      storyChapter: 2,
      encounters: ['rylotl', 'rowletch', 'peavee'],
      npcs: ['forest_guardian', 'hermit_sage'],
      requiredLevel: 3,
      connections: ['grove_of_beginnings', 'crystal_caverns'],
    ),
    
    // Temple regions
    'temple_district': StorylineMapConfig(
      path: 'maps/storyline/temple_district.tmx',
      displayName: 'Temple District',
      description: 'Sacred halls where the four temples stand united',
      spawnX: 500, spawnY: 250,
      backgroundMusic: 'temple_sacred.ogg',
      region: StorylineRegion.sacredTemples,
      storyChapter: 3,
      encounters: ['temple_guardians'],
      npcs: ['high_priestess', 'temple_keeper'],
      requiredLevel: 5,
      connections: ['radiant_temple', 'void_temple', 'dream_temple', 'storm_temple'],
    ),
    
    'radiant_temple': StorylineMapConfig(
      path: 'maps/storyline/radiant_temple.tmx',
      displayName: 'Radiant Temple',
      description: 'Temple of Light and Healing energies',
      spawnX: 300, spawnY: 200,
      backgroundMusic: 'radiant_hymn.ogg',
      region: StorylineRegion.sacredTemples,
      storyChapter: 4,
      encounters: ['light_astrals'],
      npcs: ['steward_lumina'],
      requiredLevel: 8,
      connections: ['temple_district'],
    ),
    
    'void_temple': StorylineMapConfig(
      path: 'maps/storyline/void_temple.tmx',
      displayName: 'Void Temple',
      description: 'Temple of Shadow and Mystery',
      spawnX: 150, spawnY: 350,
      backgroundMusic: 'void_whispers.ogg',
      region: StorylineRegion.sacredTemples,
      storyChapter: 4,
      encounters: ['shadow_astrals'],
      npcs: ['steward_umbra'],
      requiredLevel: 8,
      connections: ['temple_district'],
    ),
    
    'dream_temple': StorylineMapConfig(
      path: 'maps/storyline/dream_temple.tmx',
      displayName: 'Dream Temple',
      description: 'Temple of Visions and Psychic bonds',
      spawnX: 450, spawnY: 150,
      backgroundMusic: 'dream_ethereal.ogg',
      region: StorylineRegion.sacredTemples,
      storyChapter: 4,
      encounters: ['psychic_astrals'],
      npcs: ['steward_oneira'],
      requiredLevel: 8,
      connections: ['temple_district'],
    ),
    
    'storm_temple': StorylineMapConfig(
      path: 'maps/storyline/storm_temple.tmx',
      displayName: 'Storm Temple',
      description: 'Temple of Lightning and Elemental power',
      spawnX: 600, spawnY: 300,
      backgroundMusic: 'storm_power.ogg',
      region: StorylineRegion.sacredTemples,
      storyChapter: 4,
      encounters: ['storm_astrals'],
      npcs: ['steward_tempest'],
      requiredLevel: 8,
      connections: ['temple_district'],
    ),
    
    // Advanced areas
    'crystal_caverns': StorylineMapConfig(
      path: 'maps/storyline/crystal_caverns.tmx',
      displayName: 'Crystal Caverns',
      description: 'Deep caves filled with resonant crystals',
      spawnX: 100, spawnY: 500,
      backgroundMusic: 'cavern_echoes.ogg',
      region: StorylineRegion.wildlands,
      storyChapter: 5,
      encounters: ['crystal_astrals', 'cave_dwellers'],
      npcs: ['crystal_scholar', 'cave_hermit'],
      requiredLevel: 12,
      connections: ['whispering_forest', 'astral_peaks'],
    ),
    
    'astral_peaks': StorylineMapConfig(
      path: 'maps/storyline/astral_peaks.tmx',
      displayName: 'Astral Peaks',
      description: 'Highest mountains where legendary Astrals soar',
      spawnX: 300, spawnY: 100,
      backgroundMusic: 'peak_winds.ogg',
      region: StorylineRegion.wildlands,
      storyChapter: 6,
      encounters: ['dragon_astrals', 'wind_spirits'],
      npcs: ['peak_master', 'sky_rider'],
      requiredLevel: 15,
      connections: ['crystal_caverns', 'syn_facility'],
    ),
    
    // End game areas
    'syn_facility': StorylineMapConfig(
      path: 'maps/storyline/syn_facility.tmx',
      displayName: 'SYN Research Facility',
      description: 'Where synthetic Astrals are created and contained',
      spawnX: 500, spawnY: 400,
      backgroundMusic: 'facility_tension.ogg',
      region: StorylineRegion.synLaboratories,
      storyChapter: 7,
      encounters: ['syn_phantoms', 'security_bots'],
      npcs: ['dr_synthesis', 'facility_ai'],
      requiredLevel: 18,
      connections: ['astral_peaks', 'core_chamber'],
    ),
    
    'core_chamber': StorylineMapConfig(
      path: 'maps/storyline/core_chamber.tmx',
      displayName: 'Core Chamber',
      description: 'The heart of the SYN facility - final confrontation',
      spawnX: 400, spawnY: 300,
      backgroundMusic: 'final_confrontation.ogg',
      region: StorylineRegion.synLaboratories,
      storyChapter: 8,
      encounters: ['syn_overlord'],
      npcs: ['master_ai'],
      requiredLevel: 20,
      connections: ['syn_facility'],
      isFinalArea: true,
    ),
  };
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    _initializeStorylineMaps();
    print('Tiled World Manager initialized with ${storylineMapConfigs.length} storyline maps');
  }
  
  void _initializeStorylineMaps() {
    for (final entry in storylineMapConfigs.entries) {
      _storyMaps[entry.key] = StorylineMapData(
        name: entry.key,
        config: entry.value,
        isUnlocked: entry.value.requiredLevel <= 1, // Only starting areas unlocked initially
        isVisited: false,
        completionStatus: MapCompletionStatus.notStarted,
      );
    }
  }
  
  /// Load a storyline map by name
  Future<bool> loadStorylineMap(String mapName, {Vector2? customSpawn}) async {
    final mapData = _storyMaps[mapName];
    if (mapData == null) {
      print('Storyline map not found: $mapName');
      return false;
    }
    
    if (!mapData.isUnlocked) {
      print('Map $mapName is locked. Required level: ${mapData.config.requiredLevel}');
      return false;
    }
    
    try {
      // Remove current map
      if (currentMap != null) {
        currentMap!.removeFromParent();
      }
      
      // Try to load the actual Tiled map
      if (_loadedMaps.containsKey(mapName)) {
        currentMap = _loadedMaps[mapName];
      } else {
        try {
          currentMap = await TiledComponent.load(
            mapData.config.path, 
            Vector2.all(16) // Tile size
          );
          _loadedMaps[mapName] = currentMap!;
          print('Loaded Tiled map: ${mapData.config.path}');
        } catch (e) {
          print('Failed to load Tiled map: ${mapData.config.path}');
          print('Using master world map instead of ${mapData.config.displayName}');
          // Load the master world map as fallback
          currentMap = await TiledComponent.load('maps/storyline/astralis_master_world.tmx', Vector2.all(16));
          _loadedMaps[mapName] = currentMap!;
        }
      }
      
      // Add map to game
      if (currentMap != null && parent != null) {
        await parent!.add(currentMap!);
      }
      
      currentMapName = mapName;
      
      // Mark as visited and set up map elements
      mapData.isVisited = true;
      _setupStorylineElements(mapData, customSpawn);
      
      return true;
      
    } catch (e) {
      print('Error loading storyline map $mapName: $e');
      return false;
    }
  }
  
  /// Create a basic placeholder when .tmx files aren't available
  TiledComponent? _createStorylinePlaceholder(StorylineMapData mapData) {
    print('⚠️ TMX file not found for ${mapData.config.displayName}');
    return null; // Return null for now - will use master world map instead
  }
  
  void _setupStorylineElements(StorylineMapData mapData, Vector2? customSpawn) {
    final config = mapData.config;
    
    // Add region-appropriate ambient effects
    _addRegionAmbientEffects(config.region);
    
    // Set up encounters and NPCs based on map data
    _setupEncountersAndNPCs(config);
    
    print('Entered: ${config.displayName}');
    print('Description: ${config.description}');
    print('Chapter ${config.storyChapter} - Region: ${config.region.name}');
  }
  
  void _addRegionAmbientEffects(StorylineRegion region) {
    if (parent == null) return;
    
    switch (region) {
      case StorylineRegion.startingLands:
        _addNatureAmbience();
        break;
      case StorylineRegion.sacredTemples:
        _addSacredAmbience();
        break;
      case StorylineRegion.wildlands:
        _addWildAmbience();
        break;
      case StorylineRegion.synLaboratories:
        _addTechAmbience();
        break;
    }
  }
  
  void _addNatureAmbience() {
    // Gentle nature particles for starting areas
    final particles = _createParticleSystem(
      count: 10,
      colors: [const Color(0xFF90EE90), const Color(0xFFFFFFE0)],
      movement: 'floating',
    );
    parent!.add(particles);
  }
  
  void _addSacredAmbience() {
    // Mystical temple effects
    final particles = _createParticleSystem(
      count: 15,
      colors: [const Color(0xFF9D4EDD), const Color(0xFFFFD700)],
      movement: 'ascending',
    );
    parent!.add(particles);
  }
  
  void _addWildAmbience() {
    // Wild, chaotic energy
    final particles = _createParticleSystem(
      count: 20,
      colors: [const Color(0xFF00FFFF), const Color(0xFFFF6347)],
      movement: 'chaotic',
    );
    parent!.add(particles);
  }
  
  void _addTechAmbience() {
    // Synthetic, digital effects
    final particles = _createParticleSystem(
      count: 12,
      colors: [const Color(0xFF00FFFF), const Color(0xFFFF0080)],
      movement: 'digital',
    );
    parent!.add(particles);
  }
  
  Component _createParticleSystem({
    required int count,
    required List<Color> colors,
    required String movement,
  }) {
    // Implementation for different particle systems based on region
    return RectangleComponent(size: Vector2.zero()); // Placeholder
  }
  
  void _setupEncountersAndNPCs(StorylineMapConfig config) {
    // Set up encounters and NPCs based on map configuration
    print('Available encounters: ${config.encounters.join(', ')}');
    print('NPCs present: ${config.npcs.join(', ')}');
  }
  
  /// Get spawn position for current map
  Vector2 getSpawnPosition() {
    if (currentMapName == null) return Vector2(400, 300);
    
    final mapData = _storyMaps[currentMapName!];
    if (mapData == null) return Vector2(400, 300);
    
    return Vector2(mapData.config.spawnX, mapData.config.spawnY);
  }
  
  /// Check if player can travel to a specific map
  bool canTravelTo(String mapName) {
    final mapData = _storyMaps[mapName];
    if (mapData == null) return false;
    
    // Check if map is unlocked and connected to current map
    if (!mapData.isUnlocked) return false;
    
    if (currentMapName == null) return true;
    
    final currentMapData = _storyMaps[currentMapName!];
    if (currentMapData == null) return false;
    
    return currentMapData.config.connections.contains(mapName);
  }
  
  /// Unlock a map (usually called when player reaches required level)
  void unlockMap(String mapName) {
    final mapData = _storyMaps[mapName];
    if (mapData != null) {
      mapData.isUnlocked = true;
      print('Map unlocked: ${mapData.config.displayName}');
    }
  }
  
  /// Get all available travel destinations from current location
  List<String> getAvailableDestinations() {
    if (currentMapName == null) return [];
    
    final currentMapData = _storyMaps[currentMapName!];
    if (currentMapData == null) return [];
    
    return currentMapData.config.connections
        .where((mapName) => canTravelTo(mapName))
        .toList();
  }
  
  /// Get storyline progress information
  StorylineProgress getStorylineProgress() {
    final totalMaps = _storyMaps.length;
    final unlockedMaps = _storyMaps.values.where((map) => map.isUnlocked).length;
    final visitedMaps = _storyMaps.values.where((map) => map.isVisited).length;
    final completedMaps = _storyMaps.values.where((map) => map.completionStatus == MapCompletionStatus.completed).length;
    
    final currentChapter = currentMapName != null ? _storyMaps[currentMapName!]?.config.storyChapter ?? 1 : 1;
    
    return StorylineProgress(
      totalMaps: totalMaps,
      unlockedMaps: unlockedMaps,
      visitedMaps: visitedMaps,
      completedMaps: completedMaps,
      currentChapter: currentChapter,
      currentMapName: currentMapName,
    );
  }
  
  /// Check collision with map objects
  bool isWalkable(Vector2 position) {
    // For placeholder maps, always walkable
    // In full implementation, this would check collision layers from Tiled map
    return true;
  }
  
  /// Get current map data
  StorylineMapData? getCurrentMapData() {
    if (currentMapName == null) return null;
    return _storyMaps[currentMapName!];
  }
  
  /// Clear loaded maps cache
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

// Storyline map configuration
class StorylineMapConfig {
  final String path;
  final String displayName;
  final String description;
  final double spawnX;
  final double spawnY;
  final String backgroundMusic;
  final StorylineRegion region;
  final int storyChapter;
  final List<String> encounters;
  final List<String> npcs;
  final int requiredLevel;
  final List<String> connections;
  final bool isFinalArea;
  
  const StorylineMapConfig({
    required this.path,
    required this.displayName,
    required this.description,
    required this.spawnX,
    required this.spawnY,
    required this.backgroundMusic,
    required this.region,
    required this.storyChapter,
    required this.encounters,
    required this.npcs,
    required this.requiredLevel,
    required this.connections,
    this.isFinalArea = false,
  });
}

// Runtime storyline map data
class StorylineMapData {
  final String name;
  final StorylineMapConfig config;
  bool isUnlocked;
  bool isVisited;
  MapCompletionStatus completionStatus;
  final Map<String, dynamic> customData;
  
  StorylineMapData({
    required this.name,
    required this.config,
    this.isUnlocked = false,
    this.isVisited = false,
    this.completionStatus = MapCompletionStatus.notStarted,
    this.customData = const {},
  });
}

// Storyline regions
enum StorylineRegion {
  startingLands('Starting Lands'),
  sacredTemples('Sacred Temples'),
  wildlands('Wildlands'),
  synLaboratories('SYN Laboratories');
  
  const StorylineRegion(this.displayName);
  final String displayName;
}

// Map completion status
enum MapCompletionStatus {
  notStarted,
  inProgress,
  completed,
  mastered, // All secrets found, all Astrals bonded
}

// Storyline progress tracking
class StorylineProgress {
  final int totalMaps;
  final int unlockedMaps;
  final int visitedMaps;
  final int completedMaps;
  final int currentChapter;
  final String? currentMapName;
  
  StorylineProgress({
    required this.totalMaps,
    required this.unlockedMaps,
    required this.visitedMaps,
    required this.completedMaps,
    required this.currentChapter,
    this.currentMapName,
  });
  
  double get completionPercentage => totalMaps > 0 ? (completedMaps / totalMaps) * 100 : 0;
  double get explorationPercentage => totalMaps > 0 ? (visitedMaps / totalMaps) * 100 : 0;
}

// Placeholder map when .tmx files aren't available
class StorylinePlaceholderMap extends Component {
  final StorylineMapData mapData;
  
  StorylinePlaceholderMap({required this.mapData});
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    _createRegionSpecificTerrain();
  }
  
  void _createRegionSpecificTerrain() {
    final config = mapData.config;
    final region = config.region;
    
    // Base terrain colors based on region
    Color baseColor;
    Color accentColor;
    String terrainType;
    
    switch (region) {
      case StorylineRegion.startingLands:
        baseColor = const Color(0xFF228B22);
        accentColor = const Color(0xFF32CD32);
        terrainType = 'forest';
        break;
      case StorylineRegion.sacredTemples:
        baseColor = const Color(0xFF8A2BE2);
        accentColor = const Color(0xFFFFD700);
        terrainType = 'sacred';
        break;
      case StorylineRegion.wildlands:
        baseColor = const Color(0xFF4169E1);
        accentColor = const Color(0xFF00BFFF);
        terrainType = 'wild';
        break;
      case StorylineRegion.synLaboratories:
        baseColor = const Color(0xFF2F4F4F);
        accentColor = const Color(0xFF00FFFF);
        terrainType = 'tech';
        break;
    }
    
    // Create base terrain
    final baseTerrain = RectangleComponent(
      size: Vector2(800, 600),
      paint: Paint()..color = baseColor,
    );
    add(baseTerrain);
    
    // Add region-specific features
    _addRegionFeatures(terrainType, accentColor);
    
    // Add map title
    _addMapTitle(config.displayName, config.description);
  }
  
  void _addRegionFeatures(String terrainType, Color accentColor) {
    final random = math.Random();
    
    switch (terrainType) {
      case 'forest':
        // Add trees and natural features
        for (int i = 0; i < 15; i++) {
          final tree = CircleComponent(
            radius: 8 + random.nextDouble() * 12,
            position: Vector2(
              random.nextDouble() * 760 + 20,
              random.nextDouble() * 560 + 20,
            ),
            paint: Paint()..color = accentColor.withOpacity(0.6),
          );
          add(tree);
        }
        break;
        
      case 'sacred':
        // Add temple pillars and sacred geometry
        for (int i = 0; i < 8; i++) {
          final pillar = RectangleComponent(
            size: Vector2(12, 40),
            position: Vector2(
              100 + i * 100.0,
              250 + math.sin(i * math.pi / 4) * 50,
            ),
            paint: Paint()..color = accentColor.withOpacity(0.8),
          );
          add(pillar);
        }
        break;
        
      case 'wild':
        // Add rocky formations and crystals
        for (int i = 0; i < 20; i++) {
          final rock = RectangleComponent(
            size: Vector2(
              10 + random.nextDouble() * 20,
              10 + random.nextDouble() * 20,
            ),
            position: Vector2(
              random.nextDouble() * 760 + 20,
              random.nextDouble() * 560 + 20,
            ),
            paint: Paint()..color = accentColor.withOpacity(0.7),
          );
          add(rock);
        }
        break;
        
      case 'tech':
        // Add geometric tech patterns
        for (int i = 0; i < 10; i++) {
          final techPanel = RectangleComponent(
            size: Vector2(60, 20),
            position: Vector2(
              i * 80.0 + 40,
              300 + (i % 2) * 100,
            ),
            paint: Paint()
              ..color = accentColor.withOpacity(0.5)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2,
          );
          add(techPanel);
        }
        break;
    }
  }
  
  void _addMapTitle(String title, String description) {
    // Add visual map title (in a real implementation, this might be shown in UI)
    print('Map: $title - $description');
  }
}