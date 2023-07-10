// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:expense/models/plan_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/version.dart';


class PlannerDb{
  Database? dbs;

  PlannerDb();

  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'planner.db'));
    return dbs;
  }

  Future addData(PlannerModel planner)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner.db'));

    await store.add(db, planner.toMap());
    await updateDbVersion(plannerDbVersion: 1);
    await db.close();
  }


  ///returns a list of all stored budgets
  Future<List<PlannerModel>> retrieveData()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data.map((e) => PlannerModel.fromMap(e as Map<String, dynamic>)).toList();
  }


  Future addPlanners(List<PlannerModel> planners)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner.db'));

    List<Map<String, dynamic>>? _planners = planners.map((e) => e.toMap()).toList();

    await store.addAll(db, _planners);
    await updateDbVersion(plannerDbVersion: 1);

    await db.close();
  }



  Future<List<PlannerModel>> retrieveBasedOn(Filter filter)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner.db'));

    var keys = await store.findKeys(db, finder: Finder(filter: filter));

    var data = await store.records(keys).get(db);
    await db.close();

    return data.map((e) => PlannerModel.fromMap(e as Map<String, dynamic>)).toList();
  }



  Future updateData(PlannerModel planner)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner.db'));

    await store.update(db, planner.toMap(), finder: Finder(filter: Filter.equals('id', planner.id)));
    await updateDbVersion(plannerDbVersion: 1);
    await db.close();
  }



  Future deleteData(PlannerModel planner)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner.db' ));

    
    await store.delete(db, finder: Finder(filter: Filter.equals('id', planner.id)));
    await updateDbVersion(plannerDbVersion: 1);
    await db.close();
  }


  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner.db'));
    await store.drop(db);
  }


  Stream<List<PlannerModel>> onPlanners(Database db, {int? month}){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query();
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => PlannerModel.fromMap(e.value)).toList(growable: false));
    return subscription;
  }
}
