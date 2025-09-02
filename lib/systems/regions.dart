import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum RegionType {
  grove,    // Grove Eternal - Starting area with world tree
  tide,     // Tidecaller Archipelago - Ocean and islands
  hollow,   // Hollow Wastes - Desolate land with dragon skull
  ore,      // Orespine Mountains - Jagged peaks, ore-rich
}

class Region {
  final String id;
  final String name;
  final String description;
  final RegionType type;
  final Vector2 position;
  final Vector2 size;
  final Color primaryColor;
  final Color secondaryColor;
  final List<String> astralTypes;
  final List<String> landmarks;
  final int recommendedLevel;
  final String lore;
  
  Region({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.position,
    required this.size,
    required this.primaryColor,
    required this.secondaryColor,
    required this.astralTypes,
    required this.landmarks,
    required this.recommendedLevel,
    required this.lore,
  });
}

class RegionManager {
  static final Map<RegionType, Region> regions = {
    RegionType.grove: Region(
      id: 'grove_eternal',
      name: 'Grove Eternal',
      description: 'The starting realm dominated by a massive world tree. Home to Grove and Ember Astrals.',
      type: RegionType.grove,
      position: Vector2(0, 0),
      size: Vector2(800, 600),
      primaryColor: const Color(0xFF2D5016), // Deep forest green
      secondaryColor: const Color(0xFF4A7C59), // Lighter green
      astralTypes: ['grove', 'ember', 'nature'],
      landmarks: [
        'The World Tree',
        'Grove Eternal Shrine',
        'Elder Kaelen\'s Sanctuary',
        'Ember Clearings',
        'Ancient Grove Ruins'
      ],
      recommendedLevel: 1,
      lore: '''
The Grove Eternal stands as the heart of all natural life in Astralis. 
At its center grows the World Tree, whose roots reach deep into the 
cycle itself, nourishing all living essence. Here, Grove Astrals tend 
to the eternal garden while Ember Astrals bring warmth to cold nights.

This sacred grove has stood since the first cycle, a testament to the 
harmony between Shamans and Astrals. Elder Kaelen makes his home here, 
watching over young Shamans as they begin their journeys.

The very air pulses with life energy, and new Shamans often report 
feeling an immediate connection to the natural world upon entering.
      ''',
    ),

    RegionType.tide: Region(
      id: 'tidecaller_archipelago',
      name: 'Tidecaller Archipelago',
      description: 'A vast ocean dotted with mysterious islands. Home to Tide and Gale Astrals.',
      type: RegionType.tide,
      position: Vector2(800, 0),
      size: Vector2(700, 800),
      primaryColor: const Color(0xFF1E40AF), // Deep ocean blue
      secondaryColor: const Color(0xFF3B82F6), // Lighter blue
      astralTypes: ['tide', 'gale', 'water', 'storm'],
      landmarks: [
        'The Tidecaller\'s Throne',
        'Seraya\'s Training Grounds',
        'Whirlpool Gardens',
        'Storm Crown Peaks',
        'Deep Current Channels'
      ],
      recommendedLevel: 10,
      lore: '''
The Tidecaller Archipelago stretches across endless azure waters, where 
each island holds its own mysteries. The tides here don't just move water - 
they carry memories, stories, and ancient songs of the sea.

Tide Astrals command these waters with grace, while Gale Astrals ride the 
ocean winds between islands. Seraya trains here with her Tide Serpent, 
perfecting the art of aquatic bonding.

Legends speak of the original Tidecaller, an ancient Astral so powerful 
it could command all oceans. Its essence still flows through these waters, 
blessing those who show proper respect for the sea's power.
      ''',
    ),

    RegionType.hollow: Region(
      id: 'hollow_wastes',
      name: 'Hollow Wastes',
      description: 'Desolate badlands surrounding a colossal dragon skull. Home to Hollow Astrals and ancient mysteries.',
      type: RegionType.hollow,
      position: Vector2(400, 600),
      size: Vector2(600, 500),
      primaryColor: const Color(0xFF374151), // Dark gray
      secondaryColor: const Color(0xFF6B7280), // Lighter gray  
      astralTypes: ['hollow', 'shadow', 'void'],
      landmarks: [
        'Hollowyn\'s Skull',
        'Temple of Endings',
        'The Void Nexus',
        'Whisper Canyons',
        'Memory Graveyards'
      ],
      recommendedLevel: 25,
      lore: '''
The Hollow Wastes stretch endlessly beneath an eternally gray sky. At 
the center lies the massive skull of Hollowyn, the Hollow Dragon, a 
reminder of the delicate balance between existence and void.

This region exists in the space between cycles - neither fully alive 
nor completely dead. Hollow Astrals drift through these lands like 
living shadows, keepers of endings and guardians of transition.

Few dare venture here without strong protection, as the very air can 
drain the life from the unprepared. Yet those who understand the 
necessity of endings find profound wisdom in these desolate reaches.

SYN forces have been spotted here recently, drawn by the raw power 
that flows from Hollowyn's remains.
      ''',
    ),

    RegionType.ore: Region(
      id: 'orespine_mountains',
      name: 'Orespine Mountains',
      description: 'Jagged peaks rich with precious ores. Home to Ore Astrals and the great forges.',
      type: RegionType.ore,
      position: Vector2(0, 600),
      size: Vector2(600, 400),
      primaryColor: const Color(0xFF7C2D12), // Deep brown/bronze
      secondaryColor: const Color(0xFF92400E), // Lighter brown
      astralTypes: ['ore', 'earth', 'metal', 'crystal'],
      landmarks: [
        'Seoryn\'s Forge Temple',
        'The Great Foundry',
        'Crystal Cavern Networks',
        'Torren\'s Workshop Ruins',
        'The Relic Birthplace'
      ],
      recommendedLevel: 15,
      lore: '''
The Orespine Mountains rise like giant's teeth against the sky, their 
peaks gleaming with veins of precious metals and crystals. Here, the 
earth itself pulses with creative energy.

Seoryn, the great Ore Dragon, once made these peaks his domain. His 
breath forged the first relics, and his essence still flows through 
every vein of ore. Ore Astrals work tirelessly in the deep caverns, 
shaping metal and stone with their natural gifts.

Torren Duskbane maintains his workshop in the ancient temple ruins, 
surrounded by the tools and forges of a thousand generations of 
relic-crafters. The mountains themselves seem to sing with the rhythm 
of hammer on anvil.

These peaks hold the secret of relic creation - but also the danger 
of their corruption. SYN seeks to pervert this sacred craft.
      ''',
    ),
  };

  static Region? getRegion(RegionType type) {
    return regions[type];
  }

  static List<Region> getAllRegions() {
    return regions.values.toList();
  }

  static Region? getRegionAt(Vector2 position) {
    for (Region region in regions.values) {
      if (position.x >= region.position.x &&
          position.x <= region.position.x + region.size.x &&
          position.y >= region.position.y &&
          position.y <= region.position.y + region.size.y) {
        return region;
      }
    }
    return null;
  }

  static List<String> getRegionAstrals(RegionType type) {
    final region = regions[type];
    return region?.astralTypes ?? [];
  }

  static bool isRegionUnlocked(RegionType type, int playerLevel) {
    final region = regions[type];
    if (region == null) return false;
    return playerLevel >= region.recommendedLevel;
  }

  static String getRegionUnlockHint(RegionType type) {
    final region = regions[type];
    if (region == null) return 'Unknown region';
    
    switch (type) {
      case RegionType.grove:
        return 'Available from the start of your journey.';
      case RegionType.tide:
        return 'Unlocked after bonding with your first Astral. Seraya awaits your challenge.';
      case RegionType.ore:
        return 'Accessible once you\'ve proven your bonding skills. The mountains call to experienced Shamans.';
      case RegionType.hollow:
        return 'Only enter when you understand the truth of the cycle. Great danger and wisdom await.';
    }
  }

  static List<RegionType> getRegionProgression() {
    return [
      RegionType.grove,
      RegionType.tide,
      RegionType.ore,
      RegionType.hollow,
    ];
  }

  static Map<String, dynamic> getRegionEncounterData(RegionType type) {
    switch (type) {
      case RegionType.grove:
        return {
          'astralSpawnRate': 0.3,
          'commonAstrals': ['tuki', 'cindcub'],
          'rareAstrals': ['grove_guardian'],
          'synPresence': 0.0, // No SYN in starting area
          'resources': ['Grove Berries', 'Healing Herbs', 'Wood Essence'],
        };
      case RegionType.tide:
        return {
          'astralSpawnRate': 0.25,
          'commonAstrals': ['tide_serpent', 'gale_rider'],
          'rareAstrals': ['storm_king'],
          'synPresence': 0.1, // Light SYN activity
          'resources': ['Tide Crystals', 'Storm Essence', 'Pearl Fragments'],
        };
      case RegionType.ore:
        return {
          'astralSpawnRate': 0.2,
          'commonAstrals': ['ore_guardian', 'crystal_sprite'],
          'rareAstrals': ['mountain_lord'],
          'synPresence': 0.15, // Moderate SYN presence
          'resources': ['Ore Shards', 'Metal Essence', 'Crystal Cores'],
        };
      case RegionType.hollow:
        return {
          'astralSpawnRate': 0.15,
          'commonAstrals': ['hollow_shade'],
          'rareAstrals': ['void_walker', 'memory_keeper'],
          'synPresence': 0.4, // Heavy SYN corruption
          'resources': ['Void Crystals', 'Hollow Essence', 'Memory Fragments'],
        };
    }
  }
}