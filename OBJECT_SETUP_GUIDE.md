# Tiled Object Setup for Astralis RPG

## How to Add Objects in Tiled

### 1. Create Object Layer
1. **Right-click** in Layers panel
2. **Add → Object Layer**
3. **Name it**: "Objects"

### 2. Adding Objects

#### Player Spawn Point:
1. **Select Rectangle tool** (or Insert → Rectangle)
2. **Draw small rectangle** at spawn location
3. **Right-click rectangle → Properties**
4. **Add Custom Properties**:
   - `type` (string): `PlayerSpawn`  
   - `facing` (string): `north`

#### NPC Objects:
1. **Draw rectangle** where NPC should stand
2. **Properties**:
   - `type` (string): `NPC`
   - `name` (string): `Elder Kaelan`
   - `dialogue_id` (string): `elder_welcome`
   - `npc_type` (string): `elder`

#### Wild Astral Spawns:
1. **Draw rectangle** at Astral location
2. **Properties**:
   - `type` (string): `WildAstral`
   - `species` (string): `Tuki`
   - `level_min` (int): `1`
   - `level_max` (int): `3` 
   - `personality` (string): `curious`

#### Shrine Objects:
1. **Draw rectangle** at shrine location
2. **Properties**:
   - `type` (string): `Shrine`
   - `shrine_type` (string): `healing`
   - `heal_amount` (int): `100`

#### Portal/Exit Objects:
1. **Draw rectangle** at exit point
2. **Properties**:
   - `type` (string): `Portal`
   - `destination_map` (string): `whispering_forest`
   - `destination_x` (int): `400`
   - `destination_y` (int): `550`

## Property Types in Tiled
- **string**: Text values
- **int**: Whole numbers
- **float**: Decimal numbers  
- **bool**: true/false

## Visual Object Tips
- **Make objects visible** while editing (set bright colors)
- **Use consistent naming** for easy identification
- **Small rectangles** (16x16 or 32x32) work best
- **Don't overlap** interactive objects

## Testing Your Objects
After saving as .tmx:
1. **Load map in game**
2. **Walk near objects** to test interactions
3. **Check console** for debug messages
4. **Adjust positions** as needed