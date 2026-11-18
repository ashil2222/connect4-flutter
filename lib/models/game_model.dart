import 'ai_logic.dart';

// This store every move in undo fearture
class Move {
  final String player;
  final int row;
  final int col;

  Move({required this.player, required this.row, required this.col});
}

// This avoid magic numbers from game constant values
class GameConstants {
  static const int rows = 6;
  static const int cols = 7;
  static const String empty = '';
  static const String human = 'Y';
  static const String computer = 'R';
}


//This check the win and draw condition
class WinChecker {
  static bool hasWon(List<List<String>> board, String player) {
    return _checkHorizontal(board, player) ||
        _checkVertical(board, player) ||
        _checkDiagonalDown(board, player) ||
        _checkDiagonalUp(board, player);
  }
// Horizontal
  static bool _checkHorizontal(List<List<String>> board, String player) {
    for (int row = 0; row < GameConstants.rows; row++) {
      for (int col = 0; col <= GameConstants.cols - 4; col++) {
        if (board[row][col] == player &&
            board[row][col + 1] == player &&
            board[row][col + 2] == player &&
            board[row][col + 3] == player) {
          return true;
        }
      }
    }
    return false;
  }
  // Vertical
  static bool _checkVertical(List<List<String>> board, String player) {
    for (int row = 0; row <= GameConstants.rows - 4; row++) {
      for (int col = 0; col < GameConstants.cols; col++) {
        if (board[row][col] == player &&
            board[row + 1][col] == player &&
            board[row + 2][col] == player &&
            board[row + 3][col] == player) {
          return true;
        }
      }
    }
    return false;
  }
  //Diagonal downright
  static bool _checkDiagonalDown(List<List<String>> board, String player) {
    for (int row = 0; row <= GameConstants.rows - 4; row++) {
      for (int col = 0; col <= GameConstants.cols - 4; col++) {
        if (board[row][col] == player &&
            board[row + 1][col + 1] == player &&
            board[row + 2][col + 2] == player &&
            board[row + 3][col + 3] == player) {
          return true;
        }
      }
    }
    return false;
  }
  // Diagonal upright
  static bool _checkDiagonalUp(List<List<String>> board, String player) {
    for (int row = 3; row < GameConstants.rows; row++) {
      for (int col = 0; col <= GameConstants.cols - 4; col++) {
        if (board[row][col] == player &&
            board[row - 1][col + 1] == player &&
            board[row - 2][col + 2] == player &&
            board[row - 3][col + 3] == player) {
          return true;
        }
      }
    }
    return false;
  }

  static bool isDraw(List<List<String>> board) {
    for (int col = 0; col < GameConstants.cols; col++) {
      if (board[0][col] == GameConstants.empty) return false;
    }
    return true;
  }
}

// This shows the connect 4 game state and logic
class GameModel {
  List<List<String>> board = List.generate(
    GameConstants.rows,
    (_) => List.filled(GameConstants.cols, GameConstants.empty),
  );

  bool isHumanTurn = true; // Find whose turn
  bool gameEnded = false; // Indicate when the gane has ended
  String? winner; // Store the winner of the game
  String difficulty; // Difficulty level for ai
  int aiTurnCount = 0;
  // Store every move so then olly we can undo
  List<Move> moveHistory = [];
  late AiLogic ai;
  //Set the game model with difficulty level
  GameModel({required this.difficulty}) {
    ai = AiLogic(model: this);
  }

  // Handles the player when tapping a column
  void handleColumnTap(int col) {
    if (gameEnded || !isHumanTurn) return;
    if (!isValidMove(col)) return;
    int row = getNextOpenRow(col);
    if (row == -1) return;
    board[row][col] = GameConstants.human;
    moveHistory.add(Move(row: row, col: col, player: GameConstants.human));
    if (WinChecker.hasWon(board, GameConstants.human)) {
      winner = GameConstants.human;
      gameEnded = true;
      return;
    }
    if (WinChecker.isDraw(board)) {
      winner = null;
      gameEnded = true;
      return;
    }
    isHumanTurn = false;
  }

  // Trigger AI move
  void makeComputerMove() {
    if (gameEnded) return;
    ai.makeMove();
  }

  // Check if move is valid
  bool isValidMove(int col) {
    if (col < 0 || col >= GameConstants.cols) return false;
    return board[0][col] == GameConstants.empty;
  }

// Check whether board is full
bool isBoardFull() {
  return WinChecker.isDraw(board);
}

// Check whether a player has won
bool checkWinner(String player) {
  return WinChecker.hasWon(board, player);
}

  // Find lowest empty row in column
  int getNextOpenRow(int col) {
    for (int row = GameConstants.rows - 1; row >= 0; row--) {
      if (board[row][col] == GameConstants.empty) return row;
    }
    return -1;
  }

  // Get list of all valid columns
  List<int> getValidColumns() {
    List<int> valid = [];
    for (int col = 0; col < GameConstants.cols; col++) {
      if (isValidMove(col)) valid.add(col);
    }
    return valid;
  }

  // Undo last full turn
  void undoLastMove() {
    if (moveHistory.isEmpty) return;

    if (moveHistory.last.player == GameConstants.computer) {
      Move last = moveHistory.removeLast();
      board[last.row][last.col] = GameConstants.empty;
    }

    if (moveHistory.isNotEmpty &&
        moveHistory.last.player == GameConstants.human) {
      Move last = moveHistory.removeLast();
      board[last.row][last.col] = GameConstants.empty;
    }

    gameEnded = false;
    winner = null;
    isHumanTurn = true;
  }
}