import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/game_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  runApp(const AstralisApp());
}

class AstralisApp extends StatelessWidget {
  const AstralisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astralis Monster Tamer',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Orbitron',
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}