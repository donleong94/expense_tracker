import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/category/category_state.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _category;
  double? _amount;
  DateTime _selectedDate = DateTime.now();
  String? _note;

  @override
  Widget build(BuildContext context) {
    final expenseBloc = context.read<ExpenseBloc>();

    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return CircularProgressIndicator();
                  } else if (state is CategoryLoaded) {
                    return DropdownButtonFormField<String>(
                      value: _category,
                      hint: Text('Select Category'),
                      items: state.categories.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name ?? ''))).toList(),
                      onChanged: (value) => setState(() => _category = value),
                      validator: (value) => value == null ? 'Required' : null,
                    );
                  } else if (state is CategoryError) {
                    return Text('Failed to load categories');
                  } else {
                    return Container();
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount (RM)'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || double.tryParse(value) == null ? 'Enter valid amount' : null,
                onSaved: (value) => _amount = double.parse(value!),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Note (optional)'),
                onSaved: (value) => _note = value,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final expense = Expense(
                      category: _category!,
                      amount: _amount!,
                      date: _selectedDate,
                      note: _note,
                    );

                    expenseBloc.add(AddExpense(expense));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
