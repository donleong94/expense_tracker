import 'package:expense_tracker/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseChartWidget extends StatelessWidget {
  const ExpenseChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        final grouped = <String, double>{};

        for (var expenseItem in (state).expenses) {
          grouped[expenseItem.category] = (grouped[expenseItem.category] ?? 0) + expenseItem.amount;
        }

        final pieSections = grouped.entries.map((e) {
          return PieChartSectionData(
            value: e.value,
            title: e.key,
            radius: 50,
          );
        }).toList();

        return PieChart(
          PieChartData(sections: pieSections),
        );
      },
    );
  }
}
