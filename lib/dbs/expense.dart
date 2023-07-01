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


  Future addExpenses(List<ExpenseModel> expenses)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    List<Map<String, dynamic>>? exps = expenses.map((e) => e.toMap()).toList();

    await store.addAll(db, exps);

    await db.close();
  }


  Future addData(ExpenseModel expense)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    await store.add(db, expense.toMap());
    await db.close();

  }


  Future<List<ExpenseModel>> retrieveData({int? month})async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    var keys = month != null ? await store.findKeys(db, finder: Finder(filter: Filter.equals('month', month))):await store.findKeys(db);

    var data = await store.records(keys).get(db);
    await db.close();

    return data.map((e) => ExpenseModel.fromMap(e as Map<String, dynamic>)).toList();
  }


  Future<List<ExpenseModel>> retrieveBasedOn(Filter filter)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    var keys = await store.findKeys(db, finder: Finder(filter: filter));//equals('month', month??Month().currentMonthNumber)));

    var data = await store.records(keys).get(db);
    await db.close();

    return data.map((e) => ExpenseModel.fromMap(e as Map<String, dynamic>)).toList();
  }


  Future updateData(ExpenseModel expense)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    await store.update(db, expense.toMap(), finder: Finder(filter: Filter.equals('id', expense.id)));
    await db.close();
  }

  Future deleteData(ExpenseModel expense)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', expense.id)));
    await db.close();
    
  }

  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'expense.db'));
    await store.drop(db);
  }
  

  var expensesTransformer = StreamTransformer<
      List<RecordSnapshot<int, Map<String, Object?>>>,
      List<ExpenseModel>>.fromHandlers(handleData: (snapshotList, sink) {
        List<ExpenseModel> expenses = snapshotList.map((e) => ExpenseModel.fromMap(e.value)).toList();
    sink.add(expenses);
  });


  Stream<List<ExpenseModel>> onExpenses(Database db, {int? month}){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query(finder: Finder(filter: Filter.and([
      Filter.equals('month', month??Month().currentMonthNumber),
      Filter.equals('year', DateTime.now().year)
    ])));
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => ExpenseModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
