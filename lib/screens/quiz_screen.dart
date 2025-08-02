// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/quiz_questions.dart';
import '../models/quiz_question.dart';
import 'dart:math';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Box<int> _pointsBox;
  late QuizQuestion _currentQuestion;
  int _currentQuestionIndex = 0;
  int? _selectedIndex;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _pointsBox = Hive.box<int>('quizPoints');
    _loadQuestion();
  }

  void _loadQuestion() {
    setState(() {
      _currentQuestion = quizData[_currentQuestionIndex];
      _selectedIndex = null;
      _answered = false;
    });
  }

  void _submitAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
    });

    if (index == _currentQuestion.correctAnswerIndex) {
      int currentPoints = _pointsBox.get('total', defaultValue: 0)!;
      _pointsBox.put('total', currentPoints + 10);
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < quizData.length - 1) {
      _currentQuestionIndex++;
    } else {
      _currentQuestionIndex = 0; // restart the quiz or navigate to summary
    }
    _loadQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final totalPoints = _pointsBox.get('total', defaultValue: 0)!;

    return Scaffold(
      backgroundColor: const Color(0xFFA8E6CF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8E6CF),
        elevation: 0,
        title: Text('Round ${_currentQuestionIndex + 1}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/leaderboard');
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text('$totalPoints',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  Text(
                    _currentQuestion.question,
                    textAlign: TextAlign.center,
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: List.generate(_currentQuestion.options.length, (index) {
                      final isCorrect = index == _currentQuestion.correctAnswerIndex;
                      final isSelected = index == _selectedIndex;

                      Color borderColor = Colors.grey;
                      if (_answered) {
                        if (isCorrect) borderColor = Colors.green;
                        if (isSelected && !isCorrect) borderColor = Colors.red;
                      }

                      return GestureDetector(
                        onTap: () => _submitAnswer(index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              _currentQuestion.options[index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / quizData.length,
                    color: Colors.yellow,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  if (_answered)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: _nextQuestion,
                      child: const Text("Next Question"),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
