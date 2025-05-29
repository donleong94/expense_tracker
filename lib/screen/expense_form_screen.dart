import 'package:expense_tracker/bloc/category/category_bloc.dart';
import 'package:expense_tracker/bloc/category/category_state.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/utils/general_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker/bloc/expense/expense_event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({
    super.key,
    required this.isEdit,
    this.expenseItem,
  });

  final bool isEdit;
  final Expense? expenseItem;

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
  void initState() {
    super.initState();

    if (widget.isEdit && widget.expenseItem != null) {
      _category = widget.expenseItem!.category;
      _amount = widget.expenseItem!.amount;
      _selectedDate = widget.expenseItem!.date;
      _note = widget.expenseItem!.note ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final expenseBloc = context.read<ExpenseBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Expense' : 'Add Expense',
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text('Select Category:'),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoading) {
                      return CircularProgressIndicator();
                    } else if (state is CategoryLoaded) {
                      return DropdownButtonFormField<String>(
                        value: _category,
                        items: state.categories.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name ?? ''))).toList(),
                        onChanged: (value) => setState(() => _category = value),
                        validator: (value) => value == null ? 'Required to select' : null,
                      );
                    } else if (state is CategoryError) {
                      return Text('Failed to load categories');
                    } else {
                      return Container();
                    }
                  },
                ),
                40.heightBox,
                Text('Amount (RM):'),
                TextFormField(
                  initialValue: (_amount ?? 0.0).toStringAsFixed(2),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSaved: (value) => _amount = double.parse(value!),
                  validator: (value) => value == null || double.tryParse(value) == null ? 'Enter a valid amount' : null,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                ),
                40.heightBox,
                Text('Date:'),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(DateFormat.yMMMd().format(_selectedDate)),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );

                    if (date != null) {
                      setState(() => _selectedDate = date);
                    }
                  },
                ),
                40.heightBox,
                Text('Note (Optional):'),
                TextFormField(
                  initialValue: _note,
                  onSaved: (value) => _note = value,
                ),
                40.heightBox,
                ElevatedButton(
                  child: Text('Save'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      if (widget.isEdit && widget.expenseItem != null) {
                        widget.expenseItem!.category = _category!;
                        widget.expenseItem!.amount = _amount!;
                        widget.expenseItem!.date = _selectedDate;
                        widget.expenseItem!.note = _note;

                        expenseBloc.add(UpdateExpense(widget.expenseItem!));
                      } else {
                        final expense = Expense(
                          category: _category!,
                          amount: _amount!,
                          date: _selectedDate,
                          note: _note,
                        );

                        expenseBloc.add(AddExpense(expense));
                      }

                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
