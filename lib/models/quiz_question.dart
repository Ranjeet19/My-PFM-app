import 'package:hive/hive.dart';

part 'quiz_question.g.dart';

@HiveType(typeId: 2)
class QuizQuestion extends HiveObject {
  @HiveField(0)
  String question;

  @HiveField(1)
  List<String> options;

  @HiveField(2)
  int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}
