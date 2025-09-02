import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flutter/services.dart';
import '../components/player.dart';
import '../components/world_map.dart';
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
    player.handleInteraction(info.eventPosition.global);
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    gameState.update(dt);
  }
}