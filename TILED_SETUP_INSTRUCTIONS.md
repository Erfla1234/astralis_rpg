# 🎮 Complete Tiled Setup Instructions for Astralis RPG

## 📁 Your Files Are Ready!

I've created everything you need:

✅ **Tilesets Created**:
- `astralis_master_tileset.png` - Complete tileset for all regions
- `nature_tileset.png` - Simplified nature tileset to start

✅ **Directories Created**:
- `/assets/images/tilesets/` - Your tilesets
- `/assets/maps/storyline/` - Where your .tmx files go

## 🚀 Step-by-Step Tiled Setup

### 1. Create Your Master World Map

**In Tiled:**
1. **File → New Map**
2. **Settings**:
   - **Map size**: `200 x 150 tiles` (this gives you a huge world!)
   - **Tile size**: `16 x 16 pixels`
   - **Orientation**: Orthogonal
   - **Tile layer format**: CSV

### 2. Import Your Tileset

1. **Map → New Tileset**
2. **Source**: Browse to `/assets/images/tilesets/astralis_master_tileset.png`
3. **Name**: "Astralis Master"
4. **Tile width**: 16
5. **Tile height**: 16
6. **Click OK**

### 3. Create Layer Structure

**Create these layers in order (bottom to top):**

1. **"Background"** (Tile Layer) - Base terrain for entire world
2. **"Paths"** (Tile Layer) - Roads and walkways connecting regions  
3. **"Terrain"** (Tile Layer) - Trees, rocks, buildings
4. **"Objects"** (Object Layer) ⭐ **MOST IMPORTANT**
5. **"Collision"** (Object Layer) - Invisible barriers
6. **"Decorations"** (Tile Layer) - Final details

### 4. Paint Your World Regions

**Using the tileset, paint these regions:**

#### 🌳 **Grove of Beginnings** (Bottom-left, 50x50 area)
- **Base**: Light green grass tiles
- **Features**: Dark green trees around borders, brown paths
- **Center**: Open area for training

#### 🌲 **Whispering Forest** (Bottom-right, 60x40 area)  
- **Base**: Dark green grass
- **Features**: Dense tree coverage, winding paths
- **Clearings**: Small open spaces for encounters

#### ⛩️ **Temple District** (Center, 80x60 area)
- **Base**: White/purple marble tiles
- **Features**: 4 temple buildings (use different colored tiles)
- **Center**: Large plaza with gold accents

#### 💎 **Crystal Caverns** (Left-center, 50x50 area)
- **Base**: Gray rock tiles  
- **Features**: Blue crystal formations
- **Tunnels**: Winding cave passages

#### 🏔️ **Astral Peaks** (Top-left, 60x50 area)
- **Base**: Gray/white mountain tiles
- **Features**: Snow patches, rocky terrain
- **Peaks**: Higher elevation areas

#### 🏭 **SYN Facility** (Top-right, 70x60 area)
- **Base**: Dark metal tiles
- **Features**: Tech green/red accents
- **Buildings**: Geometric facility structures

### 5. Add Objects (The Magic Happens Here!)

**Click on "Objects" layer, then add:**

#### 🎯 **Player Spawn** (Grove center)
- **Tool**: Rectangle
- **Size**: 16x16
- **Properties**:
  - `type`: "PlayerSpawn"
  - `facing`: "north"

#### 👥 **NPCs** (Place throughout world)
- **Elder Kaelan** (Grove):
  - `type`: "NPC"
  - `name`: "Elder Kaelan"
  - `dialogue_id`: "elder_welcome"

- **Temple Stewards** (Each temple):
  - `type`: "NPC"  
  - `name`: "Steward Lumina" (Radiant Temple)
  - `npc_type`: "steward"

#### 🦄 **Astral Spawn Points** (Multiple locations)
- **Grove Astrals**:
  - `type`: "WildAstral"
  - `species`: "Tuki"
  - `level_min`: 1, `level_max`: 3

- **Forest Astrals**:
  - `species`: "Rylotl"
  - `level_min`: 3, `level_max`: 5

- **Peak Dragons**:  
  - `species`: "dragon_astrals"
  - `level_min`: 15, `level_max`: 20

#### 🚪 **Region Connections** (Transition points)
- **Grove → Forest**:
  - `type`: "Portal"
  - `destination_map`: "current" (same map)
  - `destination_x`: [Forest coordinates]

#### 🏛️ **Interactive Objects**
- **Healing Shrines** (Each region):
  - `type`: "Shrine"
  - `shrine_type`: "healing"

- **Save Crystals** (Major locations):
  - `type`: "Shrine" 
  - `shrine_type`: "save"

### 6. Set Map Properties

**Map → Map Properties, add:**
- `background_music`: "world_theme.ogg"
- `region_type`: "master_world"
- `weather_effect`: "dynamic"
- `lighting_mode`: "day"

### 7. Save Your Masterpiece

**File → Save As**: `astralis_master_world.tmx`
**Location**: `/assets/maps/storyline/`

## 🎮 Testing Your Map

1. **Save the .tmx file**
2. **Launch Astralis RPG**
3. **Press 'M'** to open world map
4. **Select** your map region
5. **Walk around** and test interactions!

## 🎨 Tileset Color Guide

**Your generated tileset has:**
- **Light Green** = Grass (starting areas)
- **Dark Green** = Trees/forest  
- **Brown** = Paths and dirt
- **Purple** = Temple/mystical areas
- **Gray** = Rock/mountain terrain
- **Blue** = Water and crystals
- **Metal colors** = Tech facility areas

## 💡 Pro Tips

1. **Start simple** - Paint basic terrain first
2. **Test frequently** - Save and test in-game often
3. **Use consistent object naming** - Makes debugging easier
4. **Group similar objects** - Keep NPCs together, etc.
5. **Visual hierarchy** - Important objects should stand out

**You now have everything needed to create an epic multi-region world!** 🌟