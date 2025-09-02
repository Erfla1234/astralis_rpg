import 'package:flame/components.dart';
import '../models/astral.dart';

enum VillainRank {
  grunt,
  engineer,
  commander,
  lieutenant,
  leader
}

class SynVillain {
  final String id;
  final String name;
  final VillainRank rank;
  final String description;
  final Vector2 position;
  final List<Astral> syntheticAstrals;
  final Map<String, int> stats;
  final List<String> abilities;
  final String quote;
  final String backstory;
  final bool isRecurring;
  
  bool isDefeated = false;
  int encounterCount = 0;
  
  SynVillain({
    required this.id,
    required this.name,
    required this.rank,
    required this.description,
    required this.position,
    required this.syntheticAstrals,
    required this.stats,
    required this.abilities,
    required this.quote,
    required this.backstory,
    this.isRecurring = false,
  });
  
  int get threatLevel {
    switch (rank) {
      case VillainRank.grunt:
        return 1;
      case VillainRank.engineer:
        return 3;
      case VillainRank.commander:
        return 5;
      case VillainRank.lieutenant:
        return 7;
      case VillainRank.leader:
        return 10;
    }
  }
  
  String get rankTitle {
    switch (rank) {
      case VillainRank.grunt:
        return 'SYN Operative';
      case VillainRank.engineer:
        return 'Synthetic Engineer';
      case VillainRank.commander:
        return 'Field Commander';
      case VillainRank.lieutenant:
        return 'SYN Lieutenant';
      case VillainRank.leader:
        return 'SYN Leader';
    }
  }
  
  List<String> getDialogue() {
    switch (rank) {
      case VillainRank.grunt:
        return [
          'The Synthetic Order will prevail!',
          'Your primitive bonding methods are obsolete.',
          'Surrender your Astrals for synthetic conversion!'
        ];
      case VillainRank.engineer:
        return [
          'Observe the perfection of synthetic evolution!',
          'Natural bonds are flawed - I have created something better.',
          'Each Astral I convert grows stronger!'
        ];
      case VillainRank.commander:
        return [
          'The old cycle ends today, Shaman.',
          'Your Astrals will serve the Synthetic Order.',
          'Resistance is futile - evolution demands progress!'
        ];
      case VillainRank.lieutenant:
        return [
          'Dr. Veyra\'s vision will reshape this world.',
          'The dragons will bow to synthetic supremacy!',
          'Your bonds are chains - we offer freedom!'
        ];
      case VillainRank.leader:
        return [
          quote,
          'The cycle of death and rebirth ends with me.',
          'Behold the future - eternal, perfect, synthetic!'
        ];
    }
  }
  
  void defeat() {
    isDefeated = true;
    encounterCount++;
    
    // Recurring villains can return
    if (isRecurring && encounterCount < 3) {
      // Schedule return after some time
      Future.delayed(const Duration(minutes: 30), () {
        isDefeated = false;
      });
    }
  }
  
  Map<String, int> getRewards() {
    switch (rank) {
      case VillainRank.grunt:
        return {'experience': 50, 'synthetic_parts': 1};
      case VillainRank.engineer:
        return {'experience': 100, 'synthetic_parts': 3, 'corrupted_essence': 1};
      case VillainRank.commander:
        return {'experience': 200, 'synthetic_parts': 5, 'corrupted_essence': 2};
      case VillainRank.lieutenant:
        return {'experience': 400, 'synthetic_parts': 8, 'corrupted_essence': 4};
      case VillainRank.leader:
        return {'experience': 1000, 'synthetic_parts': 15, 'corrupted_essence': 10, 'liberation_key': 1};
    }
  }
}

class SynVillainData {
  static final Map<String, SynVillain> villains = {
    'dr_veyra': SynVillain(
      id: 'dr_veyra',
      name: 'Dr. Veyra',
      rank: VillainRank.leader,
      description: 'A masked figure clad in black steel and glowing circuitry, wielding the first Synthetic Astral. No one has seen his true face.',
      position: Vector2(1200, 800), // Deep in SYN territory
      syntheticAstrals: [], // Will be populated with strongest synthetics
      stats: {'health': 500, 'attack': 100, 'defense': 80, 'speed': 60},
      abilities: ['Synthetic Command', 'Corruption Wave', 'System Override', 'Eternal Protocol'],
      quote: 'Why let them die and be reborn when I can give them eternity?',
      backstory: '''
        Once the most brilliant Shaman of his generation, Dr. Veyra witnessed the death 
        of his bonded Astral and couldn't bear the cycle of loss. His obsession with 
        preventing death led him to discover synthetic bonding - a way to trap Astral 
        essence in mechanical forms, denying them their natural rebirth.
        
        Now he leads the Synthetic Order, believing he's saving Astrals from the 
        "cruelty" of the cycle. His mask hides not just his face, but the synthetic 
        modifications he's made to his own body.
      ''',
      isRecurring: false, // Final boss
    ),

    'lyra_veyne': SynVillain(
      id: 'lyra_veyne',
      name: 'Lyra Veyne',
      rank: VillainRank.lieutenant,
      description: 'Elegant woman with silver hair and a mechanical arm forged from corrupted relics. Commands a squad of Shadow Astrals.',
      position: Vector2(900, 600),
      syntheticAstrals: [], // Shadow-type synthetics
      stats: {'health': 300, 'attack': 80, 'defense': 60, 'speed': 90},
      abilities: ['Shadow Command', 'Relic Corruption', 'Mind Break', 'Synthetic Swarm'],
      quote: 'Every Astral you save, I can twist into something stronger.',
      backstory: '''
        Dr. Veyra's most trusted lieutenant, Lyra lost her arm in an early synthetic 
        experiment gone wrong. Rather than despair, she embraced the synthetic 
        enhancement, replacing her limb with a mechanical one powered by corrupted 
        relic energy.
        
        She specializes in corrupting existing bonds, turning Shamans' own Astrals 
        against them. Her cruelty stems from jealousy of natural bonds she can 
        no longer form.
      ''',
      isRecurring: true,
    ),

    'draven_coil': SynVillain(
      id: 'draven_coil',
      name: 'Draven Coil',
      rank: VillainRank.engineer,
      description: 'Hunched figure in soot-stained coat, goggles glowing faint green. Carries a toolkit of strange relic-shards.',
      position: Vector2(700, 500),
      syntheticAstrals: [], // Experimental prototypes
      stats: {'health': 200, 'attack': 60, 'defense': 40, 'speed': 70},
      abilities: ['Synthetic Creation', 'Relic Fusion', 'Essence Drain', 'Proto-Summon'],
      quote: 'Metal and essence… oh, the screams are exquisite when they fuse.',
      backstory: '''
        A mad genius who discovered the process of fusing Astral essence with 
        mechanical components. Draven's obsession with "perfect fusion" has 
        driven him to horrific experiments on captured Astrals.
        
        His workshop is filled with failed synthetic prototypes, each one a 
        tortured soul trapped in metal. He views this suffering as "necessary 
        for progress" and delights in the process of corruption.
      ''',
      isRecurring: true,
    ),

    'commander_rhogar': SynVillain(
      id: 'commander_rhogar',
      name: 'Commander Rhogar',
      rank: VillainRank.commander,
      description: 'Former Shaman who bonded with a Magmursa but turned to Hollowed Forge after his Astral was corrupted. His body now half-fused with molten armor.',
      position: Vector2(600, 400),
      syntheticAstrals: [], // Fire/Ore corrupted types
      stats: {'health': 350, 'attack': 90, 'defense': 85, 'speed': 50},
      abilities: ['Molten Charge', 'Armor Fusion', 'Synthetic Rage', 'Corrupted Bond'],
      quote: 'The Hollow gave me strength. Strength I\'ll use to crush your fragile cycle.',
      backstory: '''
        Once a respected Fire Shaman, Rhogar's world shattered when his beloved 
        Magmursa was corrupted by early SYN experiments. Instead of letting it 
        die and be reborn naturally, he allowed the corruption to spread to 
        himself, fusing his body with synthetic armor.
        
        Now he serves as SYN's military commander, his rage fueling both his 
        power and his loyalty to Dr. Veyra. He believes the synthetic path is 
        the only way to prevent loss.
      ''',
      isRecurring: true,
    ),

    'syn_operative_alpha': SynVillain(
      id: 'syn_operative_alpha',
      name: 'SYN Operative Alpha',
      rank: VillainRank.grunt,
      description: 'Standard SYN soldier in dark uniform, carrying synthetic capture devices.',
      position: Vector2(400, 300),
      syntheticAstrals: [], // Basic synthetic types
      stats: {'health': 100, 'attack': 40, 'defense': 30, 'speed': 50},
      abilities: ['Capture Net', 'Synthetic Summon', 'Stun Blast'],
      quote: 'Surrender your Astrals for the greater good!',
      backstory: '''
        One of many faceless operatives who enforce SYN's will. These soldiers 
        believe they're saving Astrals from the "cruelty" of death and rebirth, 
        not understanding the true horror of synthetic conversion.
        
        Most are former Shamans whose bonds were corrupted or broken, leaving 
        them vulnerable to SYN recruitment.
      ''',
      isRecurring: true,
    ),
  };

  static SynVillain? getVillain(String id) {
    return villains[id];
  }

  static List<SynVillain> getVillainsByRank(VillainRank rank) {
    return villains.values.where((v) => v.rank == rank).toList();
  }

  static List<SynVillain> getActiveVillains() {
    return villains.values.where((v) => !v.isDefeated).toList();
  }

  static SynVillain? getBossForRegion(String regionId) {
    switch (regionId) {
      case 'grove_eternal':
        return null; // No SYN presence in starting area
      case 'tidecaller_archipelago':
        return villains['syn_operative_alpha']; // Light presence
      case 'orespine_mountains':
        return villains['draven_coil']; // Engineer in ore-rich region
      case 'hollow_wastes':
        return villains['commander_rhogar']; // Heavy SYN corruption
      case 'syn_headquarters':
        return villains['dr_veyra']; // Final boss
      default:
        return null;
    }
  }

  static List<String> getVillainEncounterDialogue(String villainId, String encounterType) {
    final villain = villains[villainId];
    if (villain == null) return ['...'];

    switch (encounterType) {
      case 'first_encounter':
        return [
          villain.quote,
          'So, another Shaman clings to the old ways.',
          'Let me show you the future!'
        ];
      case 'battle_start':
        return [
          'Your bonds are weakness!',
          'Observe synthetic perfection!',
          'The cycle ends here!'
        ];
      case 'defeat':
        return [
          'This... this cannot be...',
          'The synthetic order... will endure...',
          'You understand nothing of true power!'
        ];
      case 'escape':
        return [
          'This isn\'t over, Shaman!',
          'Next time, you won\'t be so fortunate.',
          'The corruption spreads even as we speak!'
        ];
      default:
        return villain.getDialogue();
    }
  }

  static Map<String, dynamic> getVillainLoot(String villainId) {
    final villain = villains[villainId];
    return villain?.getRewards() ?? {};
  }
}