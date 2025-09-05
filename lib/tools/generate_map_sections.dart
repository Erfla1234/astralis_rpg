import '../systems/map_section_builder.dart';

void main() async {
  final builder = MapSectionBuilder();
  
  print('Generating map sections...');
  
  // Generate starter town
  final starterTown = builder.generateStarterTown();
  await builder.saveSectionAsTMX(
    starterTown, 
    'assets/maps/demo/section_starter_town.tmx'
  );
  print('✓ Generated starter town section');
  
  // Generate forest path
  final forestPath = builder.generateForestPath();
  await builder.saveSectionAsTMX(
    forestPath,
    'assets/maps/demo/section_forest_path.tmx'
  );
  print('✓ Generated forest path section');
  
  // Generate river crossing
  final riverCrossing = builder.generateRiverCrossing();
  await builder.saveSectionAsTMX(
    riverCrossing,
    'assets/maps/demo/section_river_crossing.tmx'
  );
  print('✓ Generated river crossing section');
  
  print('\nAll sections generated! You can now:');
  print('1. Open them in Tiled to view/edit');
  print('2. Stitch them together into a larger map');
  print('3. Load them individually in the game');
}