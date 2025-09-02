import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../systems/astralis_game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final AstralisGame _game;

  @override
  void initState() {
    super.initState();
    _game = AstralisGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<AstralisGame>.controlled(
        gameFactory: () => _game,
      ),
    );
  }
}