import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_pfm_app/screens/leaderboard_screen.dart';
import 'package:my_pfm_app/screens/quiz_screen.dart';
import 'package:provider/provider.dart';

import 'models/transaction.dart';
import 'models/quote.dart';
import 'models/goal.dart';
import 'models/quiz_question.dart';
import 'services/language_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(FinanceTransactionAdapter()); // 0
  Hive.registerAdapter(QuoteAdapter());              // 1
  Hive.registerAdapter(GoalAdapter());               // 2
  Hive.registerAdapter(QuizQuestionAdapter());       // 3

  await Hive.openBox<FinanceTransaction>('transactions');
  await Hive.openBox<Quote>('favorites');
  await Hive.openBox<Goal>('goals');
  await Hive.openBox<int>('quizPoints');

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home:  HomeScreen(),
       routes: {
    '/leaderboard': (context) => const LeaderboardScreen(),
    '/quiz': (context) => const QuizScreen(),

  },
    );
  }
}
