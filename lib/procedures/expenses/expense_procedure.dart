

import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/vault_db.dart';
import 'package:expense/models/expense_model.dart';
import 'package:sembast/sembast.dart';
import '../../dbs/income_db.dart';



IncomeDb incomeDb = IncomeDb();
ExpenseDb expenseDb = ExpenseDb();
VaultDb vaultDb = VaultDb();


Future<void> deleteExpenseProcedure(ExpenseModel expense)async{
  //add expense amount back to the
  //its corresponding income before deleting

  //For the sake of the income balance being modified from
  //the time this expense was created by other spendings
  //so we will get the current version of this income from the
  //database


  var income = expense.income; //income as of when expense was added
  var vault = income!.incomeVault; //vault as of when expense was added

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

  vault = vault.copyWith(
    amountInVault: vaultBal+expAmnt
  );

  await expenseDb.deleteData(expense);
  await incomeDb.updateData(income);
  await vaultDb.updateData(vault);
}



Future<void> addExpenseProcedure(ExpenseModel expense)async{
  //add expense amount back to the
  //its corresponding income before deleting
  var income = expense.income;
  var vault = income!.incomeVault;

  double incomeBal = income.balance;
  double vaultBal = vault!.amountInVault;
  double expAmnt = expense.amount;

  income = income.copyWith(
    balance: incomeBal-expAmnt
  );

  vault = vault.copyWith(
    amountInVault: vaultBal-expAmnt
  );

  await expenseDb.addData(expense);
  await incomeDb.updateData(income);
  await vaultDb.updateData(vault);
}