import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/cache.dart';
import 'package:flutter/material.dart';

class SpriteManager {
  static final SpriteManager _instance = SpriteManager._internal();
  factory SpriteManager() => _instance;
  SpriteManager._internal();
  
  final Map<String, SpriteSheet> _spriteSheets = {};
  final Map<String, SpriteAnimation> _animations = {};
  final Map<String, Sprite> _sprites = {};
  
  // Sprite sheet configurations for 2025 standards
  static const Map<String, SpriteSheetConfig> sheetConfigs = {
    'player': SpriteSheetConfig(
      path: 'sprites/player_sheet.png',
      tileWidth: 32,
      tileHeight: 32,
      rows: 8,
      columns: 12,
    ),
    'astrals': SpriteSheetConfig(
      path: 'sprites/astrals_sheet.png',
      tileWidth: 48,
      tileHeight: 48,
      rows: 20,
      columns: 10,
    ),
    'npcs': SpriteSheetConfig(
      path: 'sprites/npcs_sheet.png',
      tileWidth: 32,
      tileHeight: 32,
      rows: 10,
      columns: 8,
    ),
    'tiles': SpriteSheetConfig(
      path: 'sprites/tileset.png',
      tileWidth: 16,
      tileHeight: 16,
      rows: 32,
      columns: 32,
    ),
    'effects': SpriteSheetConfig(
      path: 'sprites/effects_sheet.png',
      tileWidth: 64,
      tileHeight: 64,
      rows: 8,
      columns: 8,
    ),
    'ui': SpriteSheetConfig(
      path: 'sprites/ui_elements.png',
      tileWidth: 32,
      tileHeight: 32,
      rows: 8,
      columns: 16,
    ),
  };
  
  // Initialize and preload all sprite sheets
  Future<void> initialize() async {
    for (final entry in sheetConfigs.entries) {
      try {
        await loadSpriteSheet(entry.key, entry.value);
      } catch (e) {
        print('Failed to load sprite sheet ${entry.key}: $e');
        // Create placeholder sprites if actual assets missing
        _createPlaceholderSheet(entry.key, entry.value);
      }
    }
    
    // Create common animations
    _createAnimations();
  }
  
  // Load a sprite sheet
  Future<void> loadSpriteSheet(String name, SpriteSheetConfig config) async {
    try {
      final image = await Images().load(config.path);
      final sheet = SpriteSheet(
        image: image,
        srcSize: Vector2(config.tileWidth, config.tileHeight),
      );
      _spriteSheets[name] = sheet;
    } catch (e) {
      print('Error loading sprite sheet $name: $e');
      throw e;
    }
  }
  
  // Create placeholder sprites when assets are missing
  void _createPlaceholderSheet(String name, SpriteSheetConfig config) {
    // For now, we'll use colored rectangles as placeholders
    // This ensures the game runs even without sprite assets
    print('Creating placeholder sprites for $name');
  }
  
  // Create all standard animations
  void _createAnimations() {
    // Player animations
    _createPlayerAnimations();
    
    // Astral animations
    _createAstralAnimations();
    
    // Effect animations
    _createEffectAnimations();
  }
  
  void _createPlayerAnimations() {
    final playerSheet = _spriteSheets['player'];
    if (playerSheet == null) return;
    
    // Walking animations (4 directions)
    _animations['player_walk_down'] = playerSheet.createAnimation(
      row: 0,
      stepTime: 0.15,
      to: 4,
    );
    
    _animations['player_walk_up'] = playerSheet.createAnimation(
      row: 1,
      stepTime: 0.15,
      to: 4,
    );
    
    _animations['player_walk_left'] = playerSheet.createAnimation(
      row: 2,
      stepTime: 0.15,
      to: 4,
    );
    
    _animations['player_walk_right'] = playerSheet.createAnimation(
      row: 3,
      stepTime: 0.15,
      to: 4,
    );
    
    // Idle animations
    _animations['player_idle_down'] = playerSheet.createAnimation(
      row: 4,
      stepTime: 0.5,
      to: 2,
    );
    
    _animations['player_idle_up'] = playerSheet.createAnimation(
      row: 5,
      stepTime: 0.5,
      to: 2,
    );
    
    // Battle animations
    _animations['player_throw'] = playerSheet.createAnimation(
      row: 6,
      stepTime: 0.1,
      to: 6,
      loop: false,
    );
  }
  
  void _createAstralAnimations() {
    final astralSheet = _spriteSheets['astrals'];
    if (astralSheet == null) return;
    
    // Create animations for each Astral type
    final astralTypes = [
      'tuki', 'cindcub', 'rylotl', 'rowletch', 'peavee',
      'voidlit', 'orelyx', 'oreilla', 'syn_phantom'
    ];
    
    for (var i = 0; i < astralTypes.length; i++) {
      final astralName = astralTypes[i];
      
      // Idle animation
      _animations['${astralName}_idle'] = astralSheet.createAnimation(
        row: i * 2,
        stepTime: 0.3,
        to: 4,
      );
      
      // Move animation
      _animations['${astralName}_move'] = astralSheet.createAnimation(
        row: i * 2 + 1,
        stepTime: 0.2,
        to: 6,
      );
    }
  }
  
  void _createEffectAnimations() {
    final effectSheet = _spriteSheets['effects'];
    if (effectSheet == null) return;
    
    // Bonding effect
    _animations['bond_effect'] = effectSheet.createAnimation(
      row: 0,
      stepTime: 0.1,
      to: 8,
      loop: false,
    );
    
    // Purify effect
    _animations['purify_effect'] = effectSheet.createAnimation(
      row: 1,
      stepTime: 0.15,
      to: 8,
      loop: false,
    );
    
    // Evolution effect
    _animations['evolution_effect'] = effectSheet.createAnimation(
      row: 2,
      stepTime: 0.2,
      to: 8,
      loop: false,
    );
    
    // Battle effects
    _animations['attack_slash'] = effectSheet.createAnimation(
      row: 3,
      stepTime: 0.05,
      to: 6,
      loop: false,
    );
    
    _animations['heal_sparkle'] = effectSheet.createAnimation(
      row: 4,
      stepTime: 0.1,
      to: 8,
      loop: false,
    );
  }
  
  // Get animation by name
  SpriteAnimation? getAnimation(String name) {
    return _animations[name];
  }
  
  // Get sprite from sheet
  Sprite? getSprite(String sheetName, int row, int column) {
    final sheet = _spriteSheets[sheetName];
    if (sheet == null) return null;
    
    final key = '${sheetName}_${row}_$column';
    if (!_sprites.containsKey(key)) {
      _sprites[key] = sheet.getSprite(row, column);
    }
    return _sprites[key];
  }
  
  // Create sprite component with proper scaling
  SpriteComponent createSpriteComponent({
    required String sheetName,
    required int row,
    required int column,
    Vector2? size,
    Vector2? position,
  }) {
    final sprite = getSprite(sheetName, row, column);
    if (sprite == null) {
      // Return placeholder if sprite not found
      return _createPlaceholderSprite(size ?? Vector2.all(32), position);
    }
    
    return SpriteComponent(
      sprite: sprite,
      size: size,
      position: position,
    );
  }
  
  // Create animated sprite component
  SpriteAnimationComponent createAnimatedComponent({
    required String animationName,
    Vector2? size,
    Vector2? position,
  }) {
    final animation = getAnimation(animationName);
    if (animation == null) {
      // Return placeholder if animation not found
      return _createPlaceholderAnimation(size ?? Vector2.all(32), position);
    }
    
    return SpriteAnimationComponent(
      animation: animation,
      size: size,
      position: position,
    );
  }
  
  // Placeholder sprite when asset is missing
  SpriteComponent _createPlaceholderSprite(Vector2 size, Vector2? position) {
    return PlaceholderSprite(
      size: size,
      position: position,
      color: Colors.purple.withOpacity(0.5),
    );
  }
  
  // Placeholder animation when asset is missing
  SpriteAnimationComponent _createPlaceholderAnimation(Vector2 size, Vector2? position) {
    return PlaceholderAnimation(
      size: size,
      position: position,
      color: Colors.purple.withOpacity(0.5),
    );
  }
  
  // Clear cache
  void clearCache() {
    _sprites.clear();
  }
  
  // Dispose resources
  void dispose() {
    _spriteSheets.clear();
    _animations.clear();
    _sprites.clear();
  }
}

// Sprite sheet configuration
class SpriteSheetConfig {
  final String path;
  final double tileWidth;
  final double tileHeight;
  final int rows;
  final int columns;
  
  const SpriteSheetConfig({
    required this.path,
    required this.tileWidth,
    required this.tileHeight,
    required this.rows,
    required this.columns,
  });
}

// Placeholder sprite component
class PlaceholderSprite extends RectangleComponent {
  PlaceholderSprite({
    required Vector2 size,
    Vector2? position,
    required Color color,
  }) : super(
    size: size,
    position: position,
    paint: Paint()..color = color,
  );
}

// Placeholder animation component
class PlaceholderAnimation extends RectangleComponent {
  double _time = 0;
  final Color baseColor;
  
  PlaceholderAnimation({
    required Vector2 size,
    Vector2? position,
    required Color color,
  }) : baseColor = color,
       super(
    size: size,
    position: position,
    paint: Paint()..color = color,
  );
  
  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
    
    // Pulsing effect for placeholder
    final opacity = 0.3 + (sin(_time * 2) * 0.2);
    paint.color = baseColor.withOpacity(opacity);
  }
}

// Sprite batch renderer for performance
class SpriteBatchRenderer {
  final List<SpriteRenderData> _renderQueue = [];
  
  void addSprite({
    required Sprite sprite,
    required Vector2 position,
    Vector2? size,
    double angle = 0,
    Vector2? anchor,
    Paint? overridePaint,
  }) {
    _renderQueue.add(SpriteRenderData(
      sprite: sprite,
      position: position,
      size: size,
      angle: angle,
      anchor: anchor,
      overridePaint: overridePaint,
    ));
  }
  
  void render(Canvas canvas) {
    // Batch render all sprites for performance
    for (final data in _renderQueue) {
      data.sprite.render(
        canvas,
        position: data.position,
        size: data.size,
        overridePaint: data.overridePaint,
      );
    }
    
    _renderQueue.clear();
  }
}

class SpriteRenderData {
  final Sprite sprite;
  final Vector2 position;
  final Vector2? size;
  final double angle;
  final Vector2? anchor;
  final Paint? overridePaint;
  
  SpriteRenderData({
    required this.sprite,
    required this.position,
    this.size,
    this.angle = 0,
    this.anchor,
    this.overridePaint,
  });
}