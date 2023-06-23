

// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/category_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/vault_db.dart';
import 'package:expense/models/budget.dart';
import 'package:expense/models/expense_model.dart';
import 'package:sembast/sembast.dart';
import '../../dbs/income_db.dart';
import '../../models/vault.dart';



IncomeDb incomeDb = IncomeDb();
ExpenseDb expenseDb = ExpenseDb();
VaultDb vaultDb = VaultDb();
CategoryDb categoryDb = CategoryDb();
final budgetDb = BudgetDb();


Future<void> deleteExpenseProcedure(ExpenseModel expense)async{
  //add expense amount back to the
  //its corresponding income before deleting

  //For the sake of the income balance being modified from
  //the time this expense was created by other spendings
  //so we will get the current version of this income from the
  //database


  var income = expense.income; //income as of when expense was added
  var vault = income!.incomeVault; //vault as of when expense was added
  var category = expense.category!;

  var budget = await budgetDb.retrieveBasedOn(
    Filter.custom((record){
      var bud = record.value as Map<String, dynamic>;
      var _bud = BudgetModel.fromMap(bud);

      return _bud.category == category;

    })
  );

  BudgetModel? expBudget;

  if (budget.isNotEmpty) {
    expBudget = budget.first;
  }


  var newIncome = await incomeDb.retrieveBasedOn(
    Filter.equals('id', income.id)
  );

  var newVault = await vaultDb.retrieveBasedOn(
    Filter.equals('id', vault!.id)
  );

  income = newIncome.first;
  vault = newVault.isNotEmpty  ? newVault.first : vault;
  

  double incomeBal = income.balance;
  double vaultBal = vault.amountInVault;
  double expAmnt = expense.amount;

  income = income.copyWith(
    balance: incomeBal+expAmnt
  );

  if (expBudget != null) {
    double currentBudgetAmnt = expBudget.balance;
    expBudget = expBudget.copyWith(
      balance: currentBudgetAmnt + expAmnt
    );

    await budgetDb.updateData(expBudget);
  }  

  vault = vault.copyWith(
    amountInVault: vaultBal+expAmnt
  );

  await expenseDb.deleteData(expense);
  await incomeDb.updateData(income);
  await vaultDb.updateData(vault);
}



Future<void> addExpenseProcedure(ExpenseModel expense)async{

  var income = expense.income;
  var category = expense.category!;

  Filter filterVault = Filter.custom((record){
    final data = record.value as Map<String, dynamic>;
    VaultModel myVault = VaultModel.fromMap(data);

    return myVault == income!.incomeVault;
  });


  ////////
  final v = await vaultDb.retrieveBasedOn(filterVault);
  VaultModel vault = v.first;

  final filter = Filter.custom((record){
      var bud = record.value as Map<String, dynamic>;
      var _bud = BudgetModel.fromMap(bud);

      return _bud.category == category;
    });

  var budgets = await budgetDb.retrieveBasedOn(
    filter
  );


  BudgetModel? expBudget;

  if (budgets.isNotEmpty) {
    expBudget = budgets.first;
  }

  double incomeBal = income!.balance;
  double expAmnt = expense.amount;
  double vaultBal = vault.amountInVault;

  vault = vault.copyWith(
    amountInVault: vaultBal - expAmnt
  );

  income = income.copyWith(
    balance: incomeBal-expAmnt
  );

  if (expBudget != null) {
    double currentBudgetAmnt = expBudget.balance;
    expBudget = expBudget.copyWith(
        balance: currentBudgetAmnt - expAmnt
      );

    await budgetDb.updateData(expBudget);
  }


  await expenseDb.addData(expense);
  await incomeDb.updateData(income);
  await vaultDb.updateData(vault);
}