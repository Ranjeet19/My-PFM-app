import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../constants/colors.dart';
import '../screens/transaction_screen.dart';

class FinanceCard extends StatelessWidget {
  const FinanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box<FinanceTransaction>('transactions').listenable(),
      builder: (context, Box<FinanceTransaction> box, _) {
        double income = 0;
        double expense = 0;

        for (var txn in box.values) {
          if (txn.isIncome) {
            income += txn.amount;
          } else {
            expense += txn.amount;
          }
        }

        double total = income - expense;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TransactionScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.lightGreen, AppColors.darkGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.white)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _summaryItem(Icons.arrow_downward, 'Income', '+\£${income.toStringAsFixed(2)}', Colors.greenAccent),
                    _summaryItem(Icons.arrow_upward, 'Expense', '-\£${expense.toStringAsFixed(2)}', AppColors.red),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Balance: \£${total.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppColors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _summaryItem(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: AppColors.white)),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
