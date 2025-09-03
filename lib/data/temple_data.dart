import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../models/npc.dart';

class Temple {
  final String id;
  final String name;
  final String region;
  final Vector2 position;
  final String philosophy;
  final String stewardName;
  final String stewardPhilosophy;
  final Color templeColor;

  Temple({
    required this.id,
    required this.name,
    required this.region,
    required this.position,
    required this.philosophy,
    required this.stewardName,
    required this.stewardPhilosophy,
    required this.templeColor,
  });
}

class TempleData {
  static final Map<String, Temple> temples = {
    'tidecaller_temple': Temple(
      id: 'tidecaller_temple',
      name: 'Tidecaller Temple',
      region: 'tide',
      position: Vector2(900, 400), // Bottom-left/middle (Tide region)
      philosophy: 'Flow with The Cycle as the tides flow with the moon.',
      stewardName: 'Keeper Nereia',
      stewardPhilosophy: 'The deepest currents carry the oldest wisdom.',
      templeColor: const Color(0xFF1E40AF), // Blue wave
    ),
    
    'temple_of_hollowyn': Temple(
      id: 'temple_of_hollowyn',
      name: 'Temple of Hollowyn',
      region: 'hollow',
      position: Vector2(1200, 200), // Top-right (Hollow region)
      philosophy: 'In ending, we find beginning. In void, we discover meaning.',
      stewardName: 'Voidkeeper Malachar',
      stewardPhilosophy: 'Death is but The Cycle\'s doorway to rebirth.',
      templeColor: const Color(0xFF374151), // Dark hollow gray
    ),
    
    'temple_of_seoryn': Temple(
      id: 'temple_of_seoryn',
      name: 'Temple of Seoryn',
      region: 'ore',
      position: Vector2(1000, 800), // Bottom-right, top side (Ore region)
      philosophy: 'Forge your bonds as we forge relics - with patience and fire.',
      stewardName: 'Forgemaster Theron',
      stewardPhilosophy: 'True strength is tempered in the heart, not the hammer.',
      templeColor: const Color(0xFF7C2D12), // Bronze/brown ore
    ),
    
    'temple_of_seovyn': Temple(
      id: 'temple_of_seovyn',
      name: 'Temple of Seovyn',
      region: 'ore',
      position: Vector2(1000, 1000), // Bottom-right, bottom side (Ore region)
      philosophy: 'Let your bonds shine with the light of pure intention.',
      stewardName: 'Lightbringer Aurelia',
      stewardPhilosophy: 'Radiance heals all wounds that shadow inflicts.',
      templeColor: const Color(0xFFFFD700), // Radiant gold
    ),
  };

  static Temple? getTemple(String id) {
    return temples[id];
  }

  static List<Temple> getTemplesByRegion(String region) {
    return temples.values.where((t) => t.region == region).toList();
  }

  static List<Temple> getAllTemples() {
    return temples.values.toList();
  }

  static NPC createTempleSteward(Temple temple) {
    return NPC(
      id: '${temple.id}_steward',
      name: temple.stewardName,
      role: NPCRole.priest,
      description: 'Steward of ${temple.name}, keeper of ancient wisdom.',
      position: temple.position,
      dialogueTrees: {
        'default': DialogueTree(
          greeting: 'Welcome to ${temple.name}. ${temple.stewardPhilosophy}',
          options: [
            DialogueOption(
              text: 'Tell me about this temple.',
              response: '${temple.philosophy} Here, we honor The Cycle and guide those who seek deeper understanding.',
            ),
            DialogueOption(
              text: 'Can you teach me about the Purify Rite?',
              response: 'The Purify Rite combines Radiant and Dream essence to free Synthetics. When you are ready, I will guide you through this sacred ritual.',
              consequences: {'setFlag': {'flag': 'purify_rite_available', 'value': true}},
            ),
            DialogueOption(
              text: 'What wisdom do you offer?',
              response: temple.stewardPhilosophy,
            ),
          ],
        ),
      },
    );
  }

  // Regional sayings for flavor
  static final Map<String, List<String>> regionalSayings = {
    'grove': [
      'As the root feeds the tree, so care feeds the bond.',
      'In Grove\'s embrace, all spirits find their home.',
      'The oldest trees remember the first bonds.',
    ],
    'tide': [
      'Like tides, bonds ebb and flow but never truly break.',
      'The deepest currents run silent and true.',
      'In storm and calm, Tidecaller guides us home.',
    ],
    'ore': [
      'What is forged in fire endures through ages.',
      'Each relic carries the maker\'s heart within.',
      'Strength without wisdom crumbles like weak ore.',
    ],
    'hollow': [
      'In The Cycle\'s shadow, we learn light\'s true value.',
      'What disperses returns, what ends begins anew.',
      'Hollow teaches us that emptiness holds infinite potential.',
    ],
  };

  static String getRandomSaying(String region) {
    final sayings = regionalSayings[region];
    if (sayings == null || sayings.isEmpty) return 'The Cycle continues.';
    
    final index = DateTime.now().millisecondsSinceEpoch % sayings.length;
    return sayings[index];
  }

  static Map<String, String> getTemplePhilosophies() {
    return {
      for (var temple in temples.values) temple.name: temple.philosophy
    };
  }

  // Travel unlock messages
  static final Map<String, String> travelUnlockMessages = {
    'tide': 'The boats to Tidecaller Archipelago await your journey.',
    'ore': 'The mountain paths to Orespine peaks lie open before you.',
    'hollow': 'The shadow roads to Hollow Wastes whisper your name.',
  };

  static String? getTravelUnlockMessage(String region) {
    return travelUnlockMessages[region];
  }
}