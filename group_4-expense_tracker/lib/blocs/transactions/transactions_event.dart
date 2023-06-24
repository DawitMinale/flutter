part of 'transactions_bloc.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();

  @override
  List<Object> get props => [];
}

class GetTransactions extends TransactionsEvent {
  final Budget budget;
  const GetTransactions(this.budget);
}

class UpdateTransactions extends TransactionsEvent {
  final List<Transaction> transactions;

  UpdateTransactions({
    required this.transactions,
  });

  @override
  List<Object> get props => [transactions];
}

class AddTransaction extends TransactionsEvent {
  final Budget budget;
  final Transaction transaction;

  AddTransaction({required this.transaction, required this.budget});

  @override
  List<Object> get props => [transaction];
}

class RemoveTransaction extends TransactionsEvent {
  final Budget budget;
  final String transactionID;

  RemoveTransaction({required this.transactionID, required this.budget});

  @override
  List<Object> get props => [transactionID];
}

class UpdateTransaction extends TransactionsEvent {
  final Budget budget;
  final Transaction transaction;

  UpdateTransaction({required this.transaction, required this.budget});

  @override
  List<Object> get props => [transaction];
}
