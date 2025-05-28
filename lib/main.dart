import 'package:expense_tracker/bloc/budget/budget_bloc.dart';
import 'package:expense_tracker/bloc/budget/budget_event.dart';
import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/category/category_event.dart';
import 'package:expense_tracker/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_event.dart';
import 'package:expense_tracker/core_component/service_locator.dart';
import 'package:expense_tracker/screen/home_screen.dart';
import 'package:expense_tracker/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator
  await startup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ExpenseBloc()..add(LoadExpenses())),
        BlocProvider(create: (_) => CategoryBloc(getIt())..add(LoadCategories())),
        BlocProvider(create: (_) => BudgetBloc()..add(LoadBudget())),
      ],
      child: MaterialApp(
        title: AppConst.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
