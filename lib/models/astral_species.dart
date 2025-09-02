enum AstralElement {
  dream,
  ember,
  blood, 
  ore,
  venom,
  radiant,
  storm,
  grove,
  tide,
  gale,
  hollow
}

enum AstralRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  divine,
  synthetic // For corrupted SYN Astrals
}

class AstralSpecies {
  final String id;
  final String name;
  final String description;
  final AstralElement element;
  final AstralRarity rarity;
  final List<String> moves;
  final Map<String, int> baseStats;
  final String? evolutionId;
  final int evolutionLevel;
  final bool isLegendary;
  final bool isSynthetic;
  final String lore;
  
  AstralSpecies({
    required this.id,
    required this.name,
    required this.description,
    required this.element,
    required this.rarity,
    required this.moves,
    required this.baseStats,
    this.evolutionId,
    this.evolutionLevel = 0,
    this.isLegendary = false,
    this.isSynthetic = false,
    required this.lore,
  });
  
  static final Map<String, AstralSpecies> species = {
    // Dream Astrals
    'tuki': AstralSpecies(
      id: 'tuki',
      name: 'Tuki',
      description: 'A small dream bird that phases between reality and dreams.',
      element: AstralElement.dream,
      rarity: AstralRarity.common,
      moves: ['Dream Wisp', 'Phase Step', 'Peaceful Aura'],
      baseStats: {'hp': 45, 'attack': 35, 'defense': 30, 'speed': 65},
      evolutionId: 'chronotoucan',
      evolutionLevel: 16,
      lore: 'Born from the dreams of sleeping children, Tuki carries whispers of tomorrow.',
    ),
    
    'chronotoucan': AstralSpecies(
      id: 'chronotoucan',
      name: 'Chronotoucan',
      description: 'An ancient dream guardian that can glimpse possible futures.',
      element: AstralElement.dream,
      rarity: AstralRarity.rare,
      moves: ['Future Sight', 'Time Echo', 'Prophetic Dream', 'Reality Rift'],
      baseStats: {'hp': 80, 'attack': 65, 'defense': 70, 'speed': 95},
      lore: 'Elder Kaelen bonds with Chronotoucan to see the threads of destiny.',
    ),
    
    // Ember/Ore Astrals
    'cindcub': AstralSpecies(
      id: 'cindcub',
      name: 'Cindcub',
      description: 'A playful fire cub with ember-bright fur.',
      element: AstralElement.ember,
      rarity: AstralRarity.common,
      moves: ['Ember Claw', 'Warm Hug', 'Spark Dash'],
      baseStats: {'hp': 50, 'attack': 45, 'defense': 35, 'speed': 40},
      evolutionId: 'cinderbeast',
      evolutionLevel: 18,
      lore: 'Found near the Grove Eternal, Cindcub brings warmth to cold nights.',
    ),
    
    'cinderbeast': AstralSpecies(
      id: 'cinderbeast',
      name: 'Cinderbeast',
      description: 'A powerful flame guardian with molten core.',
      element: AstralElement.ember,
      rarity: AstralRarity.uncommon,
      moves: ['Molten Roar', 'Flame Charge', 'Burning Spirit', 'Inferno Blast'],
      baseStats: {'hp': 85, 'attack': 90, 'defense': 75, 'speed': 60},
      lore: 'The evolved form radiates such heat it can forge ore with its breath.',
    ),
    
    // Blood Astrals
    'rylotl': AstralSpecies(
      id: 'rylotl',
      name: 'Rylotl',
      description: 'A crimson axolotl that regenerates from any wound.',
      element: AstralElement.blood,
      rarity: AstralRarity.uncommon,
      moves: ['Regenerate', 'Blood Bond', 'Life Drain'],
      baseStats: {'hp': 70, 'attack': 40, 'defense': 60, 'speed': 30},
      evolutionId: 'ryvenant',
      evolutionLevel: 20,
      lore: 'Its blood carries the memories of all who came before.',
    ),
    
    'ryvenant': AstralSpecies(
      id: 'ryvenant',
      name: 'Ryvenant',
      description: 'An ancient blood guardian that remembers every cycle.',
      element: AstralElement.blood,
      rarity: AstralRarity.rare,
      moves: ['Ancestral Memory', 'Blood Covenant', 'Cycle Renewal', 'Crimson Tide'],
      baseStats: {'hp': 120, 'attack': 70, 'defense': 95, 'speed': 45},
      lore: 'Keeper of the cycle, Ryvenant ensures no essence is truly lost.',
    ),
    
    // Legendary Dragons
    'seoryn': AstralSpecies(
      id: 'seoryn',
      name: 'Seoryn',
      description: 'The Ore Dragon, forger of the first relics.',
      element: AstralElement.ore,
      rarity: AstralRarity.divine,
      moves: ['Mountain Shatter', 'Relic Forge', 'Metal Storm', 'Earth Dominion'],
      baseStats: {'hp': 180, 'attack': 150, 'defense': 200, 'speed': 80},
      isLegendary: true,
      lore: 'Guardian of Orespine Mountains. Its breath creates the metal for relics.',
    ),
    
    'seovyn': AstralSpecies(
      id: 'seovyn',
      name: 'Seovyn',
      description: 'The Radiant Dragon, bringer of divine light.',
      element: AstralElement.radiant,
      rarity: AstralRarity.divine,
      moves: ['Divine Radiance', 'Healing Light', 'Purification', 'Celestial Judgment'],
      baseStats: {'hp': 180, 'attack': 140, 'defense': 160, 'speed': 120},
      isLegendary: true,
      lore: 'Its light purifies corruption and heals the wounded cycle.',
    ),
    
    'hollowyn': AstralSpecies(
      id: 'hollowyn',
      name: 'Hollowyn',
      description: 'The Hollow Dragon, guardian of endings and beginnings.',
      element: AstralElement.hollow,
      rarity: AstralRarity.divine,
      moves: ['Void Breath', 'Cycle End', 'Hollow Sphere', 'Entropy Wave'],
      baseStats: {'hp': 200, 'attack': 160, 'defense': 140, 'speed': 100},
      isLegendary: true,
      lore: 'Dwells in the Hollow Wastes. Its power controls the space between cycles.',
    ),
    
    // Tide Astrals (Seraya's partner)
    'tide_serpent': AstralSpecies(
      id: 'tide_serpent',
      name: 'Tide Serpent',
      description: "Seraya's loyal companion, master of ocean currents.",
      element: AstralElement.tide,
      rarity: AstralRarity.rare,
      moves: ['Tidal Wave', 'Current Rider', 'Ocean\'s Embrace', 'Tsunami Force'],
      baseStats: {'hp': 95, 'attack': 85, 'defense': 80, 'speed': 110},
      lore: 'Bonded to Seraya through playful rivalry and deep trust.',
    ),
    
    // Synthetic Astrals (SYN corrupted)
    'syn_phantom': AstralSpecies(
      id: 'syn_phantom',
      name: 'SYN Phantom',
      description: 'A corrupted Astral forced into synthetic form.',
      element: AstralElement.hollow,
      rarity: AstralRarity.synthetic,
      moves: ['Data Corruption', 'System Override', 'Forced Bond', 'Error Cascade'],
      baseStats: {'hp': 60, 'attack': 70, 'defense': 50, 'speed': 90},
      isSynthetic: true,
      lore: 'Once a proud Grove Astral, now enslaved by SYN\'s synthetic relics.',
    ),
  };
  
  static AstralSpecies? getSpecies(String id) {
    return species[id];
  }
  
  static List<AstralSpecies> getByElement(AstralElement element) {
    return species.values.where((s) => s.element == element).toList();
  }
  
  static List<AstralSpecies> getLegendarySpecies() {
    return species.values.where((s) => s.isLegendary).toList();
  }
  
  static List<AstralSpecies> getSyntheticSpecies() {
    return species.values.where((s) => s.isSynthetic).toList();
  }
  
  bool canEvolve(int currentLevel) {
    return evolutionId != null && currentLevel >= evolutionLevel;
  }
  
  AstralSpecies? getEvolution() {
    if (evolutionId == null) return null;
    return species[evolutionId];
  }
  
  String getElementDescription() {
    switch (element) {
      case AstralElement.dream:
        return 'Masters of the dreamscape, wielding illusion and prophecy.';
      case AstralElement.ember:
        return 'Flame guardians bringing warmth and forge-fire.';
      case AstralElement.blood:
        return 'Keepers of memory and the cycle of renewal.';
      case AstralElement.ore:
        return 'Earth shapers and relic forgers of mountain strength.';
      case AstralElement.radiant:
        return 'Divine beings of pure light and healing.';
      case AstralElement.hollow:
        return 'Void touched entities governing space between cycles.';
      case AstralElement.tide:
        return 'Ocean rulers commanding currents and storms.';
      case AstralElement.grove:
        return 'Forest guardians nurturing life and growth.';
      default:
        return 'Mysterious Astrals of unknown origin.';
    }
  }
}