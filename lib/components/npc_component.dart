import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../models/npc.dart';

class NPCComponent extends RectangleComponent with CollisionCallbacks {
  final NPC npc;
  late TextComponent nameLabel;
  
  NPCComponent({required this.npc}) 
    : super(
        position: npc.position,
        size: Vector2(40, 40),
      );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    add(RectangleHitbox());
    
    // Set color based on NPC role
    paint = Paint()..color = _getRoleColor();
    
    // Add name label above NPC
    nameLabel = TextComponent(
      text: npc.name,
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, -10),
    );
    add(nameLabel);
    
    // Add role indicator
    final roleIndicator = TextComponent(
      text: _getRoleSymbol(),
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2),
    );
    add(roleIndicator);
  }
  
  Color _getRoleColor() {
    switch (npc.role) {
      case NPCRole.elder:
        return const Color(0xFF9B59B6); // Purple for wisdom
      case NPCRole.rival:
        return const Color(0xFF3498DB); // Blue for rival
      case NPCRole.scholar:
        return const Color(0xFF95A5A6); // Gray for relic keeper
      case NPCRole.merchant:
        return const Color(0xFFF39C12); // Orange for merchant
      case NPCRole.guardian:
        return const Color(0xFF27AE60); // Green for guardian
      case NPCRole.priest:
        return const Color(0xFFE74C3C); // Red for priest
      case NPCRole.villager:
        return const Color(0xFF34495E); // Dark blue for villager
      case NPCRole.guide:
        return const Color(0xFF16A085); // Teal for guide
    }
  }
  
  String _getRoleSymbol() {
    switch (npc.role) {
      case NPCRole.elder:
        return '🧙';
      case NPCRole.rival:
        return '⚔️';
      case NPCRole.scholar:
        return '🔨';
      case NPCRole.merchant:
        return '💰';
      case NPCRole.guardian:
        return '🛡️';
      case NPCRole.priest:
        return '⭐';
      case NPCRole.villager:
        return '👤';
      case NPCRole.guide:
        return '🗺️';
    }
  }
  
  String interact() {
    final dialogue = npc.getCurrentDialogue();
    if (dialogue != null) {
      return dialogue.greeting;
    }
    return '${npc.name} has nothing to say right now.';
  }
  
  bool canInteract() {
    return true;
  }
}