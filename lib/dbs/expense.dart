import 'dart:async';

import 'package:expense/models/expense_model.dart';
import 'package:expense/utils/month.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class ExpenseDb{
  Database? dbs;

  ExpenseDb();



  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));
    return dbs;
  }

  Future addData(ExpenseModel expense)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    await store.add(db, expense.toMap());

    await db.close();
  }


  Future retrieveData({int? month})async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

     var keys = await store.findKeys(db, finder: Finder(filter: Filter.equals('month', month??Month().currentMonthNumber)));

     var data = await store.records(keys).get(db);
     await db.close();

     return data;
  }


  Future retrieveBasedOn({List<Filter>? filters})async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

     var keys = await store.findKeys(db, finder: Finder(filter: Filter.and(filters!)));//equals('month', month??Month().currentMonthNumber)));

     var data = await store.records(keys).get(db);
     await db.close();

     return data;
  }


  Future updateData(ExpenseModel expense)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    await store.update(db, expense.toMap(), finder: Finder(filter: Filter.equals('id', expense.id)));
    await db.close();
  }

  Future<Map> deleteData(ExpenseModel expense)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    var r =await store.find(db, finder: Finder(filter: Filter.equals('id', expense.id)));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', expense.id)));
    await db.close();
    
    return r.first.value;
    
  }
  

  var expensesTransformer = StreamTransformer<
      List<RecordSnapshot<int, Map<String, Object?>>>,
      List<ExpenseModel>>.fromHandlers(handleData: (snapshotList, sink) {
        List<ExpenseModel> expenses = snapshotList.map((e) => ExpenseModel.fromMap(e.value)).toList();
    sink.add(expenses);
  });

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


  Stream<List<ExpenseModel>> onExpenses(Database db, {int? month}){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query(finder: Finder(filter: Filter.equals('month', month??Month().currentMonthNumber)));
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => ExpenseModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
