import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/savings_model.dart';

class SavingsDb{

  SavingsDb();

  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    var dbs = await factory.openDatabase(join(appDocumentDir.path, 'savings.db'));
    return dbs;
  }

  Future addData(Map<String, dynamic>data)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'savings.db'));

    await store.add(db, data);

    await db.close();
  }

  Future retrieveData()async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'savings.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data;
  }


  Future updateData(Map<String, dynamic>newData, id)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'savings.db'));

    await store.update(db, newData, finder: Finder(filter: Filter.equals('id', id)));
    await db.close();
  }


  Future<Map> deleteData(id)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'savings.db'));

    var r =await store.find(db, finder: Finder(filter: Filter.equals('id', id)));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', id)));
    await db.close();
    
    return r.first.value;

    
  }
  

  // var expensesTransformer = StreamTransformer<
  //     List<RecordSnapshot<int, Map<String, Object?>>>,
  //     List<ExpenseModel>>.fromHandlers(handleData: (snapshotList, sink) {
  //       List<ExpenseModel> expenses = snapshotList.map((e) => ExpenseModel.fromMap(e.value as Map<String, dynamic>)).toList();
  //   sink.add(expenses);
  // });

  // var noteTransformer = StreamTransformer<
  //     RecordSnapshot<int, Map<String, Object?>>?,
  //     DbNote?>.fromHandlers(handleData: (snapshot, sink) {
  //   sink.add(snapshot == null ? null : snapshotToNote(snapshot));
  // });

  /// Listen for changes on any note
  // Stream<List<ExpenseModel>> onExpenses() {
  //   return notesStore
  //       .query(finder: Finder(sortOrders: [SortOrder('date', false)]))
  //       .onSnapshots(db!)
  //       .transform(notesTransformer);
  // }


  Stream<List<TargetSavingModel>> onSavings(Database db){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query();
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => TargetSavingModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
