import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class DialogueOverlay extends RectangleComponent {
  final String message;
  final String speakerName;
  late TextComponent messageText;
  late TextComponent speakerText;
  
  DialogueOverlay({
    required this.message,
    required this.speakerName,
    required Vector2 gameSize,
  }) : super(
    size: Vector2(gameSize.x * 0.8, 120),
    position: Vector2(gameSize.x * 0.1, gameSize.y - 140),
    paint: Paint()..color = Colors.black.withOpacity(0.85),
  );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add border
    final border = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withOpacity(0.7),
    );
    add(border);
    
    // Speaker name
    speakerText = TextComponent(
      text: speakerName,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.cyan,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(16, 12),
    );
    add(speakerText);
    
    // Message text
    messageText = TextComponent(
      text: message,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      position: Vector2(16, 35),
    );
    add(messageText);
    
    // Click to continue indicator
    final continueText = TextComponent(
      text: 'Click anywhere to continue...',
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
      ),
      position: Vector2(size.x - 200, size.y - 20),
    );
    add(continueText);
  }
}