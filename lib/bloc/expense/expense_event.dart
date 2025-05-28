import 'package:expense_tracker/model/expense.dart';

abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final Expense expense;

  AddExpense(this.expense);
}

class DeleteExpense extends ExpenseEvent {
  final int index;

  DeleteExpense(this.index);
}

class UpdateExpense extends ExpenseEvent {
  final int index;
  final Expense updatedExpense;

  UpdateExpense(this.index, this.updatedExpense);
}

class FilterByCategory extends ExpenseEvent {
  // Nullable to support "All Categories"
  final String? category;

  FilterByCategory(this.category);
}
