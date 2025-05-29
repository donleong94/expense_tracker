import 'package:flutter/material.dart';

class ExpenseChartData {
  ExpenseChartData({
    required this.category,
    required this.color,
    required this.amount,
    required this.percentage,
  });

  final String category;
  final Color color;
  final double amount;
  final double percentage;
}
