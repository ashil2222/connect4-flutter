import 'dart:math';
import 'game_model.dart';

class AiLogic {
  final GameModel model;
  final Random _random = Random();
  AiLogic({required this.model});

  // make computer move based on the difficulty level
  void makeMove() {
    switch (model.difficulty) {
      case 'easy':
        _makeRandomMove();
        break;
      case 'medium':
        _makeMediumMove();
        break;
      case 'hard':
        _makeHardMove();
        break;
      default:
        _makeRandomMove();
    }
  }

  // Makes random move
  void _makeRandomMove() {
    List<int> valid = model.getValidColumns();
    if (valid.isEmpty) return;
    int col = valid[_random.nextInt(valid.length)];
    _placeDisc(col);
  }

  // Medium mode alternates between random and hard moves
  void _makeMediumMove() {
    if (model.aiTurnCount % 2 == 0) {
      _makeRandomMove();
    } else {
      _makeHardMove();
    }
    model.aiTurnCount++;
  }

  // Makes a harder move for hard mode
  void _makeHardMove() {
    int? col = _findWinningMove(GameConstants.computer) ??
        _findWinningMove(GameConstants.human) ??
        _findStrategicMove() ??
        _takeCenterIfAvailable() ??
        _takeNearCenter() ??
        (model.getValidColumns().isNotEmpty
            ? model.getValidColumns().first
            : null);

    if (col != null) _placeDisc(col);
  }

  // Finds winning move for a player
  int? _findWinningMove(String player) {
    for (int col = 0; col < GameConstants.cols; col++) {
      if (model.isValidMove(col)) {
        int row = model.getNextOpenRow(col);
        model.board[row][col] = player;
        bool wins = WinChecker.hasWon(model.board, player);
        model.board[row][col] = GameConstants.empty;
        if (wins) return col;
      }
    }
    return null;
  }

  // Find move that creates 3 in a row
  int? _findStrategicMove() {
    for (int col = 0; col < GameConstants.cols; col++) {
      if (model.isValidMove(col)) {
        int row = model.getNextOpenRow(col);
        model.board[row][col] = GameConstants.computer;
        int count = _countConnected(row, col, GameConstants.computer);
        model.board[row][col] = GameConstants.empty;
        if (count >= 3) return col;
      }
    }
    return null;
  }

  // Count connected discs
  int _countConnected(int row, int col, String player) {
    int best = 1;
    List<List<int>> directions = [
      [0, 1], [1, 0], [1, 1], [1, -1]
    ];

    for (var dir in directions) {
      int count = 1;
      int r = row + dir[0], c = col + dir[1];
      while (r >= 0 && r < GameConstants.rows &&
          c >= 0 && c < GameConstants.cols &&
          model.board[r][c] == player) {
        count++;
        r += dir[0];
        c += dir[1];
      }
      r = row - dir[0];
      c = col - dir[1];
      while (r >= 0 && r < GameConstants.rows &&
          c >= 0 && c < GameConstants.cols &&
          model.board[r][c] == player) {
        count++;
        r -= dir[0];
        c -= dir[1];
      }
      if (count > best) best = count;
    }
    return best;
  }

  // Take center column if available
  int? _takeCenterIfAvailable() {
    return model.isValidMove(3) ? 3 : null;
  }

  // Take near center columns in order
  int? _takeNearCenter() {
    for (int col in [2, 4, 1, 5]) {
      if (model.isValidMove(col)) return col;
    }
    return null;
  }

  // Place disc and update game state
  void _placeDisc(int col) {
    int row = model.getNextOpenRow(col);
    if (row == -1) return;

    model.board[row][col] = GameConstants.computer;
    model.moveHistory.add(
      Move(row: row, col: col, player: GameConstants.computer),
    );

    if (WinChecker.hasWon(model.board, GameConstants.computer)) {
      model.winner = GameConstants.computer;
      model.gameEnded = true;
    } else if (WinChecker.isDraw(model.board)) {
      model.winner = null;
      model.gameEnded = true;
    } else {
      model.isHumanTurn = true;
    }
  }
}