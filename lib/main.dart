import 'package:flutter/material.dart';
import 'views/home_screen.dart';
import 'views/difficulty_screen.dart';
import 'views/game_screen.dart';
import 'views/scoreboard_screen.dart';

void main() {
  runApp(const ConnectFourApp());
}

class ConnectFourApp extends StatelessWidget {
  const ConnectFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // App configuration and named route definition
      title: 'Connect 4',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/difficulty': (context) => const DifficultyScreen(),
        '/game': (context) => const GameScreen(),
        '/scoreboard': (context) => const ScoreBoardScreen(),
      },
    );
  }
}