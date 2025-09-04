# Astralis RPG Maps Directory

This directory contains Tiled map files (.tmx) for the Astralis RPG storyline.

## Directory Structure:
```
assets/maps/
├── storyline/
│   ├── grove_of_beginnings.tmx    # Starting area - Chapter 1
│   ├── whispering_forest.tmx      # Forest exploration - Chapter 2  
│   ├── temple_district.tmx        # Temple hub - Chapter 3
│   ├── radiant_temple.tmx         # Light temple - Chapter 4
│   ├── void_temple.tmx            # Shadow temple - Chapter 4
│   ├── dream_temple.tmx           # Psychic temple - Chapter 4
│   ├── storm_temple.tmx           # Lightning temple - Chapter 4
│   ├── crystal_caverns.tmx        # Cave exploration - Chapter 5
│   ├── astral_peaks.tmx           # Mountain peaks - Chapter 6
│   ├── syn_facility.tmx           # Research facility - Chapter 7
│   └── core_chamber.tmx           # Final area - Chapter 8
├── tilesets/
│   ├── nature_tiles.tsx           # Nature tileset definition
│   ├── temple_tiles.tsx           # Temple tileset definition
│   ├── tech_tiles.tsx             # Technology tileset definition
│   └── characters.tsx             # Character sprites tileset
└── templates/
    ├── basic_map_template.tmx     # Template for new maps
    └── map_guidelines.txt         # Design guidelines

```

## Map Creation Workflow:

1. **Create in Tiled Map Editor** (mapeditor.org)
2. **Save as .tmx format** in appropriate storyline folder
3. **Reference tilesets** from the tilesets/ directory
4. **Define object layers** for NPCs, Astrals, and interactables
5. **Set map properties** for music, lighting, etc.
6. **Test in game** using TiledWorldManager

## Integration Notes:

- Maps automatically load through TiledWorldManager
- Fallback to procedural placeholders if .tmx files not found
- Object layers processed for gameplay elements
- Collision detection based on collision layer
- Story progression unlocks new maps

Create your .tmx files here to replace the procedural placeholders!