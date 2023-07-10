// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/models/budget.dart';

class FirebaseBudgetDb{
  dynamic uid;

  FirebaseBudgetDb({this.uid});

  final CollectionReference budgetCollection = FirebaseFirestore.instance.collection('budget');

  
  /// The function `addBudgets` takes a list of `BudgetModel` objects and adds each budget to a database
  /// asynchronously.
  /// 
  /// Args:
  ///   budgets (List<BudgetModel>): A list of BudgetModel objects.
  Future addBudgets(List<BudgetModel> budgets)async{
    for (var budget in budgets){
      await addBudget(budget);
    }
  }

  
  /// The function `addBudget` adds a budget to a Firestore collection.
  /// 
  /// Args:
  ///   budget (BudgetModel): The budget object that you want to add to the database.
  Future addBudget(BudgetModel budget)async{
      await budgetCollection.doc(uid).collection(uid).doc(budget.id.toString()).set(budget.toMap()).onError((error, stackTrace) => null);
  }


  Future<List<BudgetModel>> getBudgets()async{
    QuerySnapshot<Map<String, dynamic>> budgets = await budgetCollection.doc(uid).collection(uid).get();
    List<BudgetModel> budgetDocs = budgets.docs.map((e){
      Map<String, dynamic> _data = e.data();
      return BudgetModel.fromMap(_data);
    }).toList();

    return budgetDocs;
  }

  ///retturns the corresponding expense
  Future update(BudgetModel budget)async{
    await budgetCollection.doc(uid).collection(uid).doc(budget.id.toString()).update(budget.toMap());
  }

  Future delete(BudgetModel budget)async{
    await budgetCollection.doc(uid).collection(uid).doc(budget.id.toString()).delete();
  }
}