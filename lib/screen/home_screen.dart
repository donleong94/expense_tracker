import 'package:expense_tracker/bloc/budget/budget_bloc.dart';
import 'package:expense_tracker/bloc/budget/budget_state.dart';
import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/category/category_state.dart';
import 'package:expense_tracker/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_event.dart';
import 'package:expense_tracker/bloc/expense/expense_state.dart';
import 'package:expense_tracker/screen/budget_screen.dart';
import 'package:expense_tracker/screen/chart_screen.dart';
import 'package:expense_tracker/screen/expense_form_screen.dart';
import 'package:expense_tracker/screen/expense_list_widget.dart';
import 'package:expense_tracker/utils/app_const.dart';
import 'package:expense_tracker/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final expenseBloc = context.read<ExpenseBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConst.appTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.pie_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChartScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (expenseContext, expenseState) {
          final selectedCategory = expenseState.currentCategory;

          return Column(
            children: [
              BlocBuilder<BudgetBloc, BudgetState>(
                builder: (budgetContext, budgetState) {
                  if (budgetState is BudgetLoaded) {
                    var totalExpenses = 0.0;
                    totalExpenses = expenseState.expenses.fold<double>(0, (sum, e) => sum + e.amount);

                    final remaining = budgetState.amount - totalExpenses;
                    final isOver = remaining < 0;
                    final isNear = remaining <= budgetState.amount * 0.1 && !isOver;

                    return Card(
                      color: isOver
                          ? Colors.red[100]
                          : isNear
                              ? Colors.orange[100]
                              : Colors.green[100],
                      margin: EdgeInsets.all(16),
                      child: ListTile(
                        title: Text('Budget: ${budgetState.amount.toRmCurrency}'),
                        subtitle: Text(
                          isOver ? 'Over budget by ${(-remaining).toRmCurrency}' : 'Remaining: RM ${remaining.toRmCurrency}',
                          style: TextStyle(
                            color: isOver
                                ? Colors.red
                                : isNear
                                    ? Colors.orange
                                    : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isOver
                                  ? Icons.warning
                                  : isNear
                                      ? Icons.error_outline
                                      : Icons.check_circle,
                              color: isOver
                                  ? Colors.red
                                  : isNear
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                            12.widthBox,
                            GestureDetector(
                              child: Icon(Icons.settings),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => BudgetScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (categoryContext, categoryState) {
                        if (categoryState is CategoryLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          List<String> categoryList = [];

                          if (categoryState is CategoryLoaded) {
                            categoryList = categoryState.categories.map((c) => c.name ?? '').toList();
                          }

                          return DropdownButton<String>(
                            value: selectedCategory,
                            hint: selectedCategory == null ? Text(AppConst.strAllCategories) : Text(selectedCategory ?? ''),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(AppConst.strAllCategories),
                              ),
                              ...categoryList.map((category) {
                                return DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                );
                              }),
                            ],
                            onChanged: (category) {
                              expenseBloc.add(FilterByCategory(category));
                            },
                          );
                        }
                      },
                    ),
                    32.widthBox,
                    Text("Sort by:"),
                    8.widthBox,
                    DropdownButton<ExpenseSortOption>(
                      value: expenseState.currentSortOption,
                      onChanged: (option) {
                        if (option != null) {
                          expenseBloc.add(SortExpenses(option));
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: ExpenseSortOption.dateDesc,
                          child: Text("Date ↓"),
                        ),
                        DropdownMenuItem(
                          value: ExpenseSortOption.dateAsc,
                          child: Text("Date ↑"),
                        ),
                        DropdownMenuItem(
                          value: ExpenseSortOption.amountDesc,
                          child: Text("Amount ↓"),
                        ),
                        DropdownMenuItem(
                          value: ExpenseSortOption.amountAsc,
                          child: Text("Amount ↑"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ExpenseListWidget(
                  expenseList: expenseState.filteredSortedExpenses,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ExpenseFormScreen(isEdit: false)),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
