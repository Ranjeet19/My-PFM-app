import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_pfm_app/models/goal.dart';
import 'package:my_pfm_app/screens/leaderboard_screen.dart';
import 'package:my_pfm_app/screens/quiz_screen.dart';
import 'models/transaction.dart';
import 'screens/home_screen.dart';
import 'models/quote.dart';

import 'models/quiz_question.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive Adapters with UNIQUE typeIds
  Hive.registerAdapter(FinanceTransactionAdapter()); // typeId: 0
  Hive.registerAdapter(QuoteAdapter());              // typeId: 1
  Hive.registerAdapter(QuizQuestionAdapter());       // typeId: 3
  Hive.registerAdapter(GoalAdapter());               // typeId: 2

  // Open Boxes
  await Hive.openBox<FinanceTransaction>('transactions'); // for income/expenses
  await Hive.openBox<Quote>('favorites');                 // for saved quotes
  await Hive.openBox<Goal>('goals');                      // for goal tracking
  await Hive.openBox<int>('quizPoints');    

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
