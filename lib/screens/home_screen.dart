// lib/screens/home_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_pfm_app/constants/colors.dart';
import 'package:my_pfm_app/screens/favorite_quotes_screen.dart';
import 'package:my_pfm_app/widgets/goal_section.dart';
import '../models/transaction.dart';
import '../models/quote.dart';
import 'transaction_screen.dart';
import '../widgets/quote_rotator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<FinanceTransaction>('transactions');

    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
  title: const Text('My PFM Wallet'),
  backgroundColor: AppColors.darkGreen,
  foregroundColor: const Color.fromARGB(255, 244, 245, 241),
  
  actions: [
    IconButton(
      icon: const Icon(Icons.notifications),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No new notifications')),
        );
      },
    ),
    PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      onSelected: (lang) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selected Language: $lang')),
        );
      },
      itemBuilder: (context) => [
        'English',
        'Nepali',
        'Hindi',
        'Spanish',
        'French',
        'Chinese'
      ].map((lang) {
        return PopupMenuItem<String>(
          value: lang,
          child: Text(lang),
        );
      }).toList(),
    ),
  ],
),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.green),
              child: Text('Wise Wallet Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Favorite Quotes'),
              onTap: () {
                // Navigator.pushNamed(context, '/favorites');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const FavoriteQuotesScreen()));
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<FinanceTransaction> box, _) {
          final transactions = box.values.toList();
          double income = 0, expense = 0;
          for (var txn in transactions) {
            txn.isIncome ? income += txn.amount : expense += txn.amount;
          }
          double balance = income - expense;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("\u2728 Daily Motivations",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const QuoteRotator(),
                const SizedBox(height: 20),
                _buildBlackAccountCard(context, balance, income, expense),
                const SizedBox(height: 24),

              // 🎯, Goals Section,
                const GoalSection(),

                const SizedBox(height: 16),

                const Text("\ud83e\uddd0 Quiz of the Day",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                _buildQuizPlaceholder(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBlackAccountCard(
      BuildContext context, double balance, double income, double expense) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransactionScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF404040),
                Color(0xFF1A1A1A), 
                Color(0xFF4A4A4A),
                ],
                stops: [0.1, 0.5, 0.9],
              ),
              boxShadow: [
                BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 3),
                ),
                BoxShadow(
                color: Colors.white.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(-1, -1),
                ),
                BoxShadow(
                color: Colors.white.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(1, 1),
                ),
              ],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Text(
                  "Current Balance",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                ],
              ),
              Icon(Icons.sensors, color: Colors.white70, size: 24),
              ],
            ),
            Text(
              "\£${balance.toStringAsFixed(2)}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _miniCard("+\£${income.toStringAsFixed(2)}", Colors.green),
                const SizedBox(width: 10),
                _miniCard("-\£${expense.toStringAsFixed(2)}", Colors.red),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _actionButton("Add money", Icons.add)),
                const SizedBox(width: 10),
                Expanded(child: _actionButton("Transfer", Icons.send)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _miniCard(String text, Color color) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
      ),
    );
  }

  Widget _actionButton(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.black),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizPlaceholder(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //     content: Text("Quiz feature coming soon!"),
      //   ));
      // },

      onTap: () => Navigator.pushNamed(context, '/quiz'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(2, 3))
          ],
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 234, 237, 239),
              Color.fromARGB(255, 241, 243, 244)
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'Take Today\'s Quiz \u2794',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green),
        ),
      ),
    );
  }
}
