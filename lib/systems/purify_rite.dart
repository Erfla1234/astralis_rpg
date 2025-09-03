import '../models/astral.dart';
import '../models/relic.dart';

enum PurifyRiteStage {
  notUnlocked,
  available,
  ritual1Complete,
  ritual2Complete,
  masterRite
}

class PurifyRiteResult {
  final bool success;
  final String message;
  final bool astralPurified;
  final Astral? purifiedAstral;
  
  PurifyRiteResult({
    required this.success,
    required this.message,
    this.astralPurified = false,
    this.purifiedAstral,
  });
}

class PurifyRiteSystem {
  static PurifyRiteStage currentStage = PurifyRiteStage.notUnlocked;
  
  // Requirements: Radiant + Dream elements combined
  static bool canPerformRite(List<Relic> playerRelics, Astral syntheticAstral) {
    if (currentStage == PurifyRiteStage.notUnlocked) {
      return false;
    }
    
    if (!syntheticAstral.id.contains('syn_') && syntheticAstral.trustLevel >= -10) {
      return false; // Not a synthetic or already partially purified
    }
    
    // Need at least one Radiant-compatible and one Dream-compatible relic
    bool hasRadiantRelic = playerRelics.any((relic) => 
      relic.compatibleAstralTypes.contains('radiant') || relic.type == RelicType.mythic);
    bool hasDreamRelic = playerRelics.any((relic) => 
      relic.compatibleAstralTypes.contains('dream') || relic.type == RelicType.mythic);
    
    return hasRadiantRelic && hasDreamRelic;
  }
  
  static PurifyRiteResult attemptPurifyRite(Astral syntheticAstral, List<Relic> usedRelics) {
    if (!canPerformRite(usedRelics, syntheticAstral)) {
      return PurifyRiteResult(
        success: false,
        message: 'You lack the required Radiant and Dream relic combination to perform the Purify Rite.',
      );
    }
    
    // Check if it's actually a synthetic
    if (!syntheticAstral.id.contains('syn_')) {
      return PurifyRiteResult(
        success: false,
        message: '${syntheticAstral.name} is not bound by synthetic corruption.',
      );
    }
    
    // Calculate success rate based on relic power and player level
    double successRate = 0.7; // Base 70% success
    
    // Improve odds with better relics
    for (var relic in usedRelics) {
      if (relic.type == RelicType.mythic) {
        successRate = 1.0; // Mythic relic guarantees success
        break;
      } else if (relic.type == RelicType.legendary) {
        successRate += 0.2;
      } else if (relic.type == RelicType.ancient) {
        successRate += 0.1;
      }
    }
    
    successRate = successRate.clamp(0.0, 1.0);
    
    // Simulate success/failure
    final random = DateTime.now().millisecondsSinceEpoch % 100;
    bool success = (random / 100.0) < successRate;
    
    if (success) {
      return _performSuccessfulPurification(syntheticAstral);
    } else {
      return PurifyRiteResult(
        success: false,
        message: 'The synthetic corruption resists your efforts. ${syntheticAstral.name} remains bound to the machine. Try again with stronger relics.',
      );
    }
  }
  
  static PurifyRiteResult _performSuccessfulPurification(Astral syntheticAstral) {
    // Create purified version
    final purifiedId = syntheticAstral.id.replaceFirst('syn_', '');
    
    // Reset to natural Astral state
    syntheticAstral.trustLevel = 0.0; // Neutral trust, can now bond normally
    syntheticAstral.isBonded = false; // No longer forced-bonded
    
    // Update description to reflect freedom
    final originalDescription = syntheticAstral.description
        .replaceAll('corrupted', 'freed')
        .replaceAll('enslaved', 'liberated')
        .replaceAll('synthetic form', 'natural form')
        .replaceAll('SYN\'s synthetic relics', 'their original essence');
    
    // Restore natural abilities (remove synthetic ones)
    syntheticAstral.abilities.removeWhere((ability) => 
        ability.contains('Data') || 
        ability.contains('System') || 
        ability.contains('Error') ||
        ability.contains('Synthetic'));
    
    // Add back natural abilities based on original type
    switch (purifiedId) {
      case 'phantom':
        syntheticAstral.abilities.addAll(['Phase Shift', 'Natural Bond', 'Grove Blessing']);
        break;
      case 'wraith':
        syntheticAstral.abilities.addAll(['Shadow Dance', 'Memory Echo', 'Spirit Bond']);
        break;
      default:
        syntheticAstral.abilities.addAll(['Natural Essence', 'Cycle Connection', 'Pure Bond']);
    }
    
    // Restore natural behaviors
    syntheticAstral.behaviors.clear();
    syntheticAstral.behaviors.addAll([
      'glows_with_natural_light',
      'responds_to_care',
      'seeks_companionship'
    ]);
    
    // Add natural preferences back
    syntheticAstral.preferences.addAll([
      'gentle_approach',
      'understanding',
      'freedom'
    ]);
    
    return PurifyRiteResult(
      success: true,
      message: 'The Purify Rite succeeds! ${syntheticAstral.name} is freed from synthetic corruption. '
               'The machine bonds dissolve, and natural essence flows again. They can now choose to Bond freely.',
      astralPurified: true,
      purifiedAstral: syntheticAstral,
    );
  }
  
  static void unlockPurifyRite(String source) {
    if (currentStage == PurifyRiteStage.notUnlocked) {
      currentStage = PurifyRiteStage.available;
    }
  }
  
  static String getRiteDescription() {
    return '''
The Purify Rite combines the healing power of Radiant essence with the wisdom of Dream essence to break synthetic bonds.

Requirements:
• One Radiant-compatible relic
• One Dream-compatible relic  
• A synthetic Astral to purify

Process:
• Channel both essences simultaneously
• Target the synthetic corruption directly
• Free the Astral to rejoin The Cycle

Warning: Failure may strengthen the corruption. Prepare carefully.
    ''';
  }
  
  static List<String> getRiteInstructions() {
    return [
      'Hold your Radiant relic in your right hand',
      'Hold your Dream relic in your left hand',
      'Focus on The Cycle\'s natural flow',
      'Channel both essences toward the synthetic bonds',
      'Speak the words: "By Starlight\'s grace, return to The Cycle"',
      'Maintain focus until the corruption breaks',
    ];
  }
  
  static Map<String, String> getSyntheticIdentifications() {
    return {
      'visual_cues': 'Metal enhancements, red-glowing runes, red eyes',
      'behavior': 'Glitches periodically, emits static, struggles against control',
      'stat_bonuses': '+10% Attack/Defense/Speed and +10% HP (removed after purification)',
      'weakness': 'Radiant is super-effective, Venom is not-very-effective',
    };
  }
  
  static bool isSynthetic(Astral astral) {
    return astral.id.contains('syn_') || 
           astral.trustLevel < -25 ||
           astral.behaviors.any((behavior) => 
               behavior.contains('glitch') || 
               behavior.contains('static') || 
               behavior.contains('control'));
  }
}