import 'package:flame/components.dart';

enum AstralType {
  luminous,
  shadow,
  crystal,
  flame,
  water,
  earth,
  wind,
  electric,
  ice,
  nature
}

enum AstralPersonality {
  gentle,
  brave,
  playful,
  wise,
  mysterious,
  protective,
  energetic,
  calm,
  curious,
  noble
}

class Astral {
  final String id;
  final String name;
  final AstralType type;
  final AstralPersonality personality;
  final String description;
  final Vector2 position;
  
  double trustLevel = 0.0;
  bool isBonded = false;
  bool isDiscovered = false;
  
  Map<String, int> stats = {
    'health': 100,
    'energy': 100,
    'strength': 10,
    'agility': 10,
    'wisdom': 10,
    'empathy': 10,
  };
  
  List<String> abilities = [];
  List<String> preferences = [];
  List<String> behaviors = [];
  
  Astral({
    required this.id,
    required this.name,
    required this.type,
    required this.personality,
    required this.description,
    required this.position,
    this.trustLevel = 0.0,
  });
  
  void increaseTrust(double amount) {
    trustLevel = (trustLevel + amount).clamp(0.0, 100.0);
    if (trustLevel >= 80.0 && !isBonded) {
      isBonded = true;
    }
  }
  
  void decreaseTrust(double amount) {
    trustLevel = (trustLevel - amount).clamp(0.0, 100.0);
    if (trustLevel < 80.0 && isBonded) {
      isBonded = false;
    }
  }
  
  bool canBond() {
    return trustLevel >= 80.0 && isDiscovered;
  }
  
  String getInteractionResponse(String interactionType) {
    switch (personality) {
      case AstralPersonality.gentle:
        return _getGentleResponse(interactionType);
      case AstralPersonality.brave:
        return _getBraveResponse(interactionType);
      case AstralPersonality.playful:
        return _getPlayfulResponse(interactionType);
      case AstralPersonality.wise:
        return _getWiseResponse(interactionType);
      case AstralPersonality.mysterious:
        return _getMysteriousResponse(interactionType);
      default:
        return "The Astral observes you quietly.";
    }
  }
  
  String _getGentleResponse(String interactionType) {
    switch (interactionType) {
      case 'approach':
        return "$name looks at you with kind eyes, sensing your peaceful intentions.";
      case 'offer_food':
        return "$name gracefully accepts your offering, its trust in you growing.";
      case 'harsh':
        return "$name recoils, its gentle nature hurt by your aggressive approach.";
      default:
        return "$name emanates a calming presence.";
    }
  }
  
  String _getBraveResponse(String interactionType) {
    switch (interactionType) {
      case 'approach':
        return "$name stands tall, evaluating your courage and determination.";
      case 'show_strength':
        return "$name respects your display of strength and nods approvingly.";
      case 'cowardly':
        return "$name loses interest, preferring companions who show bravery.";
      default:
        return "$name radiates confidence and strength.";
    }
  }
  
  String _getPlayfulResponse(String interactionType) {
    switch (interactionType) {
      case 'approach':
        return "$name bounces excitedly, eager to see what you might do together.";
      case 'play':
        return "$name joins in your playful gesture, its joy infectious.";
      case 'serious':
        return "$name seems bored by your overly serious demeanor.";
      default:
        return "$name's eyes sparkle with mischief and fun.";
    }
  }
  
  String _getWiseResponse(String interactionType) {
    switch (interactionType) {
      case 'approach':
        return "$name studies you thoughtfully, as if seeing into your very soul.";
      case 'ask_wisdom':
        return "$name shares ancient knowledge, deepening your connection.";
      case 'impatient':
        return "$name remains still, teaching you the value of patience.";
      default:
        return "$name emanates ancient wisdom and deep understanding.";
    }
  }
  
  String _getMysteriousResponse(String interactionType) {
    switch (interactionType) {
      case 'approach':
        return "$name watches you with enigmatic eyes, its intentions unclear.";
      case 'puzzle':
        return "$name seems intrigued by your attempt to understand its mystery.";
      case 'direct':
        return "$name fades slightly, preferring subtlety to direct approaches.";
      default:
        return "$name exists in a realm between reality and dreams.";
    }
  }
}