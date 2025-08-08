import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 2)
class Goal extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  double current;

  @HiveField(2)
  double target;

  Goal({required this.title, required this.current, required this.target});
}