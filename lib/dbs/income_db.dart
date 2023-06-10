import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/income_model.dart';

class IncomeDb{
  Database? dbs;

  IncomeDb();



  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));
    return dbs;
  }

  Future addData(IncomeModel income)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

    await store.add(db, income.toMap());

    await db.close();
  }

  Future retrieveData()async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data;
  }


  Future updateData(IncomeModel income)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

    await store.update(db, income.toMap(), finder: Finder(filter: Filter.equals('id', income.id)));
    await db.close();
  }

  Future<Map> deleteData(IncomeModel income)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

    var r =await store.find(db, finder: Finder(filter: Filter.equals('id', income.id)));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', income.id)));
    await db.close();
    
    return r.first.value;
  }
  

  // var IncomeTransformer = StreamTransformer<
  //     List<RecordSnapshot<int, Map<String, Object?>>>,
  //     List<IncomeModel>>.fromHandlers(handleData: (snapshotList, sink) {
  //       List<IncomeModel> cats = snapshotList.map((e) => IncomeModel.fromMap(e.value as Map<String, dynamic>)).toList();
  //   sink.add(cats);
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


  Stream<List<IncomeModel>> onIncome(Database db){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query();
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => IncomeModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
