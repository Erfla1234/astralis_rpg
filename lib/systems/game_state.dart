import '../models/astral.dart';
import '../models/npc.dart';
import '../models/quest.dart';

class GameState {
  static final GameState _instance = GameState._internal();
  factory GameState() => _instance;
  GameState._internal();

  final List<Astral> bondedAstrals = [];
  final List<Astral> discoveredAstrals = [];
  final List<NPC> npcs = [];
  final List<Quest> activeQuests = [];
  final List<Quest> completedQuests = [];
  
  Map<String, dynamic> playerStats = {
    'level': 1,
    'experience': 0,
    'trustPoints': 0,
    'sacredRelics': 0,
  };
  
  Map<String, bool> worldFlags = {};
  Map<String, int> itemInventory = {};
  
  void update(double dt) {
    for (var quest in activeQuests) {
      quest.update(dt);
    }
  }
  
  void addBondedAstral(Astral astral) {
    if (!bondedAstrals.contains(astral)) {
      bondedAstrals.add(astral);
      playerStats['trustPoints'] = (playerStats['trustPoints'] as int) + 10;
    }
  }
  
  void discoverAstral(Astral astral) {
    if (!discoveredAstrals.contains(astral)) {
      discoveredAstrals.add(astral);
    }
  }
  
  void completeQuest(Quest quest) {
    if (activeQuests.contains(quest)) {
      activeQuests.remove(quest);
      completedQuests.add(quest);
      playerStats['experience'] = (playerStats['experience'] as int) + quest.experienceReward;
      playerStats['sacredRelics'] = (playerStats['sacredRelics'] as int) + quest.relicReward;
    }
  }
  
  void setWorldFlag(String flag, bool value) {
    worldFlags[flag] = value;
  }
  
  bool getWorldFlag(String flag) {
    return worldFlags[flag] ?? false;
  }
  
  void addItem(String item, int quantity) {
    itemInventory[item] = (itemInventory[item] ?? 0) + quantity;
  }
  
  int getItemQuantity(String item) {
    return itemInventory[item] ?? 0;
  }
}