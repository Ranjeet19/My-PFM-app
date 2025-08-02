import 'package:hive/hive.dart';

part 'quote.g.dart';

@HiveType(typeId: 1)
class Quote extends HiveObject {
  @HiveField(0)
  final String text;

  Quote({required this.text});
}
