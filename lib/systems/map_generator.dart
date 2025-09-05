import 'dart:math';
import 'dart:io';

class MapGenerator {
  static const int mapWidth = 100;
  static const int mapHeight = 100;
  static final Random rand = Random();
  
  static List<List<int>> generateGroundLayer() {
    var ground = List.generate(mapHeight, (_) => List.filled(mapWidth, 0));
    
    // Fill with varied grass tiles
    final grassTiles = [1, 8, 15, 21, 32, 38, 48];
    for (int y = 0; y < mapHeight; y++) {
      for (int x = 0; x < mapWidth; x++) {
        ground[y][x] = grassTiles[rand.nextInt(grassTiles.length)];
      }
    }
    
    // Add river from NW to SE
    int riverX = 10 + rand.nextInt(10);
    int riverY = 10;
    final waterTiles = [22, 39, 40];
    
    while (riverX < mapWidth - 10 && riverY < mapHeight - 10) {
      // Create river width 2-3 tiles
      int width = 2 + rand.nextInt(2);
      for (int w = 0; w < width; w++) {
        if (riverX + w < mapWidth) {
          ground[riverY][riverX + w] = waterTiles[rand.nextInt(waterTiles.length)];
        }
      }
      
      // Move river (bias towards SE)
      riverX += rand.nextInt(3);
      riverY += 1 + rand.nextInt(2);
      
      // Occasional pond widening
      if (rand.nextDouble() < 0.1) {
        for (int py = -2; py <= 2; py++) {
          for (int px = -2; px <= 2; px++) {
            if (riverY + py >= 0 && riverY + py < mapHeight && 
                riverX + px >= 0 && riverX + px < mapWidth) {
              ground[riverY + py][riverX + px] = waterTiles[rand.nextInt(waterTiles.length)];
            }
          }
        }
      }
    }
    
    // Add dirt paths
    // Path from spawn (west) to village (center)
    int pathY = mapHeight ~/ 2;
    for (int x = 5; x < mapWidth ~/ 2; x++) {
      ground[pathY][x] = 2; // horizontal path
      if (rand.nextDouble() < 0.1) pathY += rand.nextInt(3) - 1;
      pathY = pathY.clamp(10, mapHeight - 10);
    }
    
    // Path from village to exit (east)
    pathY = mapHeight ~/ 2;
    for (int x = mapWidth ~/ 2; x < mapWidth - 5; x++) {
      ground[pathY][x] = 2; // horizontal path
      if (rand.nextDouble() < 0.1) pathY += rand.nextInt(3) - 1;
      pathY = pathY.clamp(10, mapHeight - 10);
    }
    
    // Village clearing (center)
    int villageX = mapWidth ~/ 2 - 5;
    int villageY = mapHeight ~/ 2 - 5;
    for (int y = 0; y < 10; y++) {
      for (int x = 0; x < 10; x++) {
        ground[villageY + y][villageX + x] = 1; // clean grass
      }
    }
    
    return ground;
  }
  
  static List<List<int>> generateTreeLayer() {
    var trees = List.generate(mapHeight, (_) => List.filled(mapWidth, 0));
    final treeTiles = [9, 17];
    
    // Poisson disk sampling for tree placement
    for (int y = 5; y < mapHeight - 5; y += 4) {
      for (int x = 5; x < mapWidth - 5; x += 4) {
        if (rand.nextDouble() < 0.3) {
          // Add jitter
          int jx = x + rand.nextInt(3) - 1;
          int jy = y + rand.nextInt(3) - 1;
          if (jx >= 0 && jx < mapWidth && jy >= 0 && jy < mapHeight) {
            trees[jy][jx] = treeTiles[rand.nextInt(treeTiles.length)];
          }
        }
      }
    }
    
    return trees;
  }
  
  static List<List<int>> generateDetailLayer() {
    var details = List.generate(mapHeight, (_) => List.filled(mapWidth, 0));
    final rockTiles = [18, 19, 20];
    final flowerTiles = [8, 16, 37];
    
    // Scatter rocks and flowers
    for (int i = 0; i < 200; i++) {
      int x = rand.nextInt(mapWidth);
      int y = rand.nextInt(mapHeight);
      
      if (rand.nextDouble() < 0.5) {
        details[y][x] = rockTiles[rand.nextInt(rockTiles.length)];
      } else {
        details[y][x] = flowerTiles[rand.nextInt(flowerTiles.length)];
      }
    }
    
    return details;
  }
  
  static String layerToCSV(List<List<int>> layer) {
    List<String> values = [];
    for (var row in layer) {
      values.addAll(row.map((v) => v.toString()));
    }
    return values.join(',');
  }
}