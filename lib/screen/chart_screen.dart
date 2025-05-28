import 'package:expense_tracker/screen/expense_chart_widget.dart';
import 'package:flutter/material.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Expense Chart')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ExpenseChartWidget(),
      ),
    );
  }
}