# Tiled Map Editor Integration Guide for Astralis RPG

## Overview
This guide covers how to create and integrate Tiled maps (from mapeditor.org) for your Astralis Monster Tamer RPG storyline and world traversal.

## Setup Instructions

### 1. Install Tiled Map Editor
- Download from: https://mapeditor.org/
- Install the latest version for your operating system
- Familiarize yourself with the interface

### 2. Project Structure
Create this folder structure in your project:
```
astralis_rpg/
├── assets/
│   ├── images/
│   │   ├── tilesets/
│   │   │   ├── nature_tileset.png
│   │   │   ├── temple_tileset.png
│   │   │   ├── tech_tileset.png
│   │   │   └── character_sprites.png
│   │   └── backgrounds/
│   └── maps/
│       └── storyline/
│           ├── grove_of_beginnings.tmx
│           ├── whispering_forest.tmx
│           ├── temple_district.tmx
│           ├── radiant_temple.tmx
│           ├── void_temple.tmx
│           ├── dream_temple.tmx
│           ├── storm_temple.tmx
│           ├── crystal_caverns.tmx
│           ├── astral_peaks.tmx
│           ├── syn_facility.tmx
│           └── core_chamber.tmx
```

### 3. Tileset Creation Guidelines

#### Nature Tileset (for starting areas):
- **Grass tiles**: Various grass patterns for Grove of Beginnings
- **Tree tiles**: Different tree types and sizes
- **Path tiles**: Stone and dirt pathways
- **Water tiles**: Streams and ponds
- **Flower tiles**: Decorative flora

#### Temple Tileset (for sacred areas):
- **Stone floor**: Marble and granite patterns
- **Pillars**: Various temple columns
- **Altar tiles**: Sacred shrine elements  
- **Mystical symbols**: Glowing runes and emblems
- **Brazier tiles**: Flame elements

#### Tech Tileset (for SYN facilities):
- **Metal floor**: Steel and chrome surfaces
- **Wall panels**: Futuristic wall sections
- **Computer consoles**: Interactive tech elements
- **Pipes and wiring**: Industrial elements
- **Energy conduits**: Glowing tech lines

## Map Creation Process

### 1. Grove of Beginnings (Starting Map)
**Recommended Size**: 50x50 tiles (800x800 pixels at 16px tiles)
**Theme**: Peaceful forest clearing

#### Layers to Create:
1. **Background** - Base terrain (grass, dirt)
2. **Decorations** - Trees, flowers, rocks
3. **Collision** - Invisible collision boundaries
4. **Objects** - NPCs, Astrals, interactables
5. **Foreground** - Elements that render above player

#### Key Elements to Include:
- **Elder Kaelan spawn point** - Mark with object
- **Wild Tuki locations** - 2-3 spawn points
- **Training areas** - Open spaces for bonding
- **Exit points** - Connections to other maps

### 2. Temple District (Hub Map)
**Recommended Size**: 60x60 tiles
**Theme**: Sacred central plaza

#### Special Features:
- **Four temple entrances** - Clear pathways to each temple
- **Central fountain** - Mystical meeting point
- **NPC gathering areas** - Places for important characters
- **Travel waypoints** - Fast travel markers

### 3. Advanced Area Maps
Each advanced map should include:
- **Unique environmental challenges**
- **Region-specific Astral spawn points**
- **Hidden areas and secrets**
- **Story-relevant locations**

## Object Layer Configuration

### Object Types to Define:

#### Player Objects:
- **PlayerSpawn** - Where player appears on map entry
  - Properties: `spawnX`, `spawnY`, `facing`

#### NPC Objects:
- **NPC** - Non-player character placement
  - Properties: `name`, `dialogue_id`, `npc_type`

#### Astral Objects:
- **WildAstral** - Wild Astral encounter points
  - Properties: `species`, `level_min`, `level_max`, `personality`

#### Interactive Objects:
- **Portal** - Map transition points
  - Properties: `destination_map`, `destination_x`, `destination_y`
- **Chest** - Treasure containers
  - Properties: `item_id`, `quantity`, `required_key`
- **Shrine** - Healing/save points
  - Properties: `shrine_type`, `heal_amount`

#### Collision Objects:
- **Barrier** - Invisible walls
- **Water** - Impassable water areas
- **Cliff** - Elevation changes

## Layer Guidelines

### Layer Order (bottom to top):
1. **Background** - Base terrain
2. **Ground Details** - Grass patterns, floor decorations
3. **Objects Lower** - Objects that appear behind player
4. **Collision** - Collision boundaries (invisible)
5. **Player** - Player sprite renders here
6. **Objects Upper** - Objects in front of player
7. **Foreground** - Tree canopies, overhangs
8. **UI Elements** - Map-specific UI overlays

## Custom Properties

### Map Properties:
- `background_music` (string): Audio file for ambient music
- `weather_effect` (string): Rain, snow, etc.
- `lighting_mode` (string): Day, night, mystical
- `region_type` (string): starting, temple, wild, tech

### Tile Properties:
- `walkable` (bool): Can player walk on this tile
- `interaction_type` (string): heal, damage, teleport
- `sound_effect` (string): Audio when stepped on

## Integration with Flutter Code

### 1. Loading Maps in Code:
```dart
// Load a storyline map
await TiledWorldManager().loadStorylineMap('grove_of_beginnings');

// Get spawn position
Vector2 spawnPos = TiledWorldManager().getSpawnPosition();

// Check map connections
List<String> destinations = TiledWorldManager().getAvailableDestinations();
```

### 2. Collision Detection:
```dart
// Check if position is walkable
bool canWalk = TiledWorldManager().isWalkable(playerPosition);
```

### 3. Object Interaction:
```dart
// Get objects at position
final objects = currentMap.tileMap.getLayer<ObjectGroup>('Objects');
// Process NPC, Astral, and item interactions
```

## Story Integration

### Chapter Progression:
1. **Chapter 1**: Grove of Beginnings - Learn basics
2. **Chapter 2**: Whispering Forest - First wild encounters  
3. **Chapter 3**: Temple District - Meet the stewards
4. **Chapter 4**: Individual Temples - Master each element
5. **Chapter 5**: Crystal Caverns - Advanced bonding
6. **Chapter 6**: Astral Peaks - Legendary encounters
7. **Chapter 7**: SYN Facility - Synthetic Astrals
8. **Chapter 8**: Core Chamber - Final confrontation

### Map Unlocking System:
Maps unlock based on:
- **Player level requirements**
- **Story chapter completion** 
- **Previous map completion**
- **Special key items obtained**

## Visual Design Tips

### Color Schemes by Region:
- **Starting Lands**: Greens, browns, warm earth tones
- **Sacred Temples**: Purples, golds, mystical blues
- **Wildlands**: Vibrant colors, crystals, dramatic lighting
- **SYN Labs**: Cool blues, metallic grays, neon accents

### Lighting and Atmosphere:
- Use **darker tiles** for shadows and depth
- Add **glowing elements** for mystical areas
- Create **visual paths** to guide player movement
- Include **landmark elements** for navigation

## Testing Your Maps

### In-Game Testing:
1. Load each map and verify spawn points
2. Test all collision boundaries
3. Verify NPC and Astral placements
4. Check portal connections work correctly
5. Ensure visual consistency with game theme

### Performance Optimization:
- **Optimize tileset size** - Use efficient sprite sheets
- **Limit layer count** - Combine similar layers when possible
- **Minimize overdraw** - Avoid excessive transparent overlays
- **Cache frequently used maps** - Preload important areas

This integration allows you to create rich, detailed worlds that enhance the Astralis RPG storyline while maintaining professional game development standards!