import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../constants/colors.dart';
import '../dialogs/add_transaction_dialog.dart';
import 'package:hive/hive.dart';

class TransactionTile extends StatelessWidget {
  final FinanceTransaction transaction;
  final int index;

  const TransactionTile({super.key, required this.transaction, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: ListTile(
        leading: Icon(
          transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.isIncome ? Colors.green : AppColors.red,
        ),
        title: Text(
          transaction.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Text(
    //   transaction.category,
    //   style: const TextStyle(fontWeight: FontWeight.w500),
    // ),
    const SizedBox(height: 4),
    Text(
      transaction.description,
      style: const TextStyle(fontSize: 13, color: Colors.grey),
    ),
    const SizedBox(height: 2),
    Text(
      '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
      style: const TextStyle(fontSize: 12, color: Colors.grey),
    ),
  ],
),
        
        
        
        
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${transaction.isIncome ? '+' : '-'} \$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: transaction.isIncome ? Colors.green : AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AddTransactionDialog(
                    existingTransaction: transaction,
                    index: index,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () {
                Hive.box<FinanceTransaction>('transactions').deleteAt(index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
