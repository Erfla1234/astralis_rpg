import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import '../components/player.dart';
import '../components/world_map.dart';
import '../components/npc_component.dart';
import '../components/astral_component.dart';
import '../components/ui/dialogue_overlay.dart';
import '../systems/game_state.dart';

class AstralisGame extends FlameGame with TapDetector, KeyboardHandler, HasCollisionDetection {
  late Player player;
  late WorldMap worldMap;
  late GameState gameState;
  DialogueOverlay? currentDialogue;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    gameState = GameState();
    
    worldMap = WorldMap();
    await add(worldMap);
    
    player = Player(position: Vector2(100, 100));
    await add(player);
    
    camera.follow(player);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      player.updateMovement(keysPressed);
    } else if (event is KeyUpEvent) {
      player.updateMovement(keysPressed);
    }
    return true;
  }

  @override
  void onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.global;
    
    // If dialogue is showing, close it on tap
    if (currentDialogue != null) {
      remove(currentDialogue!);
      currentDialogue = null;
      return;
    }
    
    // Check for NPC interactions first
    for (final component in children) {
      if (component is NPCComponent) {
        final distance = component.position.distanceTo(tapPosition);
        if (distance < 60) { // Interaction range
          _showDialogue(component.interact(), component.npc.name);
          return;
        }
      }
      
      if (component is AstralComponent) {
        final distance = component.position.distanceTo(tapPosition);
        if (distance < 50) { // Interaction range
          _showAstralInteraction(component);
          return;
        }
      }
    }
    
    // If no specific interaction, just move towards tap
    player.handleInteraction(tapPosition);
  }
  
  void _showDialogue(String message, String speakerName) {
    // Remove any existing dialogue
    if (currentDialogue != null) {
      remove(currentDialogue!);
    }
    
    // Create new dialogue overlay
    currentDialogue = DialogueOverlay(
      message: message,
      speakerName: speakerName,
      gameSize: size,
    );
    
    add(currentDialogue!);
    print('$speakerName says: $message');
  }
  
  void _showAstralInteraction(AstralComponent astralComponent) {
    final astral = astralComponent.astral;
    String message = astral.getInteractionResponse('approach');
    
    if (astral.isBonded) {
      message = '${astral.name} is your loyal companion. Trust: ${astral.trustLevel.toInt()}%';
    } else if (astral.canBond()) {
      message = '${astral.name} trusts you deeply! You could form a bond. Trust: ${astral.trustLevel.toInt()}%';
    } else {
      message = '${astral.name} ${astral.getInteractionResponse('approach')} Trust: ${astral.trustLevel.toInt()}%';
    }
    
    _showDialogue(message, astral.name);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    gameState.update(dt);
  }
}