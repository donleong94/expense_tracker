import 'package:expense_tracker/model/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final List<Expense> filteredExpenses;

  ExpenseState({
    required this.expenses,
    required this.filteredExpenses,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    List<Expense>? filteredExpenses,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      filteredExpenses: filteredExpenses ?? this.filteredExpenses,
    );
  }
}
