
import 'package:expense/dbs/expense.dart';
import 'package:expense/dbs/vault_db.dart';
import 'package:expense/models/expense_model.dart';
import 'package:expense/procedures/expenses/expense_procedure.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import '../../dbs/income_db.dart';
import '../../models/income_model.dart';
import '../../providers/expense_provider.dart';



IncomeDb incomeDb = IncomeDb();
ExpenseDb expenseDb = ExpenseDb();
VaultDb vaultDb = VaultDb();


Future<void> deleteIncomeProcedure(IncomeModel income, context)async{
  //add expense amount back to the
  //its corresponding income before deleting
  List<ExpenseModel> expenses = [];

  Filter filter = Filter.custom((record){
    final data = record.value as Map<String, dynamic>;
    IncomeModel myIncome = IncomeModel.fromMap(data['income']);

    return myIncome == income;
  });


  expenses = await expenseDb.retrieveBasedOn(filter);
  double incomeBal = income.balance;

  ///delte expenses associated with it
  for (var exp in expenses) {
    Provider.of<ExpenseProvider>(context, listen: false).subtract(exp.amount);
    await expenseDb.deleteData(exp);
  }

  double vaultBal = income.incomeVault!.amountInVault;
  var vault = income.incomeVault!.copyWith(
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