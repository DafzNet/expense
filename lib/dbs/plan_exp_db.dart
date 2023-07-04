// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:expense/models/plan_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/plan_exp.dart';


class PlannerExpDb{
  Database? dbs;

  PlannerExpDb();



  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'planner_exp.db'));
    return dbs;
  }

  Future addData(PlanExpModel plan)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner_exp.db'));

    await store.add(db, plan.toMap());

    await db.close();
  }


  ///returns a list of all stored budgets
  Future<List<PlanExpModel>> retrieveData()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner_exp.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data.map((e) => PlanExpModel.fromMap(e as Map<String, dynamic>)).toList();
  }


  Future addPlanExps(List<PlanExpModel> plans)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner_exp.db'));

    List<Map<String, dynamic>>? _plans = plans.map((e) => e.toMap()).toList();

    await store.addAll(db, _plans);

    await db.close();
  }



  Future<List<PlanExpModel>> retrieveBasedOn(Filter filter)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner_exp.db'));

    var keys = await store.findKeys(db, finder: Finder(filter: filter));

    var data = await store.records(keys).get(db);
    await db.close();

    return data.map((e) => PlanExpModel.fromMap(e as Map<String, dynamic>)).toList();
  }



  Future updateData(PlanExpModel plan)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner_exp.db'));

    await store.update(db, plan.toMap(), finder: Finder(filter: Filter.equals('id', plan.id)));
    await db.close();
  }



  Future deleteData(PlanExpModel plan)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner_exp.db' ));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', plan.id)));
    await db.close();
  }


  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'planner_exp.db'));
    await store.drop(db);
  }


  Stream<List<PlanExpModel>> onPlanners(Database db, {int? month, PlannerModel? plannerModel}){
    var store = intMapStoreFactory.store(    );
    var storeQuery = store.query(
      finder: Finder(
        filter: Filter.custom((record){
          final data = record.value as Map<String, dynamic>;
          final plan = PlanExpModel.fromMap(data);

          return plan.planner == plannerModel;
        })
      )
    );
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => PlanExpModel.fromMap(e.value)).toList(growable: false));
    return subscription;
  }
}
