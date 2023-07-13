// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/expense_model.dart';

class FirebaseExpenseDb{
  dynamic uid;

  FirebaseExpenseDb({this.uid});

  final fsExpenseDb = FirebaseFirestore.instance;

  ///Takee a list of expenses and aadd them to firestore 
  Future<void> addExpenses(List<ExpenseModel> expenses)async{
    //final CollectionReference expenseCollection = fsExpenseDb.collection('expense');
    for (var expense in expenses){
      await addExpense(expense);
    }
  }

  ///Takee an expense and aadd them to firestore 
  Future<ExpenseModel> addExpense(ExpenseModel expense)async{
    final CollectionReference expenseCollection = fsExpenseDb.collection('expense');
      await expenseCollection.doc(uid).collection(uid).doc(expense.id.toString())
        .get().then((value)async{
          if (!value.exists){
            await expenseCollection.doc(uid).collection(uid).doc(expense.id.toString()).set(expense.toMap()).onError((error, stackTrace) => null);
          }
        });
      return expense;
  }


  Future<List<ExpenseModel>> getExpenses()async{
    final CollectionReference expenseCollection = fsExpenseDb.collection('expense');
    QuerySnapshot<Map<String, dynamic>> exps = await expenseCollection.doc(uid).collection(uid).get();
    List<ExpenseModel> expDocs = exps.docs.map((e){
      Map<String, dynamic> _data = e.data();
      return ExpenseModel.fromMap(_data);
    }).toList();

    return expDocs;

  }

  ///retturns the corresponding expense
  Future update(ExpenseModel expense)async{
    final CollectionReference expenseCollection = fsExpenseDb.collection('expense');
    await expenseCollection.doc(uid).collection(uid).doc(expense.id.toString()).update(expense.toMap());
  }


  Future delete(ExpenseModel expense)async{
    final CollectionReference expenseCollection = fsExpenseDb.collection('expense');
    await expenseCollection.doc(uid).collection(uid).doc(expense.id.toString()).delete();
  }

}