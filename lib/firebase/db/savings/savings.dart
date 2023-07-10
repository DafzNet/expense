// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/savings_model.dart';


class FirebaseSavingsDb{
  dynamic uid;

  FirebaseSavingsDb({this.uid});

  final CollectionReference savingsCollection = FirebaseFirestore.instance.collection('savings');

  ///Takee a list of incomes and aadd them to firestore 
  Future addSavings(List<TargetSavingModel> savings)async{
    for (var saving in savings){
      await addSaving(saving);
    }
  }

  ///Takee an expense and aadd them to firestore 
  Future addSaving(TargetSavingModel saving)async{
      await savingsCollection.doc(uid).collection(uid).doc(saving.id.toString()).set(saving.toMap()).onError((error, stackTrace) => null);
  }


  Future<List<TargetSavingModel>> getSavings()async{
    QuerySnapshot<Map<String, dynamic>> savings = await savingsCollection.doc(uid).collection(uid).get();
    List<TargetSavingModel> savingsDocs = savings.docs.map((e){
      Map<String, dynamic> _data = e.data();
      return TargetSavingModel.fromMap(_data);
    }).toList();

    return savingsDocs;
  }

  ///retturns the corresponding expense
  Future update(TargetSavingModel saving)async{
    await savingsCollection.doc(uid).collection(uid).doc(saving.id.toString()).update(saving.toMap());
  }

  Future delete(TargetSavingModel saving)async{
    await savingsCollection.doc(uid).collection(uid).doc(saving.id.toString()).delete();
  }
}