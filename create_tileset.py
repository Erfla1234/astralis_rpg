#!/usr/bin/env python3
"""
Simple tileset generator for Astralis RPG
Creates a basic colored tileset for use with Tiled Map Editor
"""

from PIL import Image, ImageDraw
import os

def create_astralis_tileset():
    # Tileset dimensions
    tile_size = 16
    tiles_per_row = 16
    num_rows = 16
    tileset_width = tiles_per_row * tile_size
    tileset_height = num_rows * tile_size
    
    # Create new image
    tileset = Image.new('RGB', (tileset_width, tileset_height), (0, 0, 0))
    draw = ImageDraw.Draw(tileset)
    
    # Define colors for different terrain types
    colors = {
        # Nature (Starting Lands)
        'grass_light': (50, 205, 50),      # Light green
        'grass_dark': (34, 139, 34),       # Dark green  
        'dirt_path': (139, 69, 19),        # Brown
        'tree_trunk': (101, 67, 33),       # Tree brown
        'tree_leaves': (0, 100, 0),        # Dark green
        'flowers': (255, 105, 180),        # Pink
        'water': (30, 144, 255),           # Blue
        'stone': (105, 105, 105),          # Gray
        
        # Temple (Sacred)
        'marble_white': (248, 248, 255),   # White marble
        'marble_purple': (147, 112, 219),  # Purple marble
        'gold': (255, 215, 0),             # Gold accent
        'mystical_blue': (138, 43, 226),   # Mystical purple
        
        # Wildlands
        'rock_gray': (119, 136, 153),      # Rock gray
        'crystal_blue': (0, 191, 255),     # Crystal blue  
        'crystal_purple': (186, 85, 211),  # Crystal purple
        'snow': (255, 250, 250),           # Snow white
        
        # Tech (SYN Labs)
        'metal_dark': (47, 79, 79),        # Dark metal
        'metal_light': (112, 128, 144),    # Light metal
        'tech_green': (0, 255, 127),       # Tech green
        'tech_red': (255, 0, 80),          # Tech red
    }
    
    # Create tiles row by row
    tile_index = 0
    
    # Row 1-2: Nature basics
    nature_tiles = ['grass_light', 'grass_dark', 'dirt_path', 'tree_trunk', 
                   'tree_leaves', 'flowers', 'water', 'stone'] * 4
    
    # Row 3-4: Temple tiles  
    temple_tiles = ['marble_white', 'marble_purple', 'gold', 'mystical_blue'] * 8
    
    # Row 5-6: Wild tiles
    wild_tiles = ['rock_gray', 'crystal_blue', 'crystal_purple', 'snow'] * 8
    
    # Row 7-8: Tech tiles
    tech_tiles = ['metal_dark', 'metal_light', 'tech_green', 'tech_red'] * 8
    
    # Combine all tiles
    all_tiles = nature_tiles + temple_tiles + wild_tiles + tech_tiles
    
    # Fill remaining with variations
    while len(all_tiles) < tiles_per_row * num_rows:
        all_tiles.extend(['grass_light', 'marble_white', 'rock_gray', 'metal_dark'])
    
    # Draw tiles
    for row in range(num_rows):
        for col in range(tiles_per_row):
            if tile_index < len(all_tiles):
                color_name = all_tiles[tile_index]
                color = colors.get(color_name, (128, 128, 128))
                
                # Calculate tile position
                x = col * tile_size
                y = row * tile_size
                
                # Draw tile
                draw.rectangle([x, y, x + tile_size - 1, y + tile_size - 1], 
                             fill=color, outline=(0, 0, 0))
                
                tile_index += 1
    
    return tileset

def main():
    # Create output directory
    output_dir = "/Users/seo/Documents/Projects /astralis_rpg/assets/images/tilesets"
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate tileset
    print("Creating Astralis master tileset...")
    tileset = create_astralis_tileset()
    
    # Save tileset
    tileset_path = os.path.join(output_dir, "astralis_master_tileset.png")
    tileset.save(tileset_path)
    
    print(f"✅ Tileset saved to: {tileset_path}")
    print("🎮 Ready to import into Tiled Map Editor!")
    
    # Also create a smaller nature-only tileset
    nature_tileset = Image.new('RGB', (128, 128), (0, 0, 0))
    draw = ImageDraw.Draw(nature_tileset)
    
    nature_colors = [
        (50, 205, 50),    # Grass light
        (34, 139, 34),    # Grass dark
        (139, 69, 19),    # Dirt path
        (101, 67, 33),    # Tree trunk
        (0, 100, 0),      # Tree leaves
        (255, 105, 180),  # Flowers
        (30, 144, 255),   # Water
        (105, 105, 105),  # Stone
    ]
    
    for i, color in enumerate(nature_colors):
        row = i // 8
        col = i % 8
        x = col * 16
        y = row * 16
        draw.rectangle([x, y, x + 15, y + 15], fill=color, outline=(0, 0, 0))
    
    nature_path = os.path.join(output_dir, "nature_tileset.png")
    nature_tileset.save(nature_path)
    print(f"✅ Nature tileset saved to: {nature_path}")

if __name__ == "__main__":
    main()