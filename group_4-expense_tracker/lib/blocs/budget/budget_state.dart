part of 'budget_bloc.dart';

enum BStatus {
  initial,
  loading,
  loaded,
  error,
}

class BudgetsState extends Equatable {
  final List<Budget> budgetsList;
  final BStatus status;
  final String error;

  BudgetsState({
    required this.budgetsList,
    required this.status,
    required this.error,
  });

  factory BudgetsState.initial() {
    return BudgetsState(
      budgetsList: [],
      status: BStatus.initial,
      error: '',
    );
  }

  @override
  List<Object> get props => [
        budgetsList,
        status,
        error,
      ];

  BudgetsState copyWith({
    List<Budget>? budgetsList,
    BStatus? status,
    String? error,
  }) {
    return BudgetsState(
      budgetsList: budgetsList ?? this.budgetsList,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
