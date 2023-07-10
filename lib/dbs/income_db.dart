// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/income_model.dart';
import '../models/version.dart';
import '../utils/month.dart';

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
    await updateDbVersion(incomeDbVersion: 1);

    await db.close();
  }

  Future<List<IncomeModel>> retrieveData()async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     //await db.close();

     return data.map((e) => IncomeModel.fromMap(e as Map<String, dynamic>)).toList();
  }


  Future updateData(IncomeModel income)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

    await store.update(db, income.toMap(), finder: Finder(filter: Filter.equals('id', income.id)));
    await updateDbVersion(incomeDbVersion: 1);
    await db.close();
  }

  Future deleteData(IncomeModel income)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', income.id)));
    await updateDbVersion(incomeDbVersion: 1);
    await db.close();
  }


  Future addIncomes(List<IncomeModel> incomes)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

    List<Map<String, dynamic>>? _incomes = incomes.map((e) => e.toMap()).toList();

    await store.addAll(db, _incomes);
    await updateDbVersion(incomeDbVersion: 1);

    await db.close();
  }



  Future<List<IncomeModel>> retrieveBasedOn(Filter filter)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));

    var keys = await store.findKeys(db, finder: Finder(filter: filter));

    var data = await store.records(keys).get(db);
    //await db.close();

    return data.map((e) => IncomeModel.fromMap(e as Map<String, dynamic>)).toList();
  }




  Future<dynamic> wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'income.db'));
    await store.drop(db);
  }


  Stream<List<IncomeModel>> onIncome(Database db){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query(
      finder: Finder(
        filter: Filter.and(
          [
            Filter.equals('month', Month().currentMonthNumber),
            Filter.equals('year', DateTime.now().year),
          ]
        )
      )
    );
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => IncomeModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
