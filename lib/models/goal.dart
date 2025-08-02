import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
class Goal extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double targetAmount;

  @HiveField(2)
  double savedAmount;

  Goal({
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
  });
}
