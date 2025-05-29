import 'package:expense_tracker/model/expense.dart';

enum ExpenseSortOption {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc,
}

abstract class ExpenseEvent {}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final Expense currentExpense;

  AddExpense(this.currentExpense);
}

class DeleteExpense extends ExpenseEvent {
  final Expense currentExpense;

  DeleteExpense(this.currentExpense);
}

class UpdateExpense extends ExpenseEvent {
  final Expense updatedExpense;

  UpdateExpense(this.updatedExpense);
}

class FilterByCategory extends ExpenseEvent {
  // Nullable to support "All Categories"
  final String? category;

  FilterByCategory(this.category);
}

class SortExpenses extends ExpenseEvent {
  final ExpenseSortOption sortOption;

  SortExpenses(this.sortOption);
}
