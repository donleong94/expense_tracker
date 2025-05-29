import 'package:expense_tracker/utils/app_const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_event.dart';
import 'package:expense_tracker/bloc/expense/expense_state.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:hive/hive.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final Box<Expense> _box = Hive.box<Expense>(AppConst.hiveExpenseKey);
  String? _currentCategory;
  ExpenseSortOption _currentSort = ExpenseSortOption.dateDesc;

  ExpenseBloc()
      : super(
          ExpenseState(
            expenses: [],
            filteredSortedExpenses: [],
            currentCategory: null,
            currentSortOption: ExpenseSortOption.dateDesc,
          ),
        ) {
    on<LoadExpenses>((event, emit) {
      final allExpenses = _box.values.toList();
      final filteredExpenses = _filterExpensesByCategory(allExpenses);
      final sortedExpenses = _sortExpenses(filteredExpenses);

      emit(
        ExpenseState(
          expenses: allExpenses,
          filteredSortedExpenses: sortedExpenses,
          currentCategory: _currentCategory,
          currentSortOption: _currentSort,
        ),
      );
    });

    on<FilterByCategory>((event, emit) {
      _currentCategory = event.category;

      final allExpenses = _box.values.toList();
      final filteredExpenses = _filterExpensesByCategory(allExpenses);
      final sortedExpenses = _sortExpenses(filteredExpenses);

      emit(
        state.copyWith(
          filteredSortedExpenses: sortedExpenses,
          currentCategory: _currentCategory,
        ),
      );
    });

    on<SortExpenses>((event, emit) {
      _currentSort = event.sortOption;

      final allExpenses = _box.values.toList();
      final filteredExpenses = _filterExpensesByCategory(allExpenses);
      final sortedExpenses = _sortExpenses(filteredExpenses);

      emit(
        state.copyWith(
          filteredSortedExpenses: sortedExpenses,
          currentSortOption: _currentSort,
        ),
      );
    });

    on<AddExpense>((event, emit) async {
      await _box.add(event.currentExpense);
      add(LoadExpenses());
    });

    on<DeleteExpense>((event, emit) async {
      await event.currentExpense.delete();
      add(LoadExpenses());
    });

    on<UpdateExpense>((event, emit) async {
      await event.updatedExpense.save();
      add(LoadExpenses());
    });
  }

  List<Expense> _filterExpensesByCategory(List<Expense> expenses) {
    if (_currentCategory == null) {
      return expenses;
    } else {
      return expenses.where((expense) => expense.category == _currentCategory).toList();
    }
  }

  List<Expense> _sortExpenses(List<Expense> expenses) {
    final sorted = [...expenses];

    switch (_currentSort) {
      case ExpenseSortOption.dateDesc:
        sorted.sort((a, b) => b.date.compareTo(a.date));
        break;
      case ExpenseSortOption.dateAsc:
        sorted.sort((a, b) => a.date.compareTo(b.date));
        break;
      case ExpenseSortOption.amountDesc:
        sorted.sort((a, b) => b.amount.compareTo(a.amount));
        break;
      case ExpenseSortOption.amountAsc:
        sorted.sort((a, b) => a.amount.compareTo(b.amount));
        break;
    }

    return sorted;
  }
}
