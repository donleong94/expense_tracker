import 'dart:math';

import 'package:collection/collection.dart';
import 'package:expense_tracker/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_state.dart';
import 'package:expense_tracker/model/expense_chart_data.dart';
import 'package:expense_tracker/widget/expense_chart_widget.dart';
import 'package:expense_tracker/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Chart'),
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          double totalExpenses = 0.0;
          List<ExpenseChartData> expenseChartData = [];
          final groupedExpenses = <String, double>{};

          for (var expenseItem in state.expenses) {
            totalExpenses += expenseItem.amount;
            groupedExpenses[expenseItem.category] = (groupedExpenses[expenseItem.category] ?? 0.0) + expenseItem.amount;
          }

          groupedExpenses.entries.toList().forEachIndexed((index, item) {
            final randomColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
            final percentage = (item.value / totalExpenses) * 100;

            expenseChartData.add(
              ExpenseChartData(
                category: item.key,
                color: randomColor,
                amount: item.value,
                percentage: percentage,
              ),
            );
          });

          return Column(
            children: [
              Container(
                width: 200,
                height: 200,
                margin: EdgeInsets.fromLTRB(0, 100, 0, 100),
                child: ExpenseChartWidget(
                  expenseChartData: expenseChartData,
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    for (var item in expenseChartData)
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.color,
                          child: Text(item.category.substring(0, 1).toUpperCase()),
                        ),
                        title: Text(
                          '${item.category} (${item.percentage.toStringAsFixed(2)}%)',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        trailing: Text(
                          item.amount.toRmCurrency,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
