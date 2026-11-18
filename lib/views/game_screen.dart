import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../services/score_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late GameModel _gameModel;
  String _difficulty = 'easy';
  final ScoreService _scoreService = ScoreService();

  int wins = 0;
  int losses = 0;
  int draws = 0;

  int _aiMoveToken = 0;
  bool _gameInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadScores();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_gameInitialized) {
      _difficulty =
          ModalRoute.of(context)?.settings.arguments as String? ?? 'easy';
      _gameModel = GameModel(difficulty: _difficulty);
      _gameInitialized = true;
    }
  }

  Future<void> _loadScores() async {
    final scores = await _scoreService.getScores();
    if (!mounted) return;

    setState(() {
      wins = scores['wins'] ?? 0;
      losses = scores['losses'] ?? 0;
      draws = scores['draws'] ?? 0;
    });
  }

  void handleColumnTap(int col) {
    if (_gameModel.gameEnded || !_gameModel.isHumanTurn) return;
    setState(() {
      _gameModel.handleColumnTap(col);
      _aiMoveToken++;
    });
    if (_gameModel.gameEnded) {
      _updateScore();
      return;
    }
    if (!_gameModel.isHumanTurn) {
      final int currentToken = _aiMoveToken;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        if (currentToken != _aiMoveToken) return;
        if (_gameModel.gameEnded) return;
        if (_gameModel.isHumanTurn) return;
        setState(() {
          _gameModel.makeComputerMove();
        });

        if (_gameModel.gameEnded) {
          _updateScore();
        }
      });
    }
  }

  Future<void> _updateScore() async {
    if (_gameModel.winner == 'Y') {
      await _scoreService.incrementWins();
    } else if (_gameModel.winner == 'R') {
      await _scoreService.incrementLosses();
    } else {
      await _scoreService.incrementDraws();
    }
    await _loadScores();
  }

  Widget _buildDisc(String value) {
    if (value == 'Y') {
      return Image.asset(
        'assets/images/green_disc.png',
        width: 42,
        height: 42,
      );
    } else if (value == 'R') {
      return Image.asset(
        'assets/images/red_disc.png',
        width: 42,
        height: 42,
      );
    }

    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildStatBox(String title, int value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _restartGame() {
    setState(() {
      _gameModel = GameModel(difficulty: _difficulty);
      _aiMoveToken++;
    });
  }

  void _undoMove() {
    setState(() {
      _gameModel.undoLastMove();
      _aiMoveToken++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_difficulty[0].toUpperCase()}${_difficulty.substring(1)} Mode',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
        actions: [
           if (!_gameModel.gameEnded)
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _gameModel.moveHistory.isNotEmpty ? _undoMove : null,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_gameModel.gameEnded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                _gameModel.winner == null
                    ? 'It\'s a Draw!'
                    : _gameModel.winner == 'Y'
                        ? 'Player Wins!'
                        : 'Computer Wins!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBox('Wins', wins),
                _buildStatBox('Losses', losses),
                _buildStatBox('Draws', draws),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 7 / 6,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.blue.shade700,
                  child: Column(
                    children: List.generate(6, (row) {
                      return Expanded(
                        child: Row(
                          children: List.generate(7, (col) {
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => handleColumnTap(col),
                                child: Container(
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade400,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: _buildDisc(_gameModel.board[row][col]),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, top: 12),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/difficulty');
              },
              child: const Text(
                'Change Difficulty',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}