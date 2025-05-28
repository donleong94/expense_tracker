import 'package:expense_tracker/utils/app_const.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_event.dart';
import 'package:expense_tracker/bloc/expense/expense_state.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:hive/hive.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final Box<Expense> _box = Hive.box<Expense>(AppConst.hiveExpenseKey);

  ExpenseBloc() : super(ExpenseState(expenses: [], filteredExpenses: [])) {
    on<LoadExpenses>((event, emit) {
      final allExpenses = _box.values.toList();

      emit(
        ExpenseState(
          expenses: allExpenses,
          filteredExpenses: allExpenses,
        ),
      );
    });

    on<AddExpense>((event, emit) async {
      await _box.add(event.expense);
      add(LoadExpenses());
    });

    on<DeleteExpense>((event, emit) async {
      await _box.deleteAt(event.index);
      add(LoadExpenses());
    });

    on<UpdateExpense>((event, emit) async {
      await _box.putAt(event.index, event.updatedExpense);
      add(LoadExpenses());
    });

    on<FilterByCategory>((event, emit) {
      final allExpenses = _box.values.toList();
      final filtered = event.category == null ? allExpenses : allExpenses.where((e) => e.category == event.category).toList();

      emit(
        state.copyWith(
          filteredExpenses: filtered,
        ),
      );
    });
  }
}
