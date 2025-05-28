import 'package:expense_tracker/bloc/budget/budget_bloc.dart';
import 'package:expense_tracker/bloc/budget/budget_event.dart';
import 'package:expense_tracker/bloc/budget/budget_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(LoadBudget());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Monthly Budget')),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<BudgetBloc, BudgetState>(
            builder: (context, state) {
              if (state is BudgetLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is BudgetLoaded) {
                _controller.text = state.amount.toStringAsFixed(2);

                return Column(
                  children: [
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(labelText: 'Monthly Budget (RM)'),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveBudget,
                      child: Text('Save'),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  void _saveBudget() {
    final value = double.tryParse(_controller.text);

    if (value != null) {
      context.read<BudgetBloc>().add(SetBudget(value));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid budget amount'),
        ),
      );
    }
  }
}
