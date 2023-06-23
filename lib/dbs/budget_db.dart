// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:expense/utils/month.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/budget.dart';

class BudgetDb{
  Database? dbs;

  BudgetDb();



  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));
    return dbs;
  }

  Future addData(BudgetModel budget)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

    await store.add(db, budget.toMap());

    await db.close();
  }


  ///returns a list of all stored budgets
  Future<List<BudgetModel>> retrieveData()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data.map((e) => BudgetModel.fromMap(e as Map<String, dynamic>)).toList();
  }


  Future addBudgets(List<BudgetModel> budgets)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

    List<Map<String, dynamic>>? _budgets = budgets.map((e) => e.toMap()).toList();

    await store.addAll(db, _budgets);

    await db.close();
  }



  Future<List<BudgetModel>> retrieveBasedOn(Filter filter)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

    var keys = await store.findKeys(db, finder: Finder(filter: filter));

    var data = await store.records(keys).get(db);
    await db.close();

    return data.map((e) => BudgetModel.fromMap(e as Map<String, dynamic>)).toList();
  }



  Future updateData(BudgetModel budget)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

    await store.update(db, budget.toMap(), finder: Finder(filter: Filter.equals('id', budget.id)));
    await db.close();
  }



  Future deleteData(BudgetModel budget)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', budget.id)));
    await db.close();
  }


  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'budget.db'));
    await store.drop(db);
  }


  Stream<List<BudgetModel>> onBudgets(Database db, {int? month}){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query(
      finder: Finder(
        filter: Filter.or(
          [
            //Filter.and([Filter.equals('month', month??Month().currentMonthNumber), Filter.equals('year', DateTime.now().year)]),
            Filter.custom((record){
              final budg = record.value as Map<String, dynamic>;
              final myBudg = BudgetModel.fromMap(budg);

              if (myBudg.startDate == myBudg.endDate) {
                return myBudg.month == Month().currentMonthNumber && myBudg.year == DateTime.now().year;
              }else{
                return DateTime.now().isAfter(myBudg.startDate!) && DateTime.now().isBefore(myBudg.endDate!);
              }
              
            })
            
          ])));
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => BudgetModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
