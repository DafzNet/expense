import 'dart:async';
import 'package:expense/utils/month.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/budget.dart';

class ExpenseDb{
  Database? dbs;

  ExpenseDb();



  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));
    return dbs;
  }

  Future addData(Map<String, dynamic>data)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

    await store.add(db, data);

    await db.close();
  }

  Future retrieveData()async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data;
  }


  Future updateData(Map<String, dynamic>newData, id)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

    await store.update(db, newData, finder: Finder(filter: Filter.equals('id', id)));
    await db.close();
  }

  Future<Map> deleteData(id)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

    var r =await store.find(db, finder: Finder(filter: Filter.equals('id', id)));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', id)));
    await db.close();
    
    return r.first.value;

    
  }
  

  // var BudgetTransformer = StreamTransformer<
  //     List<RecordSnapshot<int, Map<String, Object?>>>,
  //     List<BudgetModel>>.fromHandlers(handleData: (snapshotList, sink) {
  //       List<BudgetModel> budgets = snapshotList.map((e) => BudgetModel.fromMap(e.value)).toList();
  //   sink.add(budgets);
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


  Stream<List<BudgetModel>> onExpenses(Database db, {int? month}){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query(finder: Finder(filter: Filter.equals('month', month??Month().currentMonthNumber)));
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => BudgetModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
