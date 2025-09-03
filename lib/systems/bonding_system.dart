import 'dart:math';
import 'package:flutter/material.dart';
import '../models/astral.dart';
import '../models/relic.dart';

enum BondingAction {
  showCare,
  battleBond, 
  relicEnergy,
  offer_food,
  play,
  show_respect,
  approach,
  meditate,
}

class BondingResult {
  final bool success;
  final double trustChange;
  final String message;
  final bool evolutionTriggered;
  final bool bondAchieved;
  
  BondingResult({
    required this.success,
    required this.trustChange,
    required this.message,
    this.evolutionTriggered = false,
    this.bondAchieved = false,
  });
}

class BondingSystem {
  static BondingResult attemptBonding(
    Astral astral, 
    BondingAction action, 
    Relic relic,
    {Map<String, dynamic>? playerContext}
  ) {
    if (astral.isBonded) {
      return BondingResult(
        success: false,
        trustChange: 0.0,
        message: '${astral.name} is already bonded with you.',
      );
    }
    
    double baseTrustChange = _getBaseTrustChange(action);
    double personalityMultiplier = _getPersonalityMultiplier(astral.personality, action);
    double relicMultiplier = relic.bondingMultiplier;
    
    // Calculate final trust change
    double finalTrustChange = baseTrustChange * personalityMultiplier * relicMultiplier;
    
    // Apply randomness (±10%)
    final random = Random();
    double randomFactor = 0.9 + (random.nextDouble() * 0.2);
    finalTrustChange *= randomFactor;
    
    // Special conditions
    if (astral.id == 'syn_phantom' && !relic.isCorrupted) {
      // Synthetic Astrals need special treatment
      return _handleSyntheticBonding(astral, action, relic);
    }
    
    // Apply trust change
    double oldTrust = astral.trustLevel;
    if (finalTrustChange > 0) {
      astral.increaseTrust(finalTrustChange);
    } else {
      astral.decreaseTrust(-finalTrustChange);
    }
    
    // Check for bonding threshold
    bool bondAchieved = !astral.isBonded && astral.canBond();
    if (bondAchieved) {
      astral.isBonded = true;
    }
    
    // Generate response message
    String message = _generateResponseMessage(astral, action, finalTrustChange, bondAchieved);
    
    return BondingResult(
      success: finalTrustChange > 0,
      trustChange: finalTrustChange,
      message: message,
      bondAchieved: bondAchieved,
    );
  }
  
  static double _getBaseTrustChange(BondingAction action) {
    switch (action) {
      case BondingAction.showCare:
        return 8.0;
      case BondingAction.battleBond:
        return 12.0; // Higher risk, higher reward
      case BondingAction.relicEnergy:
        return 15.0; // Premium action
      case BondingAction.offer_food:
        return 10.0;
      case BondingAction.play:
        return 6.0;
      case BondingAction.show_respect:
        return 7.0;
      case BondingAction.approach:
        return 3.0;
      case BondingAction.meditate:
        return 5.0;
    }
  }
  
  static double _getPersonalityMultiplier(AstralPersonality personality, BondingAction action) {
    switch (personality) {
      case AstralPersonality.gentle:
        switch (action) {
          case BondingAction.showCare:
            return 1.5;
          case BondingAction.approach:
            return 1.3;
          case BondingAction.battleBond:
            return 0.7; // Gentle types don't like battle bonding
          default:
            return 1.0;
        }
        
      case AstralPersonality.playful:
        switch (action) {
          case BondingAction.play:
            return 1.8;
          case BondingAction.battleBond:
            return 1.2;
          case BondingAction.meditate:
            return 0.6; // Too serious for playful types
          default:
            return 1.0;
        }
        
      case AstralPersonality.wise:
        switch (action) {
          case BondingAction.show_respect:
            return 1.6;
          case BondingAction.meditate:
            return 1.4;
          case BondingAction.relicEnergy:
            return 1.3;
          case BondingAction.play:
            return 0.8; // Wise types prefer serious approaches
          default:
            return 1.0;
        }
        
      case AstralPersonality.brave:
        switch (action) {
          case BondingAction.battleBond:
            return 1.7;
          case BondingAction.showCare:
            return 0.9;
          default:
            return 1.0;
        }
        
      case AstralPersonality.mysterious:
        switch (action) {
          case BondingAction.relicEnergy:
            return 1.4;
          case BondingAction.meditate:
            return 1.3;
          case BondingAction.approach:
            return 0.7; // Mysterious types don't like direct approaches
          default:
            return 1.0;
        }
        
      default:
        return 1.0;
    }
  }
  
  static BondingResult _handleSyntheticBonding(Astral astral, BondingAction action, Relic relic) {
    // Synthetic Astrals are corrupted and harder to bond with
    if (relic.type == RelicType.mythic) {
      // Only Mythic Relic can purify synthetic corruption
      astral.trustLevel = 0.0; // Reset to neutral
      astral.description = astral.description.replaceAll('corrupted', 'freed');
      astral.description = astral.description.replaceAll('enslaved', 'liberated');
      
      return BondingResult(
        success: true,
        trustChange: 50.0,
        message: 'The Spark of Creation purifies ${astral.name}! The synthetic corruption fades as natural essence returns.',
        bondAchieved: false, // Need to bond normally after purification
      );
    } else {
      return BondingResult(
        success: false,
        trustChange: 0.0,
        message: '${astral.name} struggles against synthetic control. You need a more powerful relic to break the corruption.',
      );
    }
  }
  
  static String _generateResponseMessage(Astral astral, BondingAction action, double trustChange, bool bondAchieved) {
    if (bondAchieved) {
      return '${astral.name} trusts you completely! A bond of mutual understanding has formed between you.';
    }
    
    if (trustChange > 10) {
      return '${astral.name} responds very positively to your approach. Trust grows stronger.';
    } else if (trustChange > 5) {
      return '${astral.name} seems pleased with your interaction. Trust increases.';
    } else if (trustChange > 0) {
      return '${astral.name} acknowledges your efforts. A small bond forms.';
    } else if (trustChange > -5) {
      return '${astral.name} seems uncertain about your approach.';
    } else {
      return '${astral.name} recoils from your action. Trust diminishes.';
    }
  }
  
  static List<BondingAction> getAvailableActions(Astral astral, List<Relic> playerRelics) {
    List<BondingAction> actions = [
      BondingAction.showCare,
      BondingAction.approach,
    ];
    
    // Add personality-specific actions
    switch (astral.personality) {
      case AstralPersonality.playful:
        actions.add(BondingAction.play);
        break;
      case AstralPersonality.wise:
        actions.add(BondingAction.show_respect);
        actions.add(BondingAction.meditate);
        break;
      case AstralPersonality.gentle:
        actions.add(BondingAction.offer_food);
        break;
      default:
        break;
    }
    
    // Add relic-dependent actions
    if (playerRelics.any((r) => r.type.index >= RelicType.strong.index)) {
      actions.add(BondingAction.relicEnergy);
    }
    
    actions.add(BondingAction.battleBond);
    
    return actions;
  }
  
  static String getActionDescription(BondingAction action) {
    switch (action) {
      case BondingAction.showCare:
        return 'Show Care'; // Official terminology
      case BondingAction.battleBond:
        return 'Battle Bond'; // Official terminology
      case BondingAction.relicEnergy:
        return 'Relic Energy'; // Official terminology
      case BondingAction.offer_food:
        return 'Offer food or treats';
      case BondingAction.play:
        return 'Engage in playful activities';
      case BondingAction.show_respect:
        return 'Show deep respect and reverence';
      case BondingAction.approach:
        return 'Approach calmly and peacefully';
      case BondingAction.meditate:
        return 'Meditate together in silence';
    }
  }
}