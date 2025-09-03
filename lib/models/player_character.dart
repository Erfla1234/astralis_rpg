class PlayerCharacter {
  String name;
  final String defaultName = 'Aelira';
  int level;
  int experience;
  Map<String, int> stats;
  
  PlayerCharacter({
    String? customName,
    this.level = 1,
    this.experience = 0,
    Map<String, int>? customStats,
  }) : name = customName ?? 'Aelira',
       stats = customStats ?? {
         'health': 100,
         'energy': 50,
         'bonding_power': 10,
         'trust_affinity': 15,
       };
  
  // Experience needed for next level
  int get experienceToNextLevel {
    return (level * 100) - experience;
  }
  
  // Check if player can level up
  bool canLevelUp() {
    return experience >= (level * 100);
  }
  
  // Level up the player
  void levelUp() {
    if (canLevelUp()) {
      level++;
      stats['health'] = (stats['health']! * 1.1).round();
      stats['energy'] = (stats['energy']! * 1.1).round();
      stats['bonding_power'] = stats['bonding_power']! + 2;
      stats['trust_affinity'] = stats['trust_affinity']! + 3;
    }
  }
  
  // Add experience and auto-level if ready
  void addExperience(int amount) {
    experience += amount;
    while (canLevelUp()) {
      levelUp();
    }
  }
  
  // Get greeting based on context
  String getContextualGreeting(String context) {
    switch (context) {
      case 'first_astral':
        return 'Hello there, little one. I\'m $name. Want to be friends?';
      case 'temple_visit':
        return 'I seek wisdom about The Cycle and the bonds we share.';
      case 'syn_encounter':
        return 'Your synthetic abominations mock The Cycle itself!';
      case 'friendly':
        return 'Hi! I\'m $name. Nice to meet you!';
      default:
        return 'I am $name, seeker of bonds and protector of The Cycle.';
    }
  }
  
  // Player responses to various situations
  Map<String, List<String>> getDialogueOptions(String situation) {
    switch (situation) {
      case 'astral_encounter':
        return {
          'gentle': ['Show Care', 'Offer friendship', 'Speak softly'],
          'playful': ['Want to play?', 'Let\'s have fun together!', 'You seem energetic!'],
          'wise': ['I seek your wisdom', 'Teach me about The Cycle', 'Share your knowledge'],
          'mysterious': ['What secrets do you hold?', 'I sense mystery around you', 'Reveal your truth'],
        };
      
      case 'npc_conversation':
        return {
          'polite': ['Thank you for your time', 'I appreciate your wisdom', 'How may I help?'],
          'curious': ['Tell me more', 'What do you know about...?', 'I\'m eager to learn'],
          'urgent': ['This is important!', 'We must act quickly', 'Time is running short'],
        };
        
      case 'temple_interaction':
        return {
          'respectful': ['I come seeking guidance', 'Honor to The Cycle', 'Teach me the ancient ways'],
          'desperate': ['Please, help me understand', 'The Synthetics threaten everything', 'How do I save them?'],
          'scholarly': ['What can you teach me?', 'I study The Cycle\'s mysteries', 'Share your philosophy'],
        };
        
      default:
        return {
          'default': ['Continue', 'I understand', 'Tell me more'],
        };
    }
  }
  
  // Character's personal philosophy based on player actions
  String getPersonalPhilosophy() {
    final bondingPower = stats['bonding_power']!;
    final trustAffinity = stats['trust_affinity']!;
    
    if (trustAffinity > 30) {
      return 'The strongest bonds are built on mutual trust and understanding.';
    } else if (bondingPower > 20) {
      return 'Through relics and care, we forge connections that transcend worlds.';
    } else {
      return 'Every Astra deserves freedom to choose their own path in The Cycle.';
    }
  }
  
  // Rename character
  void rename(String newName) {
    if (newName.isNotEmpty && newName.length <= 20) {
      name = newName;
    }
  }
  
  // Player's journal entries (story progression)
  List<String> journalEntries = [];
  
  void addJournalEntry(String entry) {
    journalEntries.add('Day ${journalEntries.length + 1}: $entry');
  }
  
  // Starting journal entry
  void initializeJournal() {
    if (journalEntries.isEmpty) {
      addJournalEntry('I begin my journey as a seeker of bonds. The Cycle calls to me, and I must answer. Elder Kaelen believes I have the power to heal the growing darkness.');
    }
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'experience': experience,
      'stats': stats,
      'journalEntries': journalEntries,
    };
  }
  
  factory PlayerCharacter.fromJson(Map<String, dynamic> json) {
    final character = PlayerCharacter(
      customName: json['name'] as String?,
      level: json['level'] as int? ?? 1,
      experience: json['experience'] as int? ?? 0,
      customStats: Map<String, int>.from(json['stats'] as Map? ?? {}),
    );
    
    if (json['journalEntries'] != null) {
      character.journalEntries = List<String>.from(json['journalEntries'] as List);
    }
    
    return character;
  }
}