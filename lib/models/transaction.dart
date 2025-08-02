import 'package:hive/hive.dart';

part 'transaction.g.dart';
@HiveType(typeId: 0)
class FinanceTransaction extends HiveObject {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final bool isIncome;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String description;

  FinanceTransaction({
    required this.amount,
    required this.isIncome,
    required this.category,
    required this.date,
    required this.description,
  });
}
