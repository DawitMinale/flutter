import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_app/models/models.dart';
import 'package:expense_app/repositories/repositories.dart';

part 'budget_event.dart';
part 'budget_state.dart';

class BudgetsBloc extends Bloc<BudgetsEvent, BudgetsState> {
  final TransactionsRepository _budgetsRepository;

  BudgetsBloc({required TransactionsRepository budgetsRepository})
      : this._budgetsRepository = budgetsRepository,
        super(BudgetsState.initial()) {
    on<BudgetsEvent>(
        (BudgetsEvent event, Emitter<BudgetsState> emit) async {
      if (event is UpdateBudgets) {
        emit(state.copyWith(
            budgetsList: event.budgets, status: BStatus.loaded));
      }
      if (event is GetBudgets) {
        emit(state.copyWith(status: BStatus.loading));
        try {
          final budgets = await _budgetsRepository.loadBudgets();
          add(UpdateBudgets(budgets: budgets));
        } catch (e) {
          emit(state.copyWith(status: BStatus.error, error: e as String));
        }
      }

      if (event is AddBudget) {
        emit(state.copyWith(status: BStatus.loading));
        try {
          final budgets = await _budgetsRepository.addBudget(
              list: state.budgetsList, addB: event.budget);
          add(UpdateBudgets(budgets: budgets));
        } catch (e) {
          emit(state.copyWith(status: BStatus.error, error: e as String));
        }
      }

      if (event is RemoveBudget) {
        emit(state.copyWith(status: BStatus.loading));
        try {
          final budgets = await _budgetsRepository.removeBudget(
              list: state.budgetsList, remTID: event.budgetID);
          add(UpdateBudgets(budgets: budgets));
        } catch (e) {
          emit(state.copyWith(status: BStatus.error, error: e as String));
        }
      }

      if (event is UpdateBudget) {
        emit(state.copyWith(status: BStatus.loading));
        try {
          await _budgetsRepository.updateBudget(
              budget: event.budget);
          final budgets =
              await _budgetsRepository.getAllBudgets();
          add(UpdateBudgets(budgets: budgets));
        } catch (e) {
          emit(state.copyWith(status: BStatus.error, error: e as String));
        }
      }
    });
  }
}
