# 🎯 Master Object Placement Guide for Astralis Multi-Region Map

## 🗺️ Complete Object Layout for 200x150 Master World

### **Region Coordinates Reference**
```
Grove of Beginnings:    X: 10-60,   Y: 100-150  (Bottom-left)
Whispering Forest:      X: 70-130,  Y: 100-150  (Bottom-right)  
Temple District:        X: 60-140,  Y: 50-110   (Center)
Crystal Caverns:        X: 10-60,   Y: 50-100   (Left-center)
Astral Peaks:           X: 10-70,   Y: 10-60    (Top-left)
SYN Facility:           X: 140-200, Y: 10-70    (Top-right)
```

## 📍 Essential Object Placements

### 🎯 **PLAYER SPAWN** (Start Location)
- **Position**: X: 35, Y: 125 (Grove center)
- **Properties**:
  - `type`: "PlayerSpawn"
  - `facing`: "north"

---

### 👥 **MAJOR NPCs** (Story Characters)

#### **Elder Kaelan** (Grove Guide)
- **Position**: X: 25, Y: 110
- **Properties**:
  - `type`: "NPC"
  - `name`: "Elder Kaelan"
  - `dialogue_id`: "elder_welcome"
  - `npc_type`: "elder"

#### **Forest Guardian** (Whispering Forest)
- **Position**: X: 100, Y: 125
- **Properties**:
  - `type`: "NPC"
  - `name`: "Forest Guardian"
  - `dialogue_id`: "forest_wisdom"
  - `npc_type`: "guardian"

#### **High Priestess** (Temple District)
- **Position**: X: 100, Y: 80
- **Properties**:
  - `type`: "NPC"
  - `name`: "High Priestess"
  - `dialogue_id`: "temple_introduction"
  - `npc_type`: "priestess"

#### **Temple Stewards** (Four Temples)
**Steward Lumina** (Radiant Temple):
- **Position**: X: 85, Y: 65
- **Properties**:
  - `type`: "NPC"
  - `name`: "Steward Lumina"
  - `element`: "radiant"

**Steward Umbra** (Void Temple):
- **Position**: X: 115, Y: 65
- **Properties**:
  - `type`: "NPC"  
  - `name`: "Steward Umbra"
  - `element`: "void"

**Steward Oneira** (Dream Temple):
- **Position**: X: 85, Y: 95
- **Properties**:
  - `type`: "NPC"
  - `name`: "Steward Oneira" 
  - `element`: "dream"

**Steward Tempest** (Storm Temple):
- **Position**: X: 115, Y: 95
- **Properties**:
  - `type`: "NPC"
  - `name`: "Steward Tempest"
  - `element`: "storm"

#### **Crystal Scholar** (Crystal Caverns)
- **Position**: X: 35, Y: 75
- **Properties**:
  - `type`: "NPC"
  - `name`: "Crystal Scholar"
  - `dialogue_id`: "crystal_knowledge"

#### **Peak Master** (Astral Peaks)  
- **Position**: X: 40, Y: 35
- **Properties**:
  - `type`: "NPC"
  - `name`: "Peak Master"
  - `dialogue_id`: "dragon_wisdom"

#### **Dr. Synthesis** (SYN Facility)
- **Position**: X: 170, Y: 40
- **Properties**:
  - `type`: "NPC"
  - `name`: "Dr. Synthesis"
  - `dialogue_id`: "syn_introduction"
  - `npc_type`: "scientist"

---

### 🦄 **WILD ASTRAL SPAWNS** (Encounter Points)

#### **Grove of Beginnings** (Starter Astrals)
**Tuki Spawn 1**:
- **Position**: X: 45, Y: 135
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "Tuki"
  - `level_min`: 1, `level_max`: 3
  - `personality`: "curious"

**Cindcub Spawn**:
- **Position**: X: 20, Y: 140
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "Cindcub" 
  - `level_min`: 1, `level_max`: 3
  - `personality`: "playful"

#### **Whispering Forest** (Intermediate)
**Rylotl Spawn**:
- **Position**: X: 90, Y: 135
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "Rylotl"
  - `level_min`: 3, `level_max`: 6

**Rowletch Spawn**:
- **Position**: X: 115, Y: 120
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "Rowletch"
  - `level_min`: 4, `level_max`: 7

#### **Crystal Caverns** (Advanced)
**Peavee Spawn**:
- **Position**: X: 40, Y: 85
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "Peavee"
  - `level_min`: 8, `level_max`: 12

**Voidlit Spawn**:
- **Position**: X: 25, Y: 65
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "Voidlit"
  - `level_min`: 10, `level_max`: 14

#### **Astral Peaks** (Legendary)
**Orelyx Spawn**:
- **Position**: X: 25, Y: 25
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "Orelyx"
  - `level_min`: 15, `level_max`: 18

**Oreilla Spawn**:
- **Position**: X: 55, Y: 30
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "Oreilla"
  - `level_min`: 16, `level_max`: 20

#### **SYN Facility** (Synthetic)
**SYN Phantom Spawn**:
- **Position**: X: 160, Y: 25
- **Properties**:
  - `type`: "WildAstral"
  - `species`: "SYN_Phantom"
  - `level_min`: 18, `level_max`: 22
  - `requires_purify`: true

---

### 🏛️ **HEALING SHRINES** (Save/Heal Points)

**Grove Shrine**:
- **Position**: X: 50, Y: 115
- **Properties**:
  - `type`: "Shrine"
  - `shrine_type`: "healing"
  - `heal_amount`: 100

**Temple Shrine** (Central):
- **Position**: X: 100, Y: 70
- **Properties**:
  - `type`: "Shrine"
  - `shrine_type`: "save"
  - `heal_amount`: 100

**Peak Shrine**:
- **Position**: X: 35, Y: 45
- **Properties**:
  - `type`: "Shrine"
  - `shrine_type`: "legendary"
  - `heal_amount`: 100

**Facility Emergency**:
- **Position**: X: 155, Y: 55
- **Properties**:
  - `type`: "Shrine"
  - `shrine_type`: "emergency"
  - `heal_amount`: 50

---

### 🚪 **REGION TRANSITIONS** (Fast Travel)

**Grove ↔ Forest**:
- **Position**: X: 65, Y: 125
- **Properties**:
  - `type`: "Portal"
  - `destination_x`: 75, `destination_y`: 125

**Forest ↔ Temple**:
- **Position**: X: 100, Y: 105
- **Properties**:
  - `type`: "Portal"
  - `destination_x`: 100, `destination_y`: 95

**Temple ↔ Caverns**:
- **Position**: X: 70, Y: 75
- **Properties**:
  - `type`: "Portal"
  - `destination_x`: 55, `destination_y`: 85

**Caverns ↔ Peaks**:
- **Position**: X: 35, Y: 55
- **Properties**:
  - `type`: "Portal"
  - `destination_x`: 40, `destination_y`: 55

**Peaks ↔ Facility**:
- **Position**: X: 65, Y: 35
- **Properties**:
  - `type`: "Portal"
  - `destination_x`: 145, `destination_y`: 65

---

### 🎁 **TREASURE CHESTS** (Optional)

**Grove Chest** (Starter Items):
- **Position**: X: 15, Y: 130
- **Properties**:
  - `type`: "Chest"
  - `item_id`: "starter_pack"
  - `quantity`: 1

**Temple Chest** (Sacred Items):
- **Position**: X: 125, Y: 85
- **Properties**:
  - `type`: "Chest"
  - `item_id`: "temple_relic"

**Peak Chest** (Legendary Items):
- **Position**: X: 20, Y: 20
- **Properties**:
  - `type`: "Chest"
  - `item_id`: "dragon_scale"
  - `required_level`: 15

---

## 🔧 **Collision Objects** (Invisible Barriers)

Add rectangles around:
- **Tree clusters** (mark as non-walkable)
- **Mountain walls** (impassable terrain)  
- **Building walls** (temple/facility boundaries)
- **Water bodies** (if any deep water)

**Properties for collision objects**:
- `type`: "Barrier"
- `collision`: true

---

## 💡 **Pro Placement Tips**

1. **Cluster related objects** - Keep NPCs near their regions
2. **Leave walking space** - Don't block paths with objects  
3. **Visual balance** - Spread important objects evenly
4. **Logical progression** - Easier content in starting areas
5. **Test frequently** - Save and test object interactions

**This gives you a complete, living world with 200+ interactive elements!** 🌟