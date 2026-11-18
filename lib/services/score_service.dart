import 'package:shared_preferences/shared_preferences.dart';

class ScoreService {
  // Keys for storing scores in SharedPreferences
  static const String _winsKey = 'wins';
  static const String _lossesKey = 'losses';
  static const String _drawsKey = 'draws';

  /// Retrieves the current scores for wins, losses, and draws.
  ///
  /// Returns a [Map] containing the score values with keys: 'wins', 'losses', and 'draws'.
  /// Defaults to 0 for each category if any score havent saved.
  Future<Map<String, int>> getScores() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'wins': prefs.getInt(_winsKey) ?? 0,
      'losses': prefs.getInt(_lossesKey) ?? 0,
      'draws': prefs.getInt(_drawsKey) ?? 0,
    };
  }
  // Increase win count by 1 and update SharedPreferences
  Future<void> incrementWins() async {
    final prefs = await SharedPreferences.getInstance();
    int currentWins = prefs.getInt(_winsKey) ?? 0;
    await prefs.setInt(_winsKey, currentWins + 1);
  }
  // Increase loss count by 1 and update SharedPreferences
  Future<void> incrementLosses() async {
    final prefs = await SharedPreferences.getInstance();
    int currentLosses = prefs.getInt(_lossesKey) ?? 0;
    await prefs.setInt(_lossesKey, currentLosses + 1);
  }
  // Increase darw count by 1 and update SharedPreferences
  Future<void> incrementDraws() async {
    final prefs = await SharedPreferences.getInstance();
    int currentDraws = prefs.getInt(_drawsKey) ?? 0;
    await prefs.setInt(_drawsKey, currentDraws + 1);
  }
  // Reset every scores Win, Losses, Draws to 0 in SharedPreferences
  Future<void> resetScores() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_winsKey, 0);
    await prefs.setInt(_lossesKey, 0);
    await prefs.setInt(_drawsKey, 0);
  }
}