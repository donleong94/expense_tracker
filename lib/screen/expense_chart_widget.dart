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
        for (var e in state.expenses) {
          grouped[e.category] = (grouped[e.category] ?? 0) + e.amount;
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