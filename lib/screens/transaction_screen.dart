import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction.dart';
import '../widgets/transaction_tile.dart';
import '../dialogs/add_transaction_dialog.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<FinanceTransaction>('transactions');

    return Scaffold(
      appBar: AppBar(
        title: const Text("My PFM Wallet", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF56AB2F),
      ),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<FinanceTransaction> box, _) {
          final transactions = box.values.toList().reversed.toList();

          double totalIncome = 0;
          double totalExpense = 0;

          for (var txn in transactions) {
            if (txn.isIncome) {
              totalIncome += txn.amount;
            } else {
              totalExpense += txn.amount;
            }
          }

          double netBalance = totalIncome - totalExpense;

          return Container(
            color: const Color(0xFFF1FFF3), // Light mint background
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSummaryCard("Total Income 💰", "+\£${totalIncome.toStringAsFixed(2)}", Colors.green, Icons.check_circle),
                const SizedBox(height: 10),
                _buildSummaryCard("Total Expenses 🧾", "-\£${totalExpense.toStringAsFixed(2)}", Colors.red, Icons.cancel),
                const SizedBox(height: 10),
                _buildSummaryCard("Net Balance 📊", "\£${netBalance.toStringAsFixed(2)}", Colors.black, Icons.balance),
                const SizedBox(height: 24),
                const Text("Recent Transactions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text("Your recent income and expenses.", style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                if (transactions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: Text("No transactions yet.")),
                  )
                else
                  ...transactions.asMap().entries.map((entry) {
                    final txn = entry.value;
                    final index = box.length - 1 - entry.key;
                    return TransactionTile(transaction: txn, index: index);
                  }).toList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white,),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddTransactionDialog(),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: color.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),
                Text(value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    )),
              ],
            ),
          ),
          Icon(icon, color: color),
        ],
      ),
    );
  }
}
