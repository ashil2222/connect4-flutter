# Connect 4 — Flutter Game

A Connect 4 game built with **Flutter and Dart**, featuring single-player gameplay against a computer opponent with three difficulty levels.

Created for **CSP2108 — Introduction to Mobile Application Development**.

## Features

- **Classic 7 × 6 board** — drop discs into columns and connect four to win.
- **Player vs. computer** — play against an AI opponent.
- **Three difficulty levels**:
  - **Easy:** chooses a random valid move.
  - **Medium:** alternates between random moves and the hard-mode strategy.
  - **Hard:** looks for immediate wins, blocks immediate threats, builds connected lines, and prefers central columns.
- **Win and draw detection** — horizontal, vertical, and diagonal wins.
- **Undo** — undo the previous player/computer moves.
- **Scoreboard** — locally tracks wins, losses, and draws with `shared_preferences`.
- **Reset scores** — clear saved game statistics.

## Tech stack

- Flutter and Dart
- `shared_preferences` for persistent local scores
- `flutter_test` for unit testing

## Project structure

```text
lib/
├── main.dart
├── models/
│   ├── ai_logic.dart
│   └── game_model.dart
├── services/
│   └── score_service.dart
└── views/
    ├── home_screen.dart
    ├── difficulty_screen.dart
    ├── game_screen.dart
    └── scoreboard_screen.dart
assets/images/
    green_disc.png
    red_disc.png
test/
    unit_test.dart
```

## Getting started

1. Install [Flutter](https://docs.flutter.dev/get-started/install) and set up an emulator or device.
2. Clone this repository and open it in your editor.
3. From the project folder, run:

```bash
flutter pub get
flutter run
```

## Running tests

```bash
flutter test
```

The included unit tests cover initial board state, valid/invalid moves, disc placement, win and draw detection, AI moves, undo, and score tracking. The coursework report records these tests as passing; they have not been rerun as part of preparing this repository.

## Game logic

The board is represented using a two-dimensional list with **6 rows and 7 columns**. A move is valid only when the selected column is not full. Each placed disc falls to the lowest available row. The game then checks for four connected discs in horizontal, vertical, or diagonal directions and checks for a full-board draw.

The computer opponent uses rule-based decision logic rather than a trained machine-learning model.

## Screenshots

Add screenshots of the home screen, gameplay, difficulty selection, and scoreboard here once available.

## About

A university mobile application development project focused on Flutter UI, game-state logic, rule-based AI strategies, persistent scores, and unit testing.
