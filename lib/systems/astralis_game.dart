import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import '../components/player.dart';
import '../components/world_map.dart';
import '../components/npc_component.dart';
import '../components/astral_component.dart';
import '../systems/game_state.dart';

class AstralisGame extends FlameGame with TapDetector, KeyboardHandler, HasCollisionDetection {
  late Player player;
  late WorldMap worldMap;
  late GameState gameState;
  
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
    
    // Check for NPC interactions first
    for (final component in children) {
      if (component is NPCComponent) {
        final distance = component.position.distanceTo(tapPosition);
        if (distance < 60) { // Interaction range
          _showDialogue(component.interact());
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
  
  void _showDialogue(String message) {
    // For now, just print to console - later we'll add proper UI
    print('NPC says: $message');
    
    // TODO: Show actual dialogue UI overlay
  }
  
  void _showAstralInteraction(AstralComponent astralComponent) {
    print('Encountered ${astralComponent.astral.name}!');
    print('Trust Level: ${astralComponent.astral.trustLevel}');
    
    // TODO: Show bonding interface
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    gameState.update(dt);
  }
}