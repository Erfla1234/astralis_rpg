# Grove of Beginnings - Map Blueprint

## Map Layout (50x50 tiles = 800x800 pixels)

### Layer 1: Background (Tile Layer)
**Fill entire map with base grass tiles**
- Use your light green grass tile for 90% of map
- Add some dark grass patches for variation

### Layer 2: Paths (Tile Layer) 
**Create main pathways**
- Central path from south entrance to north
- Curved side paths to training areas
- Path to Elder's hut (northwest)

### Layer 3: Trees & Landscape (Tile Layer)
**Add natural boundaries and features**
```
🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳 (North border)
🌳    Training Area    🌳Elder🌳
🌳        (open)        🌳 Hut 🌳  
🌳                     🌳🌳🌳🌳
🌳  🌸     Path       Astral 🌳
🌳      Tutorial      Spawn  🌳
🌳   🏛️ Shrine        🌺    🌳
🌳                          🌳
🌳🌳🌳    Entry Path    🌳🌳🌳
     🌳🌳    ⬇️     🌳🌳
```

### Layer 4: Objects (Object Layer) ⭐ MOST IMPORTANT
**Place interactive elements**

#### Essential Objects to Add:

1. **Player Spawn Point**
   - Type: `PlayerSpawn`
   - Position: Center-south (400, 700)
   - Properties: `facing: "north"`

2. **Elder Kaelan NPC**
   - Type: `NPC`  
   - Position: Northwest hut (150, 150)
   - Properties:
     - `name: "Elder Kaelan"`
     - `dialogue_id: "elder_welcome"`
     - `npc_type: "elder"`

3. **Wild Astral Spawn Points** (3 locations)
   - Type: `WildAstral`
   - Positions: 
     - East clearing (600, 300)
     - Central area (400, 400) 
     - North training (300, 200)
   - Properties:
     - `species: "Tuki"` (or "Cindcub", "Rylotl")
     - `level_min: 1`
     - `level_max: 3`
     - `personality: "curious"`

4. **Healing Shrine**
   - Type: `Shrine`
   - Position: West side (200, 400)
   - Properties:
     - `shrine_type: "healing"`
     - `heal_amount: 100`

5. **Exit Portal** (to Whispering Forest)
   - Type: `Portal`
   - Position: North exit (400, 100)  
   - Properties:
     - `destination_map: "whispering_forest"`
     - `destination_x: 400`
     - `destination_y: 550`

### Layer 5: Collision (Object Layer)
**Define walkable areas**
- Draw rectangles around trees (impassable)
- Mark water areas (if any)
- Define map boundaries

### Layer 6: Decorations (Tile Layer)
**Add final details**
- Flower patches near paths
- Small rocks for detail
- Mushrooms or other forest elements

## Map Properties (Set in Map → Map Properties)
- `background_music: "grove_peaceful.ogg"`
- `region_type: "starting"`  
- `weather_effect: "sunny"`
- `lighting_mode: "day"`
- `chapter: 1`

## Color Scheme for Visual Consistency
- **Primary**: Forest greens (#228B22, #32CD32)
- **Accent**: Earth brown paths (#8B4513)
- **Highlights**: Flower colors (#FF69B4, #FFD700)
- **Water**: Clear blue (#1E90FF)