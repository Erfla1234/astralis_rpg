import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../models/npc.dart';

class DialogueOverlay extends Component {
  final NPC npc;
  final VoidCallback onComplete;
  
  late RectangleComponent background;
  late RectangleComponent dialogueBox;
  late TextComponent npcNameText;
  late TextComponent dialogueText;
  late TextComponent continueText;
  late CircleComponent npcPortrait;
  
  int currentDialogueIndex = 0;
  bool isTyping = false;
  double typingProgress = 0;
  String currentText = '';
  double _animationTime = 0;
  
  DialogueOverlay({
    required this.npc,
    required this.onComplete,
  }) : super(priority: 150);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Semi-transparent background
    background = RectangleComponent(
      size: Vector2(800, 600),
      paint: Paint()..color = Colors.black.withOpacity(0.5),
    );
    add(background);
    
    // Main dialogue box
    dialogueBox = RectangleComponent(
      size: Vector2(700, 150),
      position: Vector2(50, 400),
      paint: Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF240046),
            Color(0xFF10002B),
          ],
        ).createShader(const Rect.fromLTWH(0, 0, 700, 150))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    add(dialogueBox);
    
    // Dialogue box border with animated glow
    final border = RectangleComponent(
      size: Vector2(700, 150),
      position: Vector2(50, 400),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = const Color(0xFF9D4EDD)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    add(border);
    
    // NPC portrait
    npcPortrait = CircleComponent(
      radius: 35,
      position: Vector2(100, 440),
      paint: Paint()
        ..color = _getNPCColor()
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      anchor: Anchor.center,
    );
    add(npcPortrait);
    
    // Portrait border
    final portraitBorder = CircleComponent(
      radius: 37,
      position: Vector2(100, 440),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white.withOpacity(0.8),
      anchor: Anchor.center,
    );
    add(portraitBorder);
    
    // NPC name
    npcNameText = TextComponent(
      text: npc.name,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color(0xFF9D4EDD),
              blurRadius: 8,
            ),
          ],
        ),
      ),
      position: Vector2(150, 415),
    );
    add(npcNameText);
    
    // Dialogue text
    dialogueText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 16,
          color: Colors.white.withOpacity(0.9),
          height: 1.4,
        ),
      ),
      position: Vector2(150, 445),
    );
    add(dialogueText);
    
    // Continue indicator
    continueText = TextComponent(
      text: 'Press SPACE or tap to continue...',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.6),
          fontStyle: FontStyle.italic,
        ),
      ),
      position: Vector2(580, 530),
      anchor: Anchor.centerRight,
    );
    add(continueText);
    
    // Entry animation
    dialogueBox.position.y = 600;
    dialogueBox.add(
      MoveToEffect(
        Vector2(50, 400),
        EffectController(duration: 0.5, curve: Curves.elasticOut),
        onComplete: () => _startCurrentDialogue(),
      ),
    );
    
    // Animate other elements
    npcPortrait.position.y = 600;
    npcPortrait.add(
      MoveToEffect(
        Vector2(100, 440),
        EffectController(duration: 0.6, curve: Curves.elasticOut),
      ),
    );
    
    portraitBorder.position.y = 600;
    portraitBorder.add(
      MoveToEffect(
        Vector2(100, 440),
        EffectController(duration: 0.6, curve: Curves.elasticOut),
      ),
    );
    
    // Add pulsing animation to continue text
    continueText.add(
      SequenceEffect([
        OpacityEffect.to(
          0.3,
          EffectController(duration: 1.0),
        ),
        OpacityEffect.to(
          0.9,
          EffectController(duration: 1.0),
        ),
      ], infinite: true),
    );
    
    // Add subtle floating animation to portrait
    npcPortrait.add(
      SequenceEffect([
        MoveByEffect(
          Vector2(0, -3),
          EffectController(duration: 2.0, curve: Curves.easeInOut),
        ),
        MoveByEffect(
          Vector2(0, 3),
          EffectController(duration: 2.0, curve: Curves.easeInOut),
        ),
      ], infinite: true),
    );
  }
  
  void _startCurrentDialogue() {
    if (currentDialogueIndex >= npc.dialogue.length) {
      _exitDialogue();
      return;
    }
    
    final fullText = npc.dialogue[currentDialogueIndex];
    currentText = '';
    typingProgress = 0;
    isTyping = true;
    
    // Start typing animation
    _animateText(fullText);
  }
  
  void _animateText(String fullText) {
    if (!isTyping || currentDialogueIndex >= npc.dialogue.length) return;
    
    const typingSpeed = 30.0; // characters per second
    
    add(
      TimerComponent(
        period: 1.0 / typingSpeed,
        repeat: true,
        onTick: () {
          if (typingProgress < fullText.length) {
            typingProgress++;
            currentText = fullText.substring(0, typingProgress.toInt());
            dialogueText.text = currentText;
            
            // Add subtle typing sound effect here if available
            _addTypingEffect();
          } else {
            isTyping = false;
            continueText.opacity = 1.0;
          }
        },
      ),
    );
  }
  
  void _addTypingEffect() {
    // Add subtle particle effect for typing
    if (math.Random().nextDouble() < 0.3) {
      final sparkle = ParticleSystemComponent(
        position: Vector2(
          150 + currentText.length * 8.0,
          460 + math.Random().nextDouble() * 10 - 5,
        ),
        particle: CircleParticle(
          radius: 1,
          paint: Paint()
            ..color = const Color(0xFF9D4EDD).withOpacity(0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
          lifespan: 0.5,
        ),
      );
      add(sparkle);
    }
  }
  
  void _nextDialogue() {
    if (isTyping) {
      // Skip typing animation
      isTyping = false;
      currentText = npc.dialogue[currentDialogueIndex];
      dialogueText.text = currentText;
      typingProgress = currentText.length.toDouble();
      continueText.opacity = 1.0;
      return;
    }
    
    currentDialogueIndex++;
    
    if (currentDialogueIndex >= npc.dialogue.length) {
      _exitDialogue();
    } else {
      // Animate text change
      dialogueText.add(
        SequenceEffect([
          OpacityEffect.to(
            0,
            EffectController(duration: 0.2),
          ),
          CallbackEffect(() => _startCurrentDialogue()),
          OpacityEffect.to(
            1,
            EffectController(duration: 0.2),
          ),
        ]),
      );
      
      continueText.opacity = 0.3;
    }
  }
  
  void _exitDialogue() {
    // Exit animation
    dialogueBox.add(
      MoveToEffect(
        Vector2(50, 600),
        EffectController(duration: 0.4, curve: Curves.easeIn),
      ),
    );
    
    npcPortrait.add(
      MoveToEffect(
        Vector2(100, 600),
        EffectController(duration: 0.4, curve: Curves.easeIn),
      ),
    );
    
    background.add(
      OpacityEffect.to(
        0,
        EffectController(duration: 0.5),
        onComplete: () {
          removeFromParent();
          onComplete();
        },
      ),
    );
  }
  
  Color _getNPCColor() {
    switch (npc.npcType) {
      case NPCType.elder:
        return const Color(0xFFD4AF37); // Gold
      case NPCType.merchant:
        return const Color(0xFF32CD32); // Lime green
      case NPCType.guard:
        return const Color(0xFF4169E1); // Royal blue
      case NPCType.scholar:
        return const Color(0xFF8A2BE2); // Blue violet
      case NPCType.trainer:
        return const Color(0xFFFF6347); // Tomato
      case NPCType.mystic:
        return const Color(0xFF9D4EDD); // Purple
      default:
        return const Color(0xFF708090); // Slate gray
    }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    _animationTime += dt;
  }
  
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.space ||
          event.logicalKey == LogicalKeyboardKey.enter) {
        _nextDialogue();
        return true;
      }
      
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _exitDialogue();
        return true;
      }
    }
    
    return false;
  }
  
  void onTapDown() {
    _nextDialogue();
  }
}

class DialogueChoice extends PositionComponent {
  final String text;
  final VoidCallback onSelected;
  late RectangleComponent background;
  late TextComponent choiceText;
  bool isHovered = false;
  
  DialogueChoice({
    required this.text,
    required this.onSelected,
    required Vector2 position,
  }) : super(position: position);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Background
    background = RectangleComponent(
      size: Vector2(300, 40),
      paint: Paint()
        ..color = const Color(0xFF5A189A).withOpacity(0.7)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      anchor: Anchor.centerLeft,
    );
    add(background);
    
    // Border
    final border = RectangleComponent(
      size: Vector2(300, 40),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withOpacity(0.5),
      anchor: Anchor.centerLeft,
    );
    add(border);
    
    // Choice text
    choiceText = TextComponent(
      text: text,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      position: Vector2(10, 20),
      anchor: Anchor.centerLeft,
    );
    add(choiceText);
  }
  
  void onTapDown() {
    // Animation feedback
    background.add(
      SequenceEffect([
        ColorEffect(
          const Color(0xFF7B2CBF),
          EffectController(duration: 0.1),
          opacityFrom: 0.7,
          opacityTo: 1.0,
        ),
        ColorEffect(
          const Color(0xFF5A189A),
          EffectController(duration: 0.1),
          opacityFrom: 1.0,
          opacityTo: 0.7,
        ),
      ]),
    );
    
    onSelected();
  }
  
  void setHovered(bool hovered) {
    if (hovered == isHovered) return;
    
    isHovered = hovered;
    
    if (hovered) {
      background.paint.color = const Color(0xFF7B2CBF).withOpacity(0.8);
      background.paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    } else {
      background.paint.color = const Color(0xFF5A189A).withOpacity(0.7);
      background.paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    }
  }
}