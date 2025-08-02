import 'package:hive/hive.dart';
import '../models/transaction.dart';

class HiveService {
  final Box<FinanceTransaction> _box = Hive.box<FinanceTransaction>('transactions');

  void addTransaction(FinanceTransaction txn) {
    _box.add(txn);
  }

  List<FinanceTransaction> getAllTransactions() {
    return _box.values.toList();
  }

  void deleteTransaction(int index) {
    _box.deleteAt(index);
  }

  void updateTransaction(int index, FinanceTransaction txn) {
    _box.putAt(index, txn);
  }
}
