import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../systems/astralis_game_enhanced.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final AstralisGameEnhanced _game;

  @override
  void initState() {
    super.initState();
    _game = AstralisGameEnhanced();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<AstralisGameEnhanced>.controlled(
        gameFactory: () => _game,
      ),
    );
  }
}