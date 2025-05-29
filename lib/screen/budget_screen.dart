import 'package:expense_tracker/bloc/budget/budget_bloc.dart';
import 'package:expense_tracker/bloc/budget/budget_event.dart';
import 'package:expense_tracker/bloc/budget/budget_state.dart';
import 'package:expense_tracker/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<BudgetBloc>().add(LoadBudget());
  }

  @override
  Widget build(BuildContext context) {
    final budgetBloc = context.read<BudgetBloc>();

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

                return Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Monthly Budget (RM)'),
                      ),
                      TextFormField(
                        controller: _controller,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) => value == null || double.tryParse(value) == null ? 'Enter a valid budget amount' : null,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                      ),
                      20.heightBox,
                      ElevatedButton(
                        child: Text('Save'),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final value = double.tryParse(_controller.text);
                            budgetBloc.add(SetBudget(value ?? 0.0));
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
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
}
