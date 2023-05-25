import 'package:expense/dbs/expense.dart';
import 'package:expense/models/expense_model.dart';
import 'package:flutter/foundation.dart';


class ExpenseProvider with ChangeNotifier{

  ExpenseProvider(){
    getDBTotal();
  }


  final ExpenseDb expenseDb = ExpenseDb();


  double totalExpenseAmnt = 0;

  void getDBTotal()async{
    double bal = 0;
    List exps = await expenseDb.retrieveData();

    List<ExpenseModel> allExps = exps.map(
        (e) => ExpenseModel.fromMap(e)
      ).toList();

    for (var e in allExps) {
      bal += e.amount;
    }

    totalExpenseAmnt = bal;
  }


  void add(double value)async{
    totalExpenseAmnt += value;

    notifyListeners();
  }


  void subtract(double value)async{

    totalExpenseAmnt -= value;
    notifyListeners();
  }




}