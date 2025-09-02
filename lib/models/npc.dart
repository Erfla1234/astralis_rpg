import 'package:flame/components.dart';

enum NPCRole {
  merchant,
  elder,
  guardian,
  villager,
  priest,
  rival,
  guide,
  scholar
}

class DialogueOption {
  final String text;
  final String response;
  final Map<String, dynamic>? consequences;
  
  DialogueOption({
    required this.text,
    required this.response,
    this.consequences,
  });
}

class DialogueTree {
  final String greeting;
  final List<DialogueOption> options;
  final String? questId;
  
  DialogueTree({
    required this.greeting,
    required this.options,
    this.questId,
  });
}

class NPC {
  final String id;
  final String name;
  final NPCRole role;
  final String description;
  final Vector2 position;
  final Map<String, DialogueTree> dialogueTrees;
  
  bool hasBeenMet = false;
  String currentDialogueState = 'default';
  Map<String, dynamic> personalFlags = {};
  List<String> inventory = [];
  
  NPC({
    required this.id,
    required this.name,
    required this.role,
    required this.description,
    required this.position,
    required this.dialogueTrees,
  });
  
  DialogueTree? getCurrentDialogue() {
    return dialogueTrees[currentDialogueState] ?? dialogueTrees['default'];
  }
  
  void setDialogueState(String state) {
    if (dialogueTrees.containsKey(state)) {
      currentDialogueState = state;
    }
  }
  
  void setFlag(String flag, dynamic value) {
    personalFlags[flag] = value;
  }
  
  dynamic getFlag(String flag) {
    return personalFlags[flag];
  }
  
  bool hasFlag(String flag) {
    return personalFlags.containsKey(flag);
  }
  
  String getGreeting() {
    if (!hasBeenMet) {
      hasBeenMet = true;
      return _getFirstMeetingGreeting();
    }
    return getCurrentDialogue()?.greeting ?? "Hello again, traveler.";
  }
  
  String _getFirstMeetingGreeting() {
    switch (role) {
      case NPCRole.elder:
        return "Greetings, young seeker. I am $name, Elder of this sacred realm. The Astrals have whispered of your arrival.";
      case NPCRole.merchant:
        return "Welcome, traveler! I'm $name, purveyor of rare goods and ancient artifacts. What brings you to my humble stall?";
      case NPCRole.guardian:
        return "Halt! I am $name, Guardian of the Sacred Grove. State your business in these protected lands.";
      case NPCRole.villager:
        return "Oh! A visitor! I'm $name. We don't see many travelers in these parts. Are you here about the strange lights?";
      case NPCRole.priest:
        return "May the light of the Astrals shine upon you. I am $name, keeper of the ancient rituals and sacred bonds.";
      case NPCRole.rival:
        return "Well, well... another would-be Astral bonding master. I'm $name, and I've already bonded with more Astrals than you'll ever see.";
      case NPCRole.guide:
        return "Traveler! Perfect timing. I'm $name, your guide to the mysteries of this realm. Stick with me and you'll learn the true ways of Astral bonding.";
      case NPCRole.scholar:
        return "Fascinating! A new subject for study. I am $name, researcher of Astral behaviors and bonding patterns. Your journey interests me greatly.";
    }
  }
  
  List<DialogueOption> getAvailableOptions() {
    var dialogue = getCurrentDialogue();
    if (dialogue == null) return [];
    
    return dialogue.options.where((option) {
      var consequences = option.consequences;
      if (consequences == null) return true;
      
      if (consequences.containsKey('requiresFlag')) {
        String flag = consequences['requiresFlag'];
        return hasFlag(flag);
      }
      
      if (consequences.containsKey('requiresNotFlag')) {
        String flag = consequences['requiresNotFlag'];
        return !hasFlag(flag);
      }
      
      return true;
    }).toList();
  }
  
  void processDialogueChoice(DialogueOption choice) {
    var consequences = choice.consequences;
    if (consequences == null) return;
    
    if (consequences.containsKey('setFlag')) {
      var flagData = consequences['setFlag'];
      setFlag(flagData['flag'], flagData['value']);
    }
    
    if (consequences.containsKey('changeState')) {
      setDialogueState(consequences['changeState']);
    }
    
    if (consequences.containsKey('giveItem')) {
      String item = consequences['giveItem'];
      inventory.add(item);
    }
  }
}