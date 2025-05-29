import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'expense.g.dart';

/// Main model class for an expense.
@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String? note;

  Expense({
    required this.category,
    required this.amount,
    required this.date,
    this.note,
  });

  String get formattedDate {
    return DateFormat.yMMMd().format(date);
  }

  String get formattedNote {
    final tempNote = note ?? '';
    return tempNote.isNotEmpty ? ' - $note' : '';
  }
}
