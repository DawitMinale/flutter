import 'package:flutter/material.dart';

import 'package:expense_app/extensions/currency_extension.dart';
import '../models/budget.dart';
import '../models/transaction.dart';

class ReportDetail extends StatelessWidget {
  final Budget budget;
  final List<Transaction> transactions;
  const ReportDetail({super.key, required this.budget, required this.transactions});

  @override
  Widget build(BuildContext context) {
    double totExp = 0;
    for (var t in transactions) {
      totExp += t.amount;
    }
    final perc = totExp/budget.amount;
    return Scaffold(
      appBar: AppBar(title: const Text('Report')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Expenses List", style: TextStyle(fontSize: 25)),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  children: [
                  TableCell(child: Text('Title', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
                  TableCell(child: Text('Price', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
                  TableCell(child: Text('Date', textAlign: TextAlign.center, style: TextStyle(fontSize: 18)))
                ]),
                ...transactions.map(
                  (t) => TableRow(children: [
                    TableCell(child: Padding(padding: const EdgeInsets.only(left: 10), child: Text(t.title))),
                    TableCell(child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(t.amount.toString()),
                    )),
                    TableCell(child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('${t.date.day}/${t.date.month}/${t.date.year}'),
                    ))
                  ])
                ).toList()
              ],
            ),
            const SizedBox(height: 10),
            const Text("Summary", style: TextStyle(fontSize: 25)),
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(children: [
                  TableCell(child: Text('Total Budget', textAlign: TextAlign.center)),
                  TableCell(child: Text('Total Expense', textAlign: TextAlign.center)),
                  TableCell(child: Text('Remaining', textAlign: TextAlign.center))
                ]),
                 TableRow(children: [
                  TableCell(child: Text(budget.amount.parseCurrency(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
                  TableCell(child: Text(totExp.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
                  TableCell(child: Text((budget.amount - totExp).toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 18)))
                ])
              ],
            ),
            const SizedBox(height: 10),
            const Text("Suggestion", style: TextStyle(fontSize: 25)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('From your expense data, You have used ${perc < 1 ? (perc*100).toStringAsPrecision(2) : 100}% of you Budget.', style: TextStyle(fontSize: 17)),
            ),
            Text(perc<0.9 ? "You are safe, You can Spend more.":"You are running out of budget.", style: const TextStyle(fontSize: 17)),
          ],
        ),
      ),
    );
  }
}
