import 'package:flutter/material.dart';

enum RelicType {
  normal,   // Blue - Common, bonds basic Astrals
  worn,     // Green - Uncommon, bonds Astrals with older lifetimes
  strong,   // Pink - Rare, bonds battle-forged Astrals
  ancient,  // Purple - Very rare, tied to myths/ancestry
  legendary, // Red - Extremely rare, shards of the first Cycle
  mythic    // Gold - Rarest, bonds any Astral (even Divine/Mythic)
}

class Relic {
  final String id;
  final String name;
  final RelicType type;
  final String description;
  final int bondingPower;
  final List<String> compatibleAstralTypes;
  final bool isCorrupted;
  
  Relic({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.bondingPower,
    this.compatibleAstralTypes = const [],
    this.isCorrupted = false,
  });
  
  Color get color {
    switch (type) {
      case RelicType.normal:
        return const Color(0xFF4A90E2); // Blue
      case RelicType.worn:
        return const Color(0xFF7ED321); // Green
      case RelicType.strong:
        return const Color(0xFFFF6B9D); // Pink
      case RelicType.ancient:
        return const Color(0xFF9013FE); // Purple
      case RelicType.legendary:
        return const Color(0xFFE53E3E); // Red
      case RelicType.mythic:
        return const Color(0xFFFFD700); // Gold
    }
  }
  
  String get rarityText {
    switch (type) {
      case RelicType.normal:
        return 'Common';
      case RelicType.worn:
        return 'Uncommon';
      case RelicType.strong:
        return 'Rare';
      case RelicType.ancient:
        return 'Very Rare';
      case RelicType.legendary:
        return 'Extremely Rare';
      case RelicType.mythic:
        return 'Mythic';
    }
  }
  
  double get bondingMultiplier {
    switch (type) {
      case RelicType.normal:
        return 1.0;
      case RelicType.worn:
        return 1.2;
      case RelicType.strong:
        return 1.5;
      case RelicType.ancient:
        return 2.0;
      case RelicType.legendary:
        return 2.5;
      case RelicType.mythic:
        return 3.0;
    }
  }
  
  bool canBondWith(String astralType, int astralLevel) {
    if (isCorrupted) return false; // Synthetic relics force bond
    if (type == RelicType.mythic) return true; // Mythic can bond any Astral
    
    if (compatibleAstralTypes.isNotEmpty && 
        !compatibleAstralTypes.contains(astralType)) {
      return false;
    }
    
    // Level requirements based on relic type
    switch (type) {
      case RelicType.normal:
        return astralLevel <= 10;
      case RelicType.worn:
        return astralLevel <= 20;
      case RelicType.strong:
        return astralLevel <= 30;
      case RelicType.ancient:
        return astralLevel <= 50;
      case RelicType.legendary:
        return astralLevel <= 80;
      case RelicType.mythic:
        return true;
    }
  }
  
  String getFlavorText() {
    switch (type) {
      case RelicType.normal:
        return 'A smooth stone that glows faintly blue. Perfect for your first bondings.';
      case RelicType.worn:
        return 'Mossy cracks tell stories of countless cycles. Ancient wisdom flows within.';
      case RelicType.strong:
        return 'The warm pink glow pulses with the strength of battle-tested bonds.';
      case RelicType.ancient:
        return 'It hums with ancestral memories, connecting you to shamans of old.';
      case RelicType.legendary:
        return 'Jagged crimson shards of the first Cycle. Power courses through its fractures.';
      case RelicType.mythic:
        return 'Starlight captured in stone. The Spark of Creation itself - bonds any soul.';
    }
  }
  
  Relic createSyntheticVersion() {
    return Relic(
      id: '${id}_synthetic',
      name: 'Synthetic $name',
      type: type,
      description: 'A corrupted version that forces unwilling bonds.',
      bondingPower: bondingPower * 2, // More powerful but corrupting
      compatibleAstralTypes: ['all'], // Can force bond any type
      isCorrupted: true,
    );
  }
  
  static List<Relic> getStarterRelics() {
    return [
      Relic(
        id: 'basic_grove',
        name: 'Grove Stone',
        type: RelicType.normal,
        description: 'Your first relic, blessed by the Grove Eternal.',
        bondingPower: 10,
        compatibleAstralTypes: ['grove', 'ember'],
      ),
      Relic(
        id: 'tide_shard',
        name: 'Tide Shard',
        type: RelicType.normal,
        description: 'A fragment from the Tidecaller Archipelago.',
        bondingPower: 10,
        compatibleAstralTypes: ['tide', 'gale'],
      ),
    ];
  }
  
  static List<Relic> getLegendaryRelics() {
    return [
      Relic(
        id: 'dragons_heart',
        name: "Dragon's Heart",
        type: RelicType.legendary,
        description: 'Contains the essence of the great dragons.',
        bondingPower: 100,
        compatibleAstralTypes: ['dragon', 'hollow', 'ore'],
      ),
      Relic(
        id: 'spark_of_creation',
        name: 'Spark of Creation',
        type: RelicType.mythic,
        description: 'The original relic that began all bonds.',
        bondingPower: 200,
        compatibleAstralTypes: [], // Empty means all types
      ),
    ];
  }
}