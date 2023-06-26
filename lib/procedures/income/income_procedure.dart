
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:expense/dbs/budget_db.dart';
import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/vault_db.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/models/vault.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import '../../dbs/income_db.dart';
import '../../models/budget.dart';
import '../../models/income_model.dart';
import '../../providers/expense_provider.dart';
import '../../utils/month.dart';



IncomeDb incomeDb = IncomeDb();
ExpenseDb expenseDb = ExpenseDb();
VaultDb vaultDb = VaultDb();
BudgetDb budgetDb = BudgetDb();


Future<void> deleteIncomeProcedure(IncomeModel income, context)async{

  List<ExpenseModel> expenses = [];

  Filter filter = Filter.custom((record){
    final data = record.value as Map<String, dynamic>;
    IncomeModel myIncome = IncomeModel.fromMap(data['income']);

    return myIncome == income;
  });

  Filter filterVault = Filter.custom((record){
    final data = record.value as Map<String, dynamic>;
    VaultModel myVault = VaultModel.fromMap(data);

    return myVault == income.incomeVault;
  });


  expenses = await expenseDb.retrieveBasedOn(filter);
  double incomeBal = income.balance;

  ///delte expenses associated with it
  for (var exp in expenses) {

    var budget = await budgetDb.retrieveBasedOn(

      Filter.and(
        [
          Filter.custom((record){
            var bud = record.value as Map<String, dynamic>;
            var _bud = BudgetModel.fromMap(bud);

            return _bud.category == exp.category;

          }),

          Filter.or(
            [
              Filter.and(
                [
                  Filter.equals('month', Month().currentMonthNumber),
                  Filter.equals('year', DateTime.now().year),
                ]
              ),

              Filter.and(
                [
                  Filter.lessThanOrEquals('startDate', exp.date.millisecondsSinceEpoch),
                  Filter.greaterThanOrEquals('endDate', exp.date.millisecondsSinceEpoch)
                ]
              )
            ]
          )
        ]
      )
      
    );

    BudgetModel? expBudget;

    if (budget.isNotEmpty) {
      expBudget = budget.first;
    }

    if (expBudget != null) {
      double newBudgetBal = expBudget.balance + exp.amount;

      expBudget = expBudget.copyWith(
        balance: newBudgetBal
      );

      await budgetDb.updateData(expBudget);
    }


    Provider.of<ExpenseProvider>(context, listen: false).subtract(exp.amount);
    await expenseDb.deleteData(exp);
  }
  //to do
  final v = await vaultDb.retrieveBasedOn(filterVault);
  VaultModel vault = v.first;

  double vaultBal = vault.amountInVault;

  vault = vault.copyWith(
    amountInVault: vaultBal - incomeBal
  );

  await incomeDb.deleteData(income);
  await vaultDb.updateData(vault);
}


Future<void> addIncomeProcedure(IncomeModel income)async{
  
  var vault = income.incomeVault;

  double incomeBal = income.balance;
  double vaultBal = vault!.amountInVault;


  vault = vault.copyWith(
    amountInVault: vaultBal-incomeBal
  );

  await incomeDb.addData(income);
  await vaultDb.updateData(vault);
}