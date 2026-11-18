import 'package:flutter/material.dart';

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // This is the screen for select Easy, Medeium and Hard levels
      appBar: AppBar(
        title: const Text('Choose Difficulty'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context: context,
              title: 'Easy',
              color: Colors.green,
              value: 'easy',
            ),
            const SizedBox(height: 20),
            _buildButton(
              context: context,
              title: 'Medium',
              color: Colors.orange,
              value: 'medium',
            ),
            const SizedBox(height: 20),
            _buildButton(
              context: context,
              title: 'Hard',
              color: Colors.red,
              value: 'hard',
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildButton({
    required BuildContext context,
    required String title,
    required Color color,
    required String value,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/game', arguments: value);
      },
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}