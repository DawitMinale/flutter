part of 'budget_bloc.dart';

abstract class BudgetsEvent extends Equatable {
  const BudgetsEvent();

  @override
  List<Object> get props => [];
}

class GetBudgets extends BudgetsEvent {
  GetBudgets();
}

class UpdateBudgets extends BudgetsEvent {
  final List<Budget> budgets;

  UpdateBudgets({
    required this.budgets,
  });

  @override
  List<Object> get props => [budgets];
}

class AddBudget extends BudgetsEvent {
  final Budget budget;

  AddBudget({required this.budget});

  @override
  List<Object> get props => [budget];
}

class RemoveBudget extends BudgetsEvent {
  final String budgetID;

  RemoveBudget({required this.budgetID});

  @override
  List<Object> get props => [budgetID];
}

class UpdateBudget extends BudgetsEvent {
  final Budget budget;

  UpdateBudget({required this.budget});

  @override
  List<Object> get props => [budget];
}
