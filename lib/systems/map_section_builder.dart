import 'dart:io';
import 'dart:math';

/// Section types for different map areas
enum SectionType {
  starterTown,
  forest,
  riverCrossing,
  meadow,
  hillside,
  dungeon_entrance,
  village,
  crossroads
}

/// Connection points for stitching sections
class ConnectionPoint {
  final String direction; // 'north', 'south', 'east', 'west'
  final int position; // 0-19 for a 20x20 section
  final String type; // 'path', 'river', 'open'
  
  ConnectionPoint(this.direction, this.position, this.type);
}

/// A map section with layers and metadata
class MapSection {
  final String name;
  final SectionType type;
  final List<List<int>> groundLayer;
  final List<List<int>> detailsLowLayer;
  final List<List<int>> detailsMidLayer;
  final List<List<int>> treesLayer;
  final List<ConnectionPoint> connections;
  final Map<String, Point<int>> pointsOfInterest;
  
  MapSection({
    required this.name,
    required this.type,
    required this.groundLayer,
    required this.detailsLowLayer,
    required this.detailsMidLayer,
    required this.treesLayer,
    required this.connections,
    required this.pointsOfInterest,
  });
}

/// Modular map section builder for creating Tiled maps piece by piece
class MapSectionBuilder {
  static const int SECTION_SIZE = 20;
  static const int TILE_SIZE = 16;
  
  // Tile IDs from your tileset
  static const Map<String, List<int>> TILES = {
    'grass': [1, 8, 15, 21, 32, 38, 48],
    'path_h': [2],
    'path_v': [3],
    'path_corners': [4, 5, 6, 7],
    'path_cross': [10],
    'path_tees': [11, 12, 13, 14],
    'water': [22, 39, 40],
    'water_edges': [23, 26, 27, 31],
    'water_corners': [28, 29, 30, 31],
    'trees': [9, 17],
    'rocks': [18, 19, 20],
    'flowers': [8, 16, 37],
    'bushes': [25, 36],
    'stumps': [34],
    'logs': [33],
    'crate': [41],
    'sign': [42],
    'barrel': [46],
    'chest': [47],
  };
  
  final Random rand = Random();
  
  /// Generate a starter town section
  MapSection generateStarterTown() {
    var ground = _createEmptyLayer();
    var detailsLow = _createEmptyLayer();
    var detailsMid = _createEmptyLayer();
    var trees = _createEmptyLayer();
    var connections = <ConnectionPoint>[];
    var pois = <String, Point<int>>{};
    
    // Fill with grass
    _fillWithGrass(ground);
    
    // Create town square (center area with paths)
    for (int y = 5; y < 15; y++) {
      for (int x = 5; x < 15; x++) {
        ground[y][x] = TILES['grass']![0]; // Clean grass
      }
    }
    
    // Add main path (horizontal through center)
    for (int x = 0; x < SECTION_SIZE; x++) {
      ground[10][x] = TILES['path_h']![0];
    }
    connections.add(ConnectionPoint('east', 10, 'path'));
    connections.add(ConnectionPoint('west', 10, 'path'));
    
    // Add vertical path to north
    for (int y = 0; y <= 10; y++) {
      ground[y][10] = TILES['path_v']![0];
    }
    ground[10][10] = TILES['path_cross']![0]; // Crossroads
    connections.add(ConnectionPoint('north', 10, 'path'));
    
    // Add some buildings (represented by crates/barrels for now)
    detailsMid[6][6] = TILES['crate']![0];
    detailsMid[6][13] = TILES['barrel']![0];
    detailsMid[13][6] = TILES['chest']![0];
    detailsMid[13][13] = TILES['sign']![0];
    
    // Add decorative elements
    _scatterFlowers(detailsLow, density: 0.02);
    
    // Add trees around edges
    for (int i = 0; i < 5; i++) {
      int x = rand.nextInt(5);
      int y = rand.nextInt(SECTION_SIZE);
      trees[y][x] = TILES['trees']![rand.nextInt(TILES['trees']!.length)];
      
      x = SECTION_SIZE - 1 - rand.nextInt(5);
      y = rand.nextInt(SECTION_SIZE);
      trees[y][x] = TILES['trees']![rand.nextInt(TILES['trees']!.length)];
    }
    
    // Points of interest
    pois['spawn'] = Point(10, 15);
    pois['shop'] = Point(6, 6);
    pois['inn'] = Point(13, 6);
    
    return MapSection(
      name: 'starter_town',
      type: SectionType.starterTown,
      groundLayer: ground,
      detailsLowLayer: detailsLow,
      detailsMidLayer: detailsMid,
      treesLayer: trees,
      connections: connections,
      pointsOfInterest: pois,
    );
  }
  
  /// Generate a forest path section
  MapSection generateForestPath() {
    var ground = _createEmptyLayer();
    var detailsLow = _createEmptyLayer();
    var detailsMid = _createEmptyLayer();
    var trees = _createEmptyLayer();
    var connections = <ConnectionPoint>[];
    var pois = <String, Point<int>>{};
    
    _fillWithGrass(ground);
    
    // Winding path through forest
    int pathY = 10;
    for (int x = 0; x < SECTION_SIZE; x++) {
      ground[pathY][x] = TILES['path_h']![0];
      
      // Make path wind
      if (x % 4 == 0 && rand.nextBool()) {
        pathY += rand.nextBool() ? 1 : -1;
        pathY = pathY.clamp(5, 14);
        if (x > 0) {
          ground[pathY][x] = TILES['path_corners']![rand.nextInt(4)];
        }
      }
    }
    connections.add(ConnectionPoint('east', pathY, 'path'));
    connections.add(ConnectionPoint('west', 10, 'path'));
    
    // Dense trees
    for (int y = 0; y < SECTION_SIZE; y++) {
      for (int x = 0; x < SECTION_SIZE; x++) {
        // Don't place trees on or near path
        bool nearPath = false;
        for (int dy = -1; dy <= 1; dy++) {
          for (int dx = -1; dx <= 1; dx++) {
            int checkY = y + dy;
            int checkX = x + dx;
            if (checkY >= 0 && checkY < SECTION_SIZE && 
                checkX >= 0 && checkX < SECTION_SIZE) {
              if (ground[checkY][checkX] >= 2 && ground[checkY][checkX] <= 14) {
                nearPath = true;
                break;
              }
            }
          }
        }
        
        if (!nearPath && rand.nextDouble() < 0.3) {
          trees[y][x] = TILES['trees']![rand.nextInt(TILES['trees']!.length)];
        }
      }
    }
    
    // Add forest details
    _scatterRocks(detailsMid, density: 0.05);
    _scatterFlowers(detailsLow, density: 0.03);
    
    // Add some stumps and logs
    for (int i = 0; i < 3; i++) {
      int x = rand.nextInt(SECTION_SIZE);
      int y = rand.nextInt(SECTION_SIZE);
      if (trees[y][x] == 0) {
        detailsMid[y][x] = rand.nextBool() ? TILES['stumps']![0] : TILES['logs']![0];
      }
    }
    
    pois['clearing'] = Point(10, 10);
    
    return MapSection(
      name: 'forest_path',
      type: SectionType.forest,
      groundLayer: ground,
      detailsLowLayer: detailsLow,
      detailsMidLayer: detailsMid,
      treesLayer: trees,
      connections: connections,
      pointsOfInterest: pois,
    );
  }
  
  /// Generate a river crossing section
  MapSection generateRiverCrossing() {
    var ground = _createEmptyLayer();
    var detailsLow = _createEmptyLayer();
    var detailsMid = _createEmptyLayer();
    var trees = _createEmptyLayer();
    var connections = <ConnectionPoint>[];
    var pois = <String, Point<int>>{};
    
    _fillWithGrass(ground);
    
    // River running north-south
    for (int y = 0; y < SECTION_SIZE; y++) {
      for (int x = 8; x < 12; x++) {
        ground[y][x] = TILES['water']![rand.nextInt(TILES['water']!.length)];
      }
    }
    connections.add(ConnectionPoint('north', 10, 'river'));
    connections.add(ConnectionPoint('south', 10, 'river'));
    
    // Bridge (path over water)
    for (int x = 0; x < SECTION_SIZE; x++) {
      ground[10][x] = x >= 8 && x < 12 ? TILES['path_h']![0] : TILES['path_h']![0];
    }
    connections.add(ConnectionPoint('east', 10, 'path'));
    connections.add(ConnectionPoint('west', 10, 'path'));
    
    // Riverside vegetation
    for (int y = 0; y < SECTION_SIZE; y++) {
      if (rand.nextDouble() < 0.3) {
        if (7 >= 0) trees[y][7] = TILES['bushes']![rand.nextInt(TILES['bushes']!.length)];
        if (12 < SECTION_SIZE) trees[y][12] = TILES['bushes']![rand.nextInt(TILES['bushes']!.length)];
      }
    }
    
    // Some rocks near water
    _scatterRocks(detailsMid, density: 0.04);
    
    pois['bridge'] = Point(10, 10);
    
    return MapSection(
      name: 'river_crossing',
      type: SectionType.riverCrossing,
      groundLayer: ground,
      detailsLowLayer: detailsLow,
      detailsMidLayer: detailsMid,
      treesLayer: trees,
      connections: connections,
      pointsOfInterest: pois,
    );
  }
  
  // Helper methods
  List<List<int>> _createEmptyLayer() {
    return List.generate(SECTION_SIZE, (_) => List.filled(SECTION_SIZE, 0));
  }
  
  void _fillWithGrass(List<List<int>> layer) {
    for (int y = 0; y < SECTION_SIZE; y++) {
      for (int x = 0; x < SECTION_SIZE; x++) {
        layer[y][x] = TILES['grass']![rand.nextInt(TILES['grass']!.length)];
      }
    }
  }
  
  void _scatterFlowers(List<List<int>> layer, {double density = 0.05}) {
    for (int y = 0; y < SECTION_SIZE; y++) {
      for (int x = 0; x < SECTION_SIZE; x++) {
        if (rand.nextDouble() < density) {
          layer[y][x] = TILES['flowers']![rand.nextInt(TILES['flowers']!.length)];
        }
      }
    }
  }
  
  void _scatterRocks(List<List<int>> layer, {double density = 0.05}) {
    for (int y = 0; y < SECTION_SIZE; y++) {
      for (int x = 0; x < SECTION_SIZE; x++) {
        if (rand.nextDouble() < density) {
          layer[y][x] = TILES['rocks']![rand.nextInt(TILES['rocks']!.length)];
        }
      }
    }
  }
  
  /// Save a section as a TMX file
  Future<void> saveSectionAsTMX(MapSection section, String filepath) async {
    String tmx = '''<?xml version="1.0" encoding="UTF-8"?>
<map version="1.10" tiledversion="1.10.0" orientation="orthogonal" renderorder="right-down" width="20" height="20" tilewidth="16" tileheight="16" infinite="0" nextlayerid="6" nextobjectid="1">
 <tileset firstgid="1" source="../../images/tilesets/grove/base/grove_base_tileset_16px.tsx"/>
 <layer id="1" name="ground" width="20" height="20">
  <data encoding="csv">
${_layerToCSV(section.groundLayer)}
  </data>
 </layer>
 <layer id="2" name="details_low" width="20" height="20">
  <data encoding="csv">
${_layerToCSV(section.detailsLowLayer)}
  </data>
 </layer>
 <layer id="3" name="details_mid" width="20" height="20">
  <data encoding="csv">
${_layerToCSV(section.detailsMidLayer)}
  </data>
 </layer>
 <layer id="4" name="trees" width="20" height="20">
  <data encoding="csv">
${_layerToCSV(section.treesLayer)}
  </data>
 </layer>
 <objectgroup id="5" name="metadata">
${_generateObjects(section)}
 </objectgroup>
</map>''';
    
    await File(filepath).writeAsString(tmx);
  }
  
  String _layerToCSV(List<List<int>> layer) {
    List<String> values = [];
    for (var row in layer) {
      values.addAll(row.map((v) => v.toString()));
    }
    
    // Format as CSV with line breaks every 20 values
    List<String> lines = [];
    for (int i = 0; i < values.length; i += 20) {
      lines.add(values.sublist(i, min(i + 20, values.length)).join(','));
    }
    return lines.join(',\n');
  }
  
  String _generateObjects(MapSection section) {
    String objects = '';
    int id = 1;
    
    for (var entry in section.pointsOfInterest.entries) {
      objects += '  <object id="$id" name="${entry.key}" x="${entry.value.x * TILE_SIZE}" y="${entry.value.y * TILE_SIZE}"/>\n';
      id++;
    }
    
    return objects;
  }
}