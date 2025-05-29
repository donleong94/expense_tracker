import 'package:expense_tracker/bloc/expense/expense_event.dart';
import 'package:expense_tracker/model/expense.dart';

class ExpenseState {
  final List<Expense> expenses;
  final List<Expense> filteredSortedExpenses;

  final String? currentCategory;
  final ExpenseSortOption currentSortOption;

  ExpenseState({
    required this.expenses,
    required this.filteredSortedExpenses,
    required this.currentCategory,
    required this.currentSortOption,
  });

  ExpenseState copyWith({
    List<Expense>? expenses,
    List<Expense>? filteredSortedExpenses,
    String? currentCategory,
    ExpenseSortOption? currentSortOption,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      filteredSortedExpenses: filteredSortedExpenses ?? this.filteredSortedExpenses,
      currentCategory: currentCategory ?? this.currentCategory,
      currentSortOption: currentSortOption ?? this.currentSortOption,
    );
  }
}
