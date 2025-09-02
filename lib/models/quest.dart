enum QuestType {
  main,
  side,
  bonding,
  exploration,
  collection
}

enum QuestStatus {
  inactive,
  active,
  completed,
  failed
}

class QuestObjective {
  final String id;
  final String description;
  final Map<String, dynamic> requirements;
  bool isCompleted = false;
  
  QuestObjective({
    required this.id,
    required this.description,
    required this.requirements,
  });
  
  bool checkCompletion(Map<String, dynamic> gameState) {
    for (var entry in requirements.entries) {
      switch (entry.key) {
        case 'bondAstral':
          var requiredAstral = entry.value as String;
          var bondedAstrals = gameState['bondedAstrals'] as List<String>? ?? [];
          if (!bondedAstrals.contains(requiredAstral)) return false;
          break;
          
        case 'talkToNPC':
          var requiredNPC = entry.value as String;
          var talkedToNPCs = gameState['talkedToNPCs'] as List<String>? ?? [];
          if (!talkedToNPCs.contains(requiredNPC)) return false;
          break;
          
        case 'visitLocation':
          var requiredLocation = entry.value as String;
          var visitedLocations = gameState['visitedLocations'] as List<String>? ?? [];
          if (!visitedLocations.contains(requiredLocation)) return false;
          break;
          
        case 'collectItem':
          var itemData = entry.value as Map<String, dynamic>;
          var itemName = itemData['item'] as String;
          var requiredQuantity = itemData['quantity'] as int;
          var inventory = gameState['inventory'] as Map<String, int>? ?? {};
          if ((inventory[itemName] ?? 0) < requiredQuantity) return false;
          break;
          
        case 'flag':
          var flagData = entry.value as Map<String, dynamic>;
          var flagName = flagData['name'] as String;
          var requiredValue = flagData['value'];
          var worldFlags = gameState['worldFlags'] as Map<String, dynamic>? ?? {};
          if (worldFlags[flagName] != requiredValue) return false;
          break;
      }
    }
    
    isCompleted = true;
    return true;
  }
}

class Quest {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final List<QuestObjective> objectives;
  final int experienceReward;
  final int relicReward;
  final Map<String, int> itemRewards;
  final List<String> prerequisiteQuests;
  
  QuestStatus status = QuestStatus.inactive;
  DateTime? startTime;
  DateTime? completionTime;
  
  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.objectives,
    this.experienceReward = 0,
    this.relicReward = 0,
    this.itemRewards = const {},
    this.prerequisiteQuests = const [],
  });
  
  void activate() {
    if (status == QuestStatus.inactive) {
      status = QuestStatus.active;
      startTime = DateTime.now();
    }
  }
  
  void complete() {
    if (status == QuestStatus.active && allObjectivesCompleted()) {
      status = QuestStatus.completed;
      completionTime = DateTime.now();
    }
  }
  
  void fail() {
    if (status == QuestStatus.active) {
      status = QuestStatus.failed;
    }
  }
  
  bool allObjectivesCompleted() {
    return objectives.every((objective) => objective.isCompleted);
  }
  
  double getProgress() {
    if (objectives.isEmpty) return 0.0;
    int completedCount = objectives.where((obj) => obj.isCompleted).length;
    return completedCount / objectives.length;
  }
  
  List<QuestObjective> getActiveObjectives() {
    return objectives.where((obj) => !obj.isCompleted).toList();
  }
  
  void update(double dt) {
    if (status != QuestStatus.active) return;
    
    if (allObjectivesCompleted()) {
      complete();
    }
  }
  
  bool canStart(Map<String, dynamic> gameState) {
    if (status != QuestStatus.inactive) return false;
    
    var completedQuests = gameState['completedQuests'] as List<String>? ?? [];
    for (var prerequisite in prerequisiteQuests) {
      if (!completedQuests.contains(prerequisite)) {
        return false;
      }
    }
    
    return true;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'status': status.name,
      'progress': getProgress(),
      'objectives': objectives.map((obj) => {
        'id': obj.id,
        'description': obj.description,
        'isCompleted': obj.isCompleted,
      }).toList(),
    };
  }
}