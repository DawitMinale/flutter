import 'dart:io';

import 'package:flutter/material.dart';

import 'package:expense_app/blocs/budget/budget_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:expense_app/extensions/extensions.dart';
import 'package:expense_app/models/models.dart';

enum NewBudgetState {
  edit,
  add,
}

class NewBudget extends StatefulWidget {
  final NewBudgetState state;
  final Budget? budget;

  NewBudget.add({
    Key? key,
  })  : this.state = NewBudgetState.add,
        this.budget = null,
        super(key: key);

  NewBudget.edit({
    Key? key,
    required this.budget,
  })  : this.state = NewBudgetState.edit,
        super(key: key);

  @override
  _NewBudgetState createState() => _NewBudgetState();
}

class _NewBudgetState extends State<NewBudget> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Directory? _appLibraryDirectory;

  @override
  void initState() {
    super.initState();
    _updateDirectory();

    if (widget.state == NewBudgetState.edit) {
      _titleController.text = widget.budget!.title;
      _amountController.text = widget.budget!.amount.toString();
    }
  }

  Future<void> _updateDirectory() async {
    _appLibraryDirectory = await getApplicationDocumentsDirectory();
    _appLibraryDirectory = await _appLibraryDirectory!.create();
  }

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final tBloc = context.read<BudgetsBloc>();
    final budget = Budget(
      id: widget.state == NewBudgetState.add
          ? const Uuid().v4()
          : widget.budget!.id,
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      createdOn: DateTime.now(),
    );
    if (widget.state == NewBudgetState.add) {
      tBloc.add(
        AddBudget(budget: budget),
      );
    } else {
      tBloc.add(
        UpdateBudget(budget: budget),
      );
    }
    Navigator.of(context).pop(budget);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            18,
          ),
        ),
        elevation: 8,
        child: Container(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Title cannot be empty';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    prefixText: getCurrencySymbol(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Amount cannot be empty';
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Please enter numbers only';
                    }
                    if (price <= 0) {
                      return 'Price must be greater than 0';
                    }
                    if (price >= 1000000) {
                      return 'Price must be less than 100,00,00';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(fontSize: 20))),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: _onSubmit,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 20, vertical: 10))
                      ),
                      child: Text(
                        widget.state == NewBudgetState.add
                            ? 'Add Budget'
                            : 'Update',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
