abstract class BudgetEvent {}

class LoadBudget extends BudgetEvent {}

class SetBudget extends BudgetEvent {
  final double amount;

  SetBudget(this.amount);
}
