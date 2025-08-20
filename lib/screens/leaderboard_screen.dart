import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pointsBox = Hive.box<int>('quizPoints');
    final totalPoints = pointsBox.get('total', defaultValue: 0)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Leaderboard'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Your Total Points',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      '$totalPoints',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
