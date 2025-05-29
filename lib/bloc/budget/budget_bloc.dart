import 'package:expense_tracker/bloc/budget/budget_event.dart';
import 'package:expense_tracker/bloc/budget/budget_state.dart';
import 'package:expense_tracker/core_component/service_locator.dart';
import 'package:expense_tracker/core_component/user_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(BudgetInitial()) {
    on<LoadBudget>((event, emit) async {
      emit(BudgetLoading());
      final totalAmount = getIt<UserPreferences>().getTotalBudget();
      emit(BudgetLoaded(totalAmount));
    });

    on<SetBudget>((event, emit) async {
      final totalAmount = event.amount;
      getIt<UserPreferences>().setTotalBudget(totalAmount);
      emit(BudgetLoaded(totalAmount));
    });
  }
}
