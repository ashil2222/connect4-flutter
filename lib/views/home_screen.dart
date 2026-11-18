import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildDisc(Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacer(flex: 2),

            // Decorative discs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDisc(Colors.green),
                const SizedBox(width: 10),
                _buildDisc(Colors.red),
                const SizedBox(width: 10),
                _buildDisc(Colors.green),
                const SizedBox(width: 10),
                _buildDisc(Colors.red),
              ],
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'CONNECT',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const Text(
              '4',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),

            const Spacer(),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/difficulty'),
                    child: const Text(
                      'Play Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 50),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/scoreboard'),
                    child: const Text(
                      'Score Board',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}