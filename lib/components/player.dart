import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/services.dart';
import '../systems/game_state.dart';

class Player extends SpriteAnimationComponent with CollisionCallbacks {
  static const double moveSpeed = 100.0;
  late Vector2 _velocity;
  late GameState _gameState;
  
  bool isMoving = false;
  String currentDirection = 'down';
  
  Player({required Vector2 position}) : super(position: position, size: Vector2(32, 32));
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    _velocity = Vector2.zero();
    _gameState = GameState();
    
    add(RectangleHitbox());
    
    await _loadAnimations();
  }
  
  Future<void> _loadAnimations() async {
    // For now, create a simple colored rectangle as placeholder
    // TODO: Load actual sprite animations when assets are available
  }
  
  void updateMovement(Set<LogicalKeyboardKey> keysPressed) {
    _velocity.setZero();
    isMoving = false;
    
    if (keysPressed.contains(LogicalKeyboardKey.keyW) || 
        keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      _velocity.y -= moveSpeed;
      currentDirection = 'up';
      isMoving = true;
    }
    
    if (keysPressed.contains(LogicalKeyboardKey.keyS) || 
        keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      _velocity.y += moveSpeed;
      currentDirection = 'down';
      isMoving = true;
    }
    
    if (keysPressed.contains(LogicalKeyboardKey.keyA) || 
        keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      _velocity.x -= moveSpeed;
      currentDirection = 'left';
      isMoving = true;
    }
    
    if (keysPressed.contains(LogicalKeyboardKey.keyD) || 
        keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      _velocity.x += moveSpeed;
      currentDirection = 'right';
      isMoving = true;
    }
    
    if (_velocity.length > 0) {
      _velocity.normalize();
      _velocity.scale(moveSpeed);
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (_velocity.length > 0) {
      position.add(_velocity * dt);
    }
  }
  
  void handleInteraction(Vector2 tapPosition) {
    final distance = position.distanceTo(tapPosition);
    if (distance < 50) {
    }
  }
  
  Vector2 get centerPosition => position + size / 2;
}