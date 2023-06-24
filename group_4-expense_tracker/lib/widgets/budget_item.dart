import 'package:flutter/material.dart';
import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/extensions/extensions.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/screens/screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class BudgetItem extends StatelessWidget {
  BudgetItem({
    Key? key,
    required Budget budget,
    required Function deleteBudget,
    required Function editBudget
  })  : _budget = budget,
        _deleteBudget = deleteBudget,
        _editBudget = editBudget,
        super(key: key);

  final Budget _budget;
  final Function _deleteBudget;
  final Function _editBudget;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(18),
          ),
          padding: EdgeInsets.only(right: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
           _deleteBudget(_budget.id);
        },
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirm"),
                content:
                    Text("Are you sure you wish to delete this budget?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("DELETE")),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text("CANCEL"),
                  ),
                ],
              );
            },
          );
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(15.0),
          onTap: () {
            context.read<TransactionsBloc>().add(GetTransactions(_budget));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionScreen(_budget),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  _budget.amount.parseCurrency(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _budget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      DateFormat.yMMMd().format(_budget.createdOn),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10.0),
              IconButton(onPressed: () async => await _editBudget(context, _budget), icon: Icon(Icons.edit)),
              const SizedBox(width: 10)
            ],
          ),
        ),
      ),
    );
  }
}
