// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/income_model.dart';

class FirebaseIncomeDb{
  dynamic uid;

  FirebaseIncomeDb({this.uid});

  final CollectionReference incomeCollection = FirebaseFirestore.instance.collection('income');

  ///Takee a list of incomes and aadd them to firestore 
  Future addIncomes(List<IncomeModel> incomes)async{
    for (var income in incomes){
      await addIncome(income);
    }
  }

  ///Takee an expense and aadd them to firestore 
  Future addIncome(IncomeModel income)async{
      await incomeCollection.doc(uid).collection(uid).doc(income.id.toString()).set(income.toMap()).onError((error, stackTrace) => null);
  }


  Future<List<IncomeModel>> getIncomes()async{
    QuerySnapshot<Map<String, dynamic>> incomes = await incomeCollection.doc(uid).collection(uid).get();
    List<IncomeModel> incDocs = incomes.docs.map((e){
      Map<String, dynamic> _data = e.data();
      return IncomeModel.fromMap(_data);
    }).toList();

    return incDocs;
  }

  ///retturns the corresponding expense
  Future update(IncomeModel income)async{
    await incomeCollection.doc(uid).collection(uid).doc(income.id.toString()).update(income.toMap());
  }

  Future delete(IncomeModel income)async{
    await incomeCollection.doc(uid).collection(uid).doc(income.id.toString()).delete();
  }
}