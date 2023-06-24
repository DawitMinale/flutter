import 'package:expense_app/blocs/app_blocs.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/widgets/report.dart';
import 'package:expense_app/widgets/report_detail.dart';
import 'package:expense_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionScreen extends StatefulWidget {
  final Budget budget;
  const TransactionScreen(this.budget);
  @override
  _TransactionScreenState createState() => _TransactionScreenState(budget);
}

class _TransactionScreenState extends State<TransactionScreen> {
  final Budget budget;
  _TransactionScreenState(this.budget);
  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => NewTransaction.add(budget: budget),
      isScrollControlled: true,
    );
  }

  bool _showBarChart = true;

  @override
  Widget build(BuildContext context) {
    AppBar _appbar = AppBar(
      title: Text(budget.title),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReportDetail(budget: budget, transactions: context.read<TransactionsBloc>().state.transactionsList))), child: const Text('Report'))
      ],
    );

    return Scaffold(
      appBar: _appbar,
      body: SingleChildScrollView(
        child: BlocConsumer<TransactionsBloc, TransactionsState>(
          listener: (context, state) {
            if (state.status == TStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ));
            }
          },
          builder: (context, state) {
            if (state.status == TStatus.initial ||
                state.status == TStatus.loading) {
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return state.transactionsList.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'No Transactions Added Yet!',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
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
                        child: GestureDetector(
                          onHorizontalDragEnd: (details) {
                            int sensitivity = 8;
                            if (details.primaryVelocity! > sensitivity ||
                                details.primaryVelocity! < -sensitivity) {
                              setState(() {
                                _showBarChart = !_showBarChart;
                              });
                            }
                          },
                          child: _showBarChart
                              ? Report(
                                  budget: budget,
                                  transactions: state.transactionsList)
                              : WeekPieChart(
                                  transactions: state.transactionsList,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: (MediaQuery.of(context).size.height -
                                _appbar.preferredSize.height -
                                MediaQuery.of(context).padding.top) *
                            0.5,
                        child: TransactionList(
                          budget: budget,
                          transactions:
                              state.transactionsList.reversed.toList(),
                          deleteTransaction: (String transactionID) {
                            context.read<TransactionsBloc>().add(
                              RemoveTransaction(
                                transactionID: transactionID,
                                budget: budget
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
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
