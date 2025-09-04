import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../systems/tiled_world_manager.dart';

class MapTravelOverlay extends Component {
  final TiledWorldManager worldManager;
  final Function(String mapName) onMapSelected;
  final VoidCallback onClose;
  
  late RectangleComponent background;
  late RectangleComponent panel;
  late TextComponent titleText;
  late List<MapTravelButton> mapButtons;
  
  MapTravelOverlay({
    required this.worldManager,
    required this.onMapSelected,
    required this.onClose,
  }) : super(priority: 300);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Semi-transparent background
    background = RectangleComponent(
      size: Vector2(800, 600),
      paint: Paint()..color = Colors.black.withOpacity(0.8),
    );
    add(background);
    
    // Main travel panel
    panel = RectangleComponent(
      size: Vector2(700, 500),
      position: Vector2(50, 50),
      paint: Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF240046),
            Color(0xFF10002B),
            Color(0xFF5A189A),
          ],
        ).createShader(const Rect.fromLTWH(0, 0, 700, 500))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    add(panel);
    
    // Panel border with glow
    final border = RectangleComponent(
      size: Vector2(700, 500),
      position: Vector2(50, 50),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = const Color(0xFF9D4EDD)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    add(border);
    
    // Title
    titleText = TextComponent(
      text: 'World Map - Choose Your Destination',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: Color(0xFF9D4EDD),
              blurRadius: 15,
            ),
          ],
        ),
      ),
      position: Vector2(400, 90),
      anchor: Anchor.center,
    );
    add(titleText);
    
    // Current location info
    final currentMapData = worldManager.getCurrentMapData();
    if (currentMapData != null) {
      final currentLocationText = TextComponent(
        text: 'Current: ${currentMapData.config.displayName}',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.8),
            fontStyle: FontStyle.italic,
          ),
        ),
        position: Vector2(400, 120),
        anchor: Anchor.center,
      );
      add(currentLocationText);
    }
    
    // Progress info
    final progress = worldManager.getStorylineProgress();
    final progressText = TextComponent(
      text: 'Chapter ${progress.currentChapter} • ${progress.explorationPercentage.toInt()}% Explored',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 14,
          color: const Color(0xFFFFD700),
        ),
      ),
      position: Vector2(400, 145),
      anchor: Anchor.center,
    );
    add(progressText);
    
    // Create map buttons
    await _createMapButtons();
    
    // Entry animation
    panel.add(
      ScaleEffect.to(
        Vector2.all(1.0),
        EffectController(duration: 0.5, curve: Curves.elasticOut),
      ),
    );
    
    // Instructions
    final instructionText = TextComponent(
      text: 'Select a destination to travel • ESC to close',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(0.6),
        ),
      ),
      position: Vector2(400, 520),
      anchor: Anchor.center,
    );
    add(instructionText);
  }
  
  Future<void> _createMapButtons() async {
    mapButtons = [];
    
    final availableDestinations = worldManager.getAvailableDestinations();
    final progress = worldManager.getStorylineProgress();
    
    // Get all storyline maps for display
    final allMaps = TiledWorldManager.storylineMapConfigs;
    
    int buttonIndex = 0;
    int row = 0;
    int col = 0;
    const maxCols = 3;
    
    for (final entry in allMaps.entries) {
      final mapName = entry.key;
      final config = entry.value;
      
      // Check if map is available
      final isAvailable = availableDestinations.contains(mapName);
      final isCurrentMap = worldManager.currentMapName == mapName;
      final isUnlocked = worldManager.canTravelTo(mapName) || isCurrentMap;
      
      final buttonPos = Vector2(
        120 + (col * 200.0),
        200 + (row * 100.0),
      );
      
      final button = MapTravelButton(
        mapName: mapName,
        config: config,
        position: buttonPos,
        isAvailable: isAvailable,
        isCurrent: isCurrentMap,
        isUnlocked: isUnlocked,
        onPressed: () => _selectMap(mapName),
      );
      
      mapButtons.add(button);
      add(button);
      
      col++;
      if (col >= maxCols) {
        col = 0;
        row++;
      }
      
      buttonIndex++;
      if (buttonIndex >= 9) break; // Limit display to prevent overflow
    }
  }
  
  void _selectMap(String mapName) {
    if (!worldManager.canTravelTo(mapName)) {
      // Show locked message
      _showLockedMessage(mapName);
      return;
    }
    
    if (mapName == worldManager.currentMapName) {
      // Already at this location
      return;
    }
    
    // Close overlay and travel
    _closeOverlay(() => onMapSelected(mapName));
  }
  
  void _showLockedMessage(String mapName) {
    final config = TiledWorldManager.storylineMapConfigs[mapName];
    if (config == null) return;
    
    final message = TextComponent(
      text: 'Requires Level ${config.requiredLevel}\nComplete Chapter ${config.storyChapter - 1}',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 14,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(400, 480),
      anchor: Anchor.center,
    );
    
    add(message);
    
    // Remove message after delay
    message.add(
      SequenceEffect([
        OpacityEffect.to(1.0, EffectController(duration: 0.1)),
        OpacityEffect.to(1.0, EffectController(duration: 2.0)),
        OpacityEffect.to(0.0, EffectController(duration: 0.5)),
        RemoveEffect(),
      ]),
    );
  }
  
  void _closeOverlay([VoidCallback? callback]) {
    // Exit animation
    panel.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(0.8),
          EffectController(duration: 0.3),
        ),
        OpacityEffect.to(
          0,
          EffectController(duration: 0.2),
        ),
      ], onComplete: () {
        removeFromParent();
        if (callback != null) callback();
        onClose();
      }),
    );
    
    background.add(
      OpacityEffect.to(
        0,
        EffectController(duration: 0.5),
      ),
    );
  }
  
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _closeOverlay();
        return true;
      }
    }
    return false;
  }
}

class MapTravelButton extends PositionComponent {
  final String mapName;
  final StorylineMapConfig config;
  final bool isAvailable;
  final bool isCurrent;
  final bool isUnlocked;
  final VoidCallback onPressed;
  
  late RectangleComponent background;
  late TextComponent nameText;
  late TextComponent chapterText;
  late TextComponent statusText;
  
  MapTravelButton({
    required this.mapName,
    required this.config,
    required Vector2 position,
    required this.isAvailable,
    required this.isCurrent,
    required this.isUnlocked,
    required this.onPressed,
  }) : super(position: position);
  
  @override
  Future<void> onLoad() async {
    super.onLoad();
    
    // Background color based on status
    Color bgColor;
    Color borderColor;
    double opacity = 1.0;
    
    if (isCurrent) {
      bgColor = const Color(0xFF00FF00);
      borderColor = const Color(0xFF00FF00);
    } else if (isAvailable) {
      bgColor = const Color(0xFF9D4EDD);
      borderColor = const Color(0xFFE0AAFF);
    } else if (isUnlocked) {
      bgColor = const Color(0xFF5A189A);
      borderColor = const Color(0xFF9D4EDD);
    } else {
      bgColor = const Color(0xFF333333);
      borderColor = const Color(0xFF666666);
      opacity = 0.5;
    }
    
    // Background
    background = RectangleComponent(
      size: Vector2(180, 80),
      paint: Paint()
        ..color = bgColor.withOpacity(opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
      anchor: Anchor.center,
    );
    add(background);
    
    // Border
    final border = RectangleComponent(
      size: Vector2(180, 80),
      paint: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = borderColor.withOpacity(opacity),
      anchor: Anchor.center,
    );
    add(border);
    
    // Region icon based on type
    final regionIcon = _getRegionIcon(config.region);
    final iconText = TextComponent(
      text: regionIcon,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      position: Vector2(-70, -25),
      anchor: Anchor.center,
    );
    add(iconText);
    
    // Map name
    nameText = TextComponent(
      text: config.displayName.length > 18 
          ? '${config.displayName.substring(0, 15)}...'
          : config.displayName,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 12,
          color: Colors.white.withOpacity(opacity),
          fontWeight: FontWeight.bold,
        ),
      ),
      position: Vector2(-10, -15),
    );
    add(nameText);
    
    // Chapter info
    chapterText = TextComponent(
      text: 'Chapter ${config.storyChapter}',
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 10,
          color: Colors.yellow.withOpacity(opacity * 0.8),
        ),
      ),
      position: Vector2(-10, 0),
    );
    add(chapterText);
    
    // Status text
    String statusMsg;
    if (isCurrent) {
      statusMsg = 'Current Location';
    } else if (isAvailable) {
      statusMsg = 'Available';
    } else if (isUnlocked) {
      statusMsg = 'Discovered';
    } else {
      statusMsg = 'Locked';
    }
    
    statusText = TextComponent(
      text: statusMsg,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 9,
          color: Colors.white.withOpacity(opacity * 0.7),
          fontStyle: FontStyle.italic,
        ),
      ),
      position: Vector2(-10, 15),
    );
    add(statusText);
    
    // Add level requirement if locked
    if (!isUnlocked) {
      final reqText = TextComponent(
        text: 'Lv.${config.requiredLevel}',
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: 8,
            color: Colors.red.withOpacity(opacity),
          ),
        ),
        position: Vector2(60, 25),
        anchor: Anchor.center,
      );
      add(reqText);
    }
  }
  
  String _getRegionIcon(StorylineRegion region) {
    switch (region) {
      case StorylineRegion.startingLands:
        return '🌳';
      case StorylineRegion.sacredTemples:
        return '⛩️';
      case StorylineRegion.wildlands:
        return '🏔️';
      case StorylineRegion.synLaboratories:
        return '🏭';
    }
  }
  
  @override
  bool onTapDown(info) {
    if (!isUnlocked) {
      // Add shake effect for locked maps
      add(
        SequenceEffect([
          MoveByEffect(Vector2(-5, 0), EffectController(duration: 0.1)),
          MoveByEffect(Vector2(10, 0), EffectController(duration: 0.1)),
          MoveByEffect(Vector2(-10, 0), EffectController(duration: 0.1)),
          MoveByEffect(Vector2(5, 0), EffectController(duration: 0.1)),
        ]),
      );
      return true;
    }
    
    // Button press animation
    background.add(
      SequenceEffect([
        ScaleEffect.to(
          Vector2.all(1.1),
          EffectController(duration: 0.1),
        ),
        ScaleEffect.to(
          Vector2.all(1.0),
          EffectController(duration: 0.1),
        ),
      ]),
    );
    
    onPressed();
    return true;
  }
}