import 'dart:math';
import 'map_section_builder.dart';

/// Manages the 6 distinct regions of the Astralis world
class RegionManager {
  static const int SECTIONS_PER_REGION = 25; // 5x5 grid of 20x20 sections = 100x100 tiles per region
  
  /// The 6 main regions of Astralis
  enum Region {
    verdantGrove,    // Starting region - forests, meadows, gentle creatures
    crystalPeaks,    // Mountain region - caves, crystals, rock types
    emberWastes,     // Desert/volcanic - fire types, ancient ruins
    frozenTundra,    // Ice region - snow, glaciers, ice types
    stormCoast,      // Coastal region - beaches, cliffs, water types
    shadowMarsh      // Dark swamp - poison, ghost types, mysterious
  }
  
  /// Region metadata and characteristics
  class RegionData {
    final Region region;
    final String name;
    final String description;
    final List<String> tilesetThemes;
    final List<String> astralTypes;
    final Point<int> worldPosition; // Position on world map (in sections)
    final String hubTownName;
    final Color themeColor;
    
    RegionData({
      required this.region,
      required this.name,
      required this.description,
      required this.tilesetThemes,
      required this.astralTypes,
      required this.worldPosition,
      required this.hubTownName,
      required this.themeColor,
    });
  }
  
  static final Map<Region, RegionData> regions = {
    Region.verdantGrove: RegionData(
      region: Region.verdantGrove,
      name: 'Verdant Grove',
      description: 'A lush forest region with meadows and gentle streams. Perfect for beginners.',
      tilesetThemes: ['forest', 'meadow', 'river', 'village'],
      astralTypes: ['grass', 'normal', 'bug', 'fairy'],
      worldPosition: Point(1, 1), // Northwest
      hubTownName: 'Leafshire',
      themeColor: Color(0xFF4CAF50),
    ),
    Region.crystalPeaks: RegionData(
      region: Region.crystalPeaks,
      name: 'Crystal Peaks',
      description: 'Towering mountains filled with caves and crystalline formations.',
      tilesetThemes: ['mountain', 'cave', 'crystal', 'mining_town'],
      astralTypes: ['rock', 'steel', 'ground', 'dragon'],
      worldPosition: Point(2, 0), // North
      hubTownName: 'Gemhaven',
      themeColor: Color(0xFF9C27B0),
    ),
    Region.emberWastes: RegionData(
      region: Region.emberWastes,
      name: 'Ember Wastes',
      description: 'A harsh desert with volcanic activity and ancient ruins.',
      tilesetThemes: ['desert', 'volcano', 'ruins', 'oasis'],
      astralTypes: ['fire', 'ground', 'dark', 'fighting'],
      worldPosition: Point(2, 2), // Southeast
      hubTownName: 'Scorchtown',
      themeColor: Color(0xFFFF5722),
    ),
    Region.frozenTundra: RegionData(
      region: Region.frozenTundra,
      name: 'Frozen Tundra',
      description: 'An icy wasteland with glaciers and perpetual snow.',
      tilesetThemes: ['snow', 'ice', 'glacier', 'frozen_lake'],
      astralTypes: ['ice', 'water', 'steel', 'psychic'],
      worldPosition: Point(0, 0), // Far north
      hubTownName: 'Frostholm',
      themeColor: Color(0xFF00BCD4),
    ),
    Region.stormCoast: RegionData(
      region: Region.stormCoast,
      name: 'Storm Coast',
      description: 'Rocky coastlines with beaches, cliffs, and constant storms.',
      tilesetThemes: ['beach', 'cliff', 'lighthouse', 'port'],
      astralTypes: ['water', 'electric', 'flying', 'normal'],
      worldPosition: Point(0, 2), // Southwest
      hubTownName: 'Tidewater Port',
      themeColor: Color(0xFF2196F3),
    ),
    Region.shadowMarsh: RegionData(
      region: Region.shadowMarsh,
      name: 'Shadow Marsh',
      description: 'A mysterious swamp shrouded in mist and dark magic.',
      tilesetThemes: ['swamp', 'dead_trees', 'mist', 'ruins'],
      astralTypes: ['poison', 'ghost', 'dark', 'psychic'],
      worldPosition: Point(1, 2), // South
      hubTownName: 'Gloomwick',
      themeColor: Color(0xFF4A148C),
    ),
  };
  
  /// Region connection graph (which regions connect to which)
  static final Map<Region, List<Region>> connections = {
    Region.verdantGrove: [
      Region.crystalPeaks,
      Region.stormCoast,
      Region.shadowMarsh,
    ],
    Region.crystalPeaks: [
      Region.verdantGrove,
      Region.frozenTundra,
      Region.emberWastes,
    ],
    Region.emberWastes: [
      Region.crystalPeaks,
      Region.shadowMarsh,
    ],
    Region.frozenTundra: [
      Region.crystalPeaks,
      Region.stormCoast,
    ],
    Region.stormCoast: [
      Region.frozenTundra,
      Region.verdantGrove,
      Region.shadowMarsh,
    ],
    Region.shadowMarsh: [
      Region.verdantGrove,
      Region.stormCoast,
      Region.emberWastes,
    ],
  };
  
  /// Build order for regions (progression path)
  static const List<Region> buildOrder = [
    Region.verdantGrove,  // Start here
    Region.stormCoast,    // Second region (water types)
    Region.crystalPeaks,  // Third region (rock/steel)
    Region.shadowMarsh,   // Fourth region (poison/ghost)
    Region.frozenTundra,  // Fifth region (ice)
    Region.emberWastes,   // Final region (fire/dragon)
  ];
  
  /// Generate a region layout (5x5 grid of sections)
  static List<List<SectionType>> generateRegionLayout(Region region) {
    var layout = List.generate(5, (_) => List.filled(5, SectionType.meadow));
    
    switch (region) {
      case Region.verdantGrove:
        // Starter region - town in center, forests around
        layout[2][2] = SectionType.starterTown;
        layout[1][2] = SectionType.crossroads;
        layout[2][1] = SectionType.forest;
        layout[2][3] = SectionType.forest;
        layout[3][2] = SectionType.riverCrossing;
        layout[0][0] = SectionType.forest;
        layout[0][4] = SectionType.forest;
        layout[4][0] = SectionType.meadow;
        layout[4][4] = SectionType.dungeon_entrance; // To Shadow Marsh
        break;
        
      case Region.crystalPeaks:
        // Mountain region - village at base, peaks above
        layout[4][2] = SectionType.village;
        layout[3][2] = SectionType.crossroads;
        layout[2][2] = SectionType.hillside;
        layout[1][2] = SectionType.hillside;
        layout[0][2] = SectionType.dungeon_entrance; // Peak dungeon
        break;
        
      case Region.emberWastes:
        // Desert region - oasis town, ruins scattered
        layout[2][2] = SectionType.village; // Oasis town
        layout[1][1] = SectionType.dungeon_entrance; // Ancient ruins
        layout[3][3] = SectionType.dungeon_entrance; // Volcano entrance
        layout[0][2] = SectionType.crossroads;
        layout[4][2] = SectionType.riverCrossing; // Rare water source
        break;
        
      case Region.frozenTundra:
        // Ice region - port town, frozen lakes
        layout[3][1] = SectionType.village;
        layout[2][2] = SectionType.riverCrossing; // Frozen lake
        layout[1][3] = SectionType.dungeon_entrance; // Ice cavern
        layout[4][4] = SectionType.crossroads;
        break;
        
      case Region.stormCoast:
        // Coastal region - port town, beaches and cliffs
        layout[2][0] = SectionType.village; // Port
        layout[2][1] = SectionType.crossroads;
        layout[2][2] = SectionType.riverCrossing; // Beach
        layout[1][2] = SectionType.hillside; // Cliffs
        layout[3][3] = SectionType.dungeon_entrance; // Sea cave
        break;
        
      case Region.shadowMarsh:
        // Swamp region - hidden village, dangerous paths
        layout[3][3] = SectionType.village; // Hidden village
        layout[2][2] = SectionType.riverCrossing; // Swamp crossing
        layout[1][1] = SectionType.dungeon_entrance; // Ancient temple
        layout[4][1] = SectionType.forest; // Dead forest
        layout[0][4] = SectionType.crossroads;
        break;
    }
    
    return layout;
  }
  
  /// Get portal locations for fast travel
  static Map<String, Point<int>> getPortalLocations() {
    return {
      'verdant_portal': Point(50, 50),   // Center of Verdant Grove
      'crystal_portal': Point(150, 50),  // Crystal Peaks
      'ember_portal': Point(150, 150),   // Ember Wastes
      'frozen_portal': Point(50, 0),     // Frozen Tundra
      'storm_portal': Point(0, 150),     // Storm Coast
      'shadow_portal': Point(100, 150),  // Shadow Marsh
    };
  }
}

/// Color class placeholder (normally from Flutter)
class Color {
  final int value;
  const Color(this.value);
}