import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/models/budget.dart';
import 'package:expense_app/screens/screens.dart';
import 'package:expense_app/widgets/budgets_list.dart';
import 'package:expense_app/widgets/new_budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetScreen extends StatefulWidget {
  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  Future<void> _startAddNewBudget(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => NewBudget.add(),
      isScrollControlled: true,
    );
  }
  Future<void> _editBudget(BuildContext context, Budget budget) async {
    await showModalBottomSheet(
      context: context,
      builder: (_) => NewBudget.edit(budget: budget),
      isScrollControlled: true,
    );
  }
  void _deleteBudget(String budgetId) {
    context.read<BudgetsBloc>().add(
      RemoveBudget(
        budgetID: budgetId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appbar = AppBar(
      title: const Text('Expense Tracker'),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeThemePage(),
                ),
              );
            },
            icon: const Icon(Icons.settings))
      ],
    );

    return Scaffold(
      appBar: _appbar,
      body: SingleChildScrollView(
        child: BlocConsumer<BudgetsBloc, BudgetsState>(
          listener: (context, state) {
            if (state.status == TStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).errorColor,
              ));
            }
          },
          builder: (context, state) {
            if (state.status == TStatus.initial ||
                state.status == TStatus.loading) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return state.budgetsList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'No Budgets Added Yet!',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Image.asset(
                            'assets/images/wallet.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                _appbar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.5,
                        child: BudgetList(
                          budgets:
                              state.budgetsList.reversed.toList(),
                          deleteBudget: _deleteBudget,
                          editBudget: _editBudget
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewBudget(context),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
