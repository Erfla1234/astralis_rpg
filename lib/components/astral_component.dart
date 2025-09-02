import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../models/astral.dart';
import '../systems/game_state.dart';

class AstralComponent extends RectangleComponent with CollisionCallbacks {
  final Astral astral;
  late GameState _gameState;
  
  double _glowIntensity = 0.5;
  double _glowDirection = 1.0;
  bool _isPlayerNearby = false;
  
  AstralComponent({
    required this.astral,
  }) : super(
    position: astral.position,
    size: Vector2(24, 24),
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    _gameState = GameState();
    add(RectangleHitbox());
    
    _updateAppearance();
  }
  
  void _updateAppearance() {
    Color baseColor;
    
    switch (astral.type) {
      case AstralType.luminous:
        baseColor = const Color(0xFFFFE135);
        break;
      case AstralType.shadow:
        baseColor = const Color(0xFF4B0082);
        break;
      case AstralType.crystal:
        baseColor = const Color(0xFF00CED1);
        break;
      case AstralType.flame:
        baseColor = const Color(0xFFFF4500);
        break;
      case AstralType.water:
        baseColor = const Color(0xFF0077BE);
        break;
      case AstralType.earth:
        baseColor = const Color(0xFF8B4513);
        break;
      case AstralType.wind:
        baseColor = const Color(0xFF87CEEB);
        break;
      case AstralType.electric:
        baseColor = const Color(0xFFFFFF00);
        break;
      case AstralType.ice:
        baseColor = const Color(0xFF00FFFF);
        break;
      case AstralType.nature:
        baseColor = const Color(0xFF228B22);
        break;
    }
    
    // Adjust color based on trust level
    final trustMultiplier = astral.trustLevel / 100.0;
    final adjustedColor = Color.lerp(
      baseColor.withOpacity(0.5),
      baseColor,
      trustMultiplier,
    )!;
    
    paint = Paint()..color = adjustedColor;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Animate glow effect
    _glowIntensity += _glowDirection * dt * 2.0;
    if (_glowIntensity > 1.0) {
      _glowIntensity = 1.0;
      _glowDirection = -1.0;
    } else if (_glowIntensity < 0.3) {
      _glowIntensity = 0.3;
      _glowDirection = 1.0;
    }
    
    _updateAppearance();
    
    // Behavioral animations based on personality
    _updateBehavior(dt);
  }
  
  void _updateBehavior(double dt) {
    switch (astral.personality) {
      case AstralPersonality.playful:
        // Slight bouncing motion
        final bounce = (DateTime.now().millisecondsSinceEpoch / 1000.0) * 3.0;
        position.y = astral.position.y + (sin(bounce) * 2.0);
        break;
      case AstralPersonality.mysterious:
        // Subtle fading in and out
        final fade = (DateTime.now().millisecondsSinceEpoch / 2000.0) * 2.0;
        final opacity = 0.7 + (sin(fade) * 0.3);
        paint.color = paint.color.withOpacity(opacity);
        break;
      case AstralPersonality.gentle:
        // Soft pulsing
        final pulse = (DateTime.now().millisecondsSinceEpoch / 1500.0) * 2.0;
        final scale = 1.0 + (sin(pulse) * 0.1);
        size = Vector2(24 * scale, 24 * scale);
        break;
      default:
        break;
    }
  }
  
  String interact(String interactionType) {
    astral.isDiscovered = true;
    
    // Update trust based on interaction type and personality
    _updateTrustFromInteraction(interactionType);
    
    return astral.getInteractionResponse(interactionType);
  }
  
  void _updateTrustFromInteraction(String interactionType) {
    double trustChange = 0.0;
    
    // Base trust changes for different interaction types
    switch (interactionType) {
      case 'approach':
        trustChange = astral.personality == AstralPersonality.gentle ? 5.0 : 2.0;
        break;
      case 'offer_food':
        trustChange = 8.0;
        break;
      case 'play':
        trustChange = astral.personality == AstralPersonality.playful ? 10.0 : 3.0;
        break;
      case 'show_respect':
        trustChange = astral.personality == AstralPersonality.wise ? 8.0 : 4.0;
        break;
      case 'harsh':
        trustChange = -15.0;
        break;
      case 'impatient':
        trustChange = -5.0;
        break;
      case 'force':
        trustChange = -25.0;
        break;
      default:
        trustChange = 1.0;
    }
    
    // Apply personality-specific modifiers
    if (astral.personality == AstralPersonality.brave && interactionType == 'show_strength') {
      trustChange += 5.0;
    } else if (astral.personality == AstralPersonality.mysterious && interactionType == 'puzzle') {
      trustChange += 7.0;
    }
    
    if (trustChange > 0) {
      astral.increaseTrust(trustChange);
    } else {
      astral.decreaseTrust(-trustChange);
    }
    
    // Check for bonding
    if (astral.canBond() && !astral.isBonded) {
      astral.isBonded = true;
      _gameState.addBondedAstral(astral);
    }
  }
  
  void setPlayerNearby(bool nearby) {
    _isPlayerNearby = nearby;
  }
  
  bool canInteract() {
    return astral.isDiscovered;
  }
}