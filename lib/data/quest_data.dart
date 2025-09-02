import '../models/quest.dart';

class QuestData {
  static final Map<String, Quest> quests = {
    'awakening_journey': Quest(
      id: 'awakening_journey',
      title: 'The Awakening Journey',
      description: 'Elder Kaelen has sensed great potential in you. Begin your path as a Shaman and discover your first Astral companion.',
      type: QuestType.main,
      objectives: [
        QuestObjective(
          id: 'meet_elder_kaelen',
          description: 'Speak with Elder Kaelen about your destiny',
          requirements: {'talkToNPC': 'elder_kaelen'},
        ),
        QuestObjective(
          id: 'receive_first_relic',
          description: 'Receive your first bonding relic',
          requirements: {'flag': {'name': 'has_first_relic', 'value': true}},
        ),
        QuestObjective(
          id: 'bond_first_astral',
          description: 'Form a bond with your first Astral companion',
          requirements: {'bondAstral': 'any'},
        ),
      ],
      experienceReward: 100,
      relicReward: 1,
      itemRewards: {'Grove Stone': 1, 'Astral Food': 5},
    ),

    'hollow_threat_revealed': Quest(
      id: 'hollow_threat_revealed',
      title: 'The Hollow Threat Revealed',
      description: 'Elder Kaelen has revealed the truth about the Hollow Essence and the SYN faction. You must understand the true scope of the threat.',
      type: QuestType.main,
      objectives: [
        QuestObjective(
          id: 'learn_hollow_history',
          description: 'Learn about the Hollow Essence from Elder Kaelen',
          requirements: {'flag': {'name': 'knows_hollow_threat', 'value': true}},
        ),
        QuestObjective(
          id: 'encounter_syn_forces',
          description: 'Witness or encounter SYN synthetic Astrals',
          requirements: {'flag': {'name': 'encountered_syn', 'value': true}},
        ),
        QuestObjective(
          id: 'visit_hollow_wastes',
          description: 'Travel to the Hollow Wastes to see the ancient dragon skull',
          requirements: {'visitLocation': 'hollow_wastes'},
        ),
      ],
      experienceReward: 200,
      relicReward: 2,
      prerequisiteQuests: ['awakening_journey'],
    ),

    'seek_mythic_relic': Quest(
      id: 'seek_mythic_relic',
      title: 'Seek the Mythic Relic',
      description: 'Elder Kaelen believes only the Spark of Creation can heal the cycle. Begin your quest to prove yourself worthy of this legendary relic.',
      type: QuestType.main,
      objectives: [
        QuestObjective(
          id: 'bond_five_astrals',
          description: 'Form bonds with at least 5 different Astrals',
          requirements: {'bondAstral': 'count_5'},
        ),
        QuestObjective(
          id: 'visit_all_temples',
          description: 'Visit the temples of Seoryn, Seovyn, and Hollowyn',
          requirements: {'visitLocation': 'all_dragon_temples'},
        ),
        QuestObjective(
          id: 'defeat_syn_commander',
          description: 'Defeat a SYN commander to prove your strength',
          requirements: {'flag': {'name': 'defeated_syn_commander', 'value': true}},
        ),
      ],
      experienceReward: 500,
      relicReward: 1, // The Mythic Relic itself
      itemRewards: {'Spark of Creation': 1},
      prerequisiteQuests: ['hollow_threat_revealed'],
    ),

    'rivalry_with_seraya': Quest(
      id: 'rivalry_with_seraya',
      title: 'Friendly Rivalry',
      description: 'Seraya has challenged you to a friendly competition. Show her your bonding skills while learning from each other.',
      type: QuestType.side,
      objectives: [
        QuestObjective(
          id: 'battle_seraya',
          description: 'Accept Seraya\'s challenge to a friendly Astral battle',
          requirements: {'flag': {'name': 'seraya_battle_available', 'value': true}},
        ),
        QuestObjective(
          id: 'bond_tide_astral',
          description: 'Bond with a Tide-element Astral to impress Seraya',
          requirements: {'bondAstral': 'tide_element'},
        ),
      ],
      experienceReward: 150,
      relicReward: 0,
      itemRewards: {'Tide Shard': 1, 'Battle Experience': 1},
    ),

    'relic_master_training': Quest(
      id: 'relic_master_training',
      title: 'Relic Master Training',
      description: 'Torren Duskbane offers to teach you the deeper mysteries of relic crafting and enhancement.',
      type: QuestType.side,
      objectives: [
        QuestObjective(
          id: 'bring_essence_crystals',
          description: 'Collect 10 Astral Essence Crystals for Torren',
          requirements: {'collectItem': {'item': 'Astral Essence Crystal', 'quantity': 10}},
        ),
        QuestObjective(
          id: 'upgrade_relic',
          description: 'Have Torren upgrade one of your relics',
          requirements: {'flag': {'name': 'relic_upgraded', 'value': true}},
        ),
        QuestObjective(
          id: 'learn_syn_corruption',
          description: 'Learn about Synthetic Relic corruption from Torren',
          requirements: {'flag': {'name': 'knows_synthetic_corruption', 'value': true}},
        ),
      ],
      experienceReward: 120,
      relicReward: 0,
      itemRewards: {'Enhanced Relic': 1},
    ),

    'grove_guardian': Quest(
      id: 'grove_guardian',
      title: 'Guardian of the Grove',
      description: 'The Grove Eternal needs a protector. Bond with the Grove Astrals and become their guardian.',
      type: QuestType.exploration,
      objectives: [
        QuestObjective(
          id: 'bond_grove_astrals',
          description: 'Bond with all Astrals found in the Grove Eternal',
          requirements: {'bondAstral': 'grove_all'},
        ),
        QuestObjective(
          id: 'purify_grove_shrine',
          description: 'Cleanse the Grove shrine of any corruption',
          requirements: {'flag': {'name': 'grove_shrine_purified', 'value': true}},
        ),
      ],
      experienceReward: 180,
      relicReward: 1,
      itemRewards: {'Grove Guardian Badge': 1, 'Nature\'s Blessing': 1},
    ),

    'synthetic_liberation': Quest(
      id: 'synthetic_liberation',
      title: 'Liberation of the Synthetic',
      description: 'A synthetic Astral suffers under SYN control. Use your growing power to free it from corruption.',
      type: QuestType.bonding,
      objectives: [
        QuestObjective(
          id: 'find_syn_phantom',
          description: 'Locate the corrupted SYN Phantom',
          requirements: {'flag': {'name': 'found_syn_phantom', 'value': true}},
        ),
        QuestObjective(
          id: 'obtain_purification_relic',
          description: 'Acquire a relic capable of purifying synthetic corruption',
          requirements: {'collectItem': {'item': 'Purification Crystal', 'quantity': 1}},
        ),
        QuestObjective(
          id: 'liberate_phantom',
          description: 'Free the SYN Phantom from its synthetic bonds',
          requirements: {'bondAstral': 'syn_phantom'},
        ),
      ],
      experienceReward: 300,
      relicReward: 1,
      itemRewards: {'Liberation Medal': 1, 'Purified Essence': 3},
    ),

    'dragon_temple_pilgrimage': Quest(
      id: 'dragon_temple_pilgrimage',
      title: 'Dragon Temple Pilgrimage',
      description: 'Visit the ancient temples of the three great dragons to understand their role in the cycle.',
      type: QuestType.exploration,
      objectives: [
        QuestObjective(
          id: 'visit_seoryn_temple',
          description: 'Pay respects at the Temple of Seoryn in Orespine Mountains',
          requirements: {'visitLocation': 'seoryn_temple'},
        ),
        QuestObjective(
          id: 'visit_seovyn_temple',
          description: 'Commune at the Temple of Seovyn in Radiant Peaks',
          requirements: {'visitLocation': 'seovyn_temple'},
        ),
        QuestObjective(
          id: 'visit_hollowyn_temple',
          description: 'Meditate at the Temple of Hollowyn in Hollow Wastes',
          requirements: {'visitLocation': 'hollowyn_temple'},
        ),
      ],
      experienceReward: 250,
      relicReward: 0,
      itemRewards: {'Dragon\'s Blessing': 3, 'Ancient Knowledge': 1},
    ),

    'final_confrontation': Quest(
      id: 'final_confrontation',
      title: 'The Final Confrontation',
      description: 'SYN plans to forge the Synthetic Eternal Dragon by corrupting Seoryn, Seovyn, and Hollowyn. You must stop them.',
      type: QuestType.main,
      objectives: [
        QuestObjective(
          id: 'infiltrate_syn_base',
          description: 'Infiltrate the SYN headquarters',
          requirements: {'visitLocation': 'syn_headquarters'},
        ),
        QuestObjective(
          id: 'defeat_dr_veyra',
          description: 'Confront and defeat Dr. Veyra',
          requirements: {'flag': {'name': 'defeated_dr_veyra', 'value': true}},
        ),
        QuestObjective(
          id: 'save_dragons',
          description: 'Prevent the corruption of the three great dragons',
          requirements: {'flag': {'name': 'dragons_saved', 'value': true}},
        ),
        QuestObjective(
          id: 'restore_cycle',
          description: 'Use the Spark of Creation to heal the cycle',
          requirements: {'flag': {'name': 'cycle_restored', 'value': true}},
        ),
      ],
      experienceReward: 1000,
      relicReward: 0,
      itemRewards: {'Cycle Guardian Title': 1, 'Eternal Peace': 1},
      prerequisiteQuests: ['seek_mythic_relic'],
    ),
  };

  static Quest? getQuest(String id) {
    return quests[id];
  }

  static List<Quest> getQuestsByType(QuestType type) {
    return quests.values.where((q) => q.type == type).toList();
  }

  static List<Quest> getAvailableQuests(List<String> completedQuestIds) {
    return quests.values.where((quest) {
      if (quest.status != QuestStatus.inactive) return false;
      
      for (String prereq in quest.prerequisiteQuests) {
        if (!completedQuestIds.contains(prereq)) return false;
      }
      
      return true;
    }).toList();
  }

  static List<Quest> getMainStoryQuests() {
    return getQuestsByType(QuestType.main)
      ..sort((a, b) => _getMainQuestOrder(a.id).compareTo(_getMainQuestOrder(b.id)));
  }

  static int _getMainQuestOrder(String questId) {
    const order = {
      'awakening_journey': 0,
      'hollow_threat_revealed': 1,
      'seek_mythic_relic': 2,
      'final_confrontation': 3,
    };
    return order[questId] ?? 999;
  }

  static String getQuestGiver(String questId) {
    const questGivers = {
      'awakening_journey': 'elder_kaelen',
      'hollow_threat_revealed': 'elder_kaelen',
      'seek_mythic_relic': 'elder_kaelen',
      'rivalry_with_seraya': 'seraya',
      'relic_master_training': 'torren_duskbane',
      'grove_guardian': 'grove_spirit',
      'synthetic_liberation': 'elder_kaelen',
      'dragon_temple_pilgrimage': 'elder_kaelen',
      'final_confrontation': 'elder_kaelen',
    };
    return questGivers[questId] ?? 'unknown';
  }
}