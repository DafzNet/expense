// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/models/fexpertmodel.dart';

class FirebaseFexpertDb{
  dynamic uid;
  dynamic lastFetched;

  FirebaseFexpertDb({this.uid});

  final CollectionReference fexpertCollection = FirebaseFirestore.instance.collection('fexperts');

  // Future addFexpert(FexpertModel fexpert)async{
  //   for (var budget in budgets){
  //     await addBudget(budget);
  //   }
  // }

  
  /// The function `addBudget` adds a budget to a Firestore collection.
  /// 
  /// Args:
  ///   budget (BudgetModel): The budget object that you want to add to the database.
  Future addFexpert(FexpertModel fexpert)async{
      await fexpertCollection.doc(fexpert.id.toString()).set(fexpert.toMap());
  }


  Future<List<FexpertModel>> fetch({List? by})async{
    List<FexpertModel> fs = [];


    if(by != null){
      if (lastFetched != null) {
      final fexperts = await fexpertCollection.where(
          'tagSearch',
          arrayContainsAny: by
        )
      .orderBy('date')
        .startAfter([lastFetched]).limit(15).get();

      lastFetched = fexperts.docs[fexperts.size - 1];

      fs = fexperts.docs.map((e){
        final data = e.data() as Map<String, dynamic>;
        return FexpertModel.fromMap(data);
      }).toList();

    }
    else{
      final fexperts =await fexpertCollection.where(
          'tagSearch',
          arrayContainsAny: by
        )
      .orderBy('date').limit(15).get();
      
      lastFetched = fexperts.docs[fexperts.size - 1];

      fs = fexperts.docs.map((e){
        final data = e.data() as Map<String, dynamic>;
        return FexpertModel.fromMap(data);
      }).toList();
    }
    }else{
      if (lastFetched != null) {
      final fexperts = await fexpertCollection
      .orderBy('date')
        .startAfter([lastFetched]).limit(15).get();

      lastFetched = fexperts.docs[fexperts.size - 1];

      fs = fexperts.docs.map((e){
        final data = e.data() as Map<String, dynamic>;
        return FexpertModel.fromMap(data);
      }).toList();

    }
    else{
      final fexperts =await fexpertCollection
      .orderBy('date').limit(15).get();
      
      lastFetched = fexperts.docs[fexperts.size - 1];

      fs = fexperts.docs.map((e){
        final data = e.data() as Map<String, dynamic>;
        return FexpertModel.fromMap(data);
      }).toList();
    }
    }

    return fs;
    
  }

  ///retturns the corresponding expense
  Future update(FexpertModel fexpert)async{
    await fexpertCollection.doc(fexpert.id.toString()).update(fexpert.toMap());
  }

  Future delete(FexpertModel fexpert)async{
    await fexpertCollection.doc(fexpert.id.toString()).delete();
  }
}