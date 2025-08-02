import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_pfm_app/screens/leaderboard_screen.dart';
import 'package:my_pfm_app/screens/quiz_screen.dart';
import 'models/transaction.dart';
import 'screens/home_screen.dart';
import 'models/quote.dart';

import 'models/quiz_question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // For QuizQuestion model
  Hive.registerAdapter(QuizQuestionAdapter());
  await Hive.openBox<int>('quizPoints');

  //For Quotes model
  Hive.registerAdapter(FinanceTransactionAdapter());
  Hive.registerAdapter(QuoteAdapter());

// For Favorite Quotes
  await Hive.openBox<FinanceTransaction>('transactions');
  await Hive.openBox<Quote>('favorites');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Finance Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          // textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: const HomeScreen(),
        routes: {
          '/quiz': (context) => const QuizScreen(),
          '/leaderboard': (context) => const LeaderboardScreen(),
        });
  }
}
