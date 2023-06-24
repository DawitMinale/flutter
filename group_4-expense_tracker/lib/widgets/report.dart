import 'package:flutter/material.dart';

import 'package:expense_app/models/models.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Report extends StatefulWidget {
  final Budget budget;
  final List<Transaction> transactions;

  Report({List<Transaction>? transactions, required this.budget}) : transactions = transactions!;

  @override
  State<StatefulWidget> createState() => ReportState();
}

class ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 7,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: Theme.of(context).secondaryHeaderColor,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: MediaQuery.orientationOf(context) == Orientation.portrait
                ? PortraitScreen(transactions: widget.transactions, budget: widget.budget)
                : LandscapeScreen(transactions: widget.transactions, budget: widget.budget),
          ),
        ],
      ),
    );
  }
}

class PortraitScreen extends StatelessWidget {
  final transactions;
  final budget;
  const PortraitScreen({super.key, required this.transactions, required this.budget});

  @override
  Widget build(BuildContext context) {
    double _calculateTotal() {
      if (transactions.isEmpty) {
        return 0;
      }
      double sum = 0;
      for (Transaction transaction in transactions) {
        sum += transaction.amount;
      }
      return sum;
    }

    final total_exp = _calculateTotal();
    final perc = total_exp/budget.amount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          'Budget/Expense Report',
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [                
        Column(
          children: [
            const Text(
              'Total Budget:',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              budget.amount.toString(),
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              'Total Expense:',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              total_exp.toString(),
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ]),
        Column(
          children: [
            const Text(
              'Remaining:',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              (budget.amount - total_exp).toString(),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            LayoutBuilder(
              builder: (context, constraint) {
                final width = constraint.maxWidth;
                return Column(
                  children: [
                    SizedBox(height: width/40),
                    CircularPercentIndicator(
                      radius: width > 800 ? 0.3*width : 0.24 * width,
                      lineWidth: 10,
                      progressColor: Colors.redAccent,
                      backgroundColor: Colors.greenAccent,
                      percent: perc>1 ? 1 : perc,
                      center: Text('${((total_exp/budget.amount)*100).toStringAsPrecision(3)}%', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),),
                    ),
                  ],
                );
              }
            )
          ],
        )
      ],
    );
  }
}

class LandscapeScreen extends StatelessWidget {
  final transactions;
  final budget;
  const LandscapeScreen({super.key, required this.transactions, required this.budget});

  @override
  Widget build(BuildContext context) {
    double _calculateTotal() {
      if (transactions.isEmpty) {
        return 0;
      }
      double sum = 0;
      for (Transaction transaction in transactions) {
        sum += transaction.amount;
      }
      return sum;
    }

    final total_exp = _calculateTotal();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          'Budget/Expense Report',
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [                
        Column(
          children: [
            const Text(
              'Total Budget:',
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              budget.amount.toString(),
              style: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              'Total Expense:',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              total_exp.toString(),
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Column(
          children: [
            const Text(
              'Remaining:',
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              (budget.amount - total_exp).toString(),
              style: const TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
        ]),
      ],
    );
  }
}