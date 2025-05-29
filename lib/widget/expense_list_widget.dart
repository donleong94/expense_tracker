import 'package:expense_tracker/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_event.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/screen/expense_form_screen.dart';
import 'package:expense_tracker/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpenseListWidget extends StatelessWidget {
  const ExpenseListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseBloc = context.read<ExpenseBloc>();
    final List<Expense> expenseList = expenseBloc.state.filteredSortedExpenses;

    return ListView.builder(
      itemCount: expenseList.length,
      itemBuilder: (context, index) {
        final expenseItem = expenseList[index];

        return ListTile(
          title: Text('${expenseItem.category}: ${expenseItem.amount.toRmCurrency}'),
          subtitle: Text('${expenseItem.formattedDate}${expenseItem.formattedNote}'),
          trailing: GestureDetector(
            child: Icon(Icons.delete),
            onTap: () {
              expenseBloc.add(DeleteExpense(expenseItem));
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ExpenseFormScreen(
                  isEdit: true,
                  expenseItem: expenseItem,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
