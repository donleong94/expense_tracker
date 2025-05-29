import 'package:collection/collection.dart';
import 'package:expense_tracker/model/ExpenseChartData.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseChartWidget extends StatefulWidget {
  const ExpenseChartWidget({
    super.key,
    required this.expenseChartData,
  });

  final List<ExpenseChartData> expenseChartData;

  @override
  State<ExpenseChartWidget> createState() => _ExpenseChartWidgetState();
}

class _ExpenseChartWidgetState extends State<ExpenseChartWidget> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final pieSections = widget.expenseChartData.mapIndexed((index, item) {
      final isTouched = index == _touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 120.0 : 90.0;

      const shadows = [
        Shadow(
          color: Colors.black,
          blurRadius: 2,
        ),
      ];

      return PieChartSectionData(
        color: item.color,
        value: item.amount,
        title: item.category,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black45,
          shadows: shadows,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                _touchedIndex = -1;
                return;
              }

              _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 0.0,
        centerSpaceRadius: 60.0,
        sections: pieSections,
      ),
    );
  }
}
