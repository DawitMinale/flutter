import 'package:expense_app/models/models.dart';
// import 'package:expense_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'budget_item.dart';

class BudgetList extends StatelessWidget {
  final List<Budget> _budgets;
  final Function _deleteBudget;
  final Function _editBudget;

  BudgetList({List<Budget>? budgets, Function? deleteBudget, Function? editBudget})
      : _budgets = budgets!,
        _deleteBudget = deleteBudget!,
        _editBudget = editBudget!;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == _budgets.length) {
          return SizedBox(height: 75.0);
        }
        if (index != 0 && index % 3 == 0 && _budgets.length > 4) {
          return Column(
            children: [
              BudgetItem(
                  budget: _budgets[index],
                  deleteBudget: _deleteBudget,
                  editBudget: _editBudget),
              // BannerAdWidget(),
            ],
          );
        }
        return BudgetItem(
            budget: _budgets[index],
            deleteBudget: _deleteBudget,
            editBudget: _editBudget);
      },
      itemCount: _budgets.length + 1,
    );
  }
}
