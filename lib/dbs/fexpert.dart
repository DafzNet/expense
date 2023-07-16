// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:expense/utils/month.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../models/fexpertmodel.dart';

class FexpertDb{
  Database? dbs;

  FexpertDb();

  Future addData(FexpertModel fexpert)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'fexpert.db'));

    await store.add(db, fexpert.toMap());

    await db.close();
  }


  ///returns a list of all stored budgets
  Future<List<FexpertModel>> retrieveData()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'fexpert.db'));

     var keys = await store.findKeys(db);
     var data = await store.records(keys).get(db);
     await db.close();

     return data.map((e) => FexpertModel.fromMap(e as Map<String, dynamic>)).toList();
  }



  Future<List<FexpertModel>> retrieveBasedOn(Filter filter)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'fexpert.db'));

    var keys = await store.findKeys(db, finder: Finder(filter: filter));

    var data = await store.records(keys).get(db);
    await db.close();

    return data.map((e) => FexpertModel.fromMap(e as Map<String, dynamic>)).toList();
  }



  Future updateData(FexpertModel fexpert)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'fexpert.db'));

    await store.update(db, fexpert.toMap(), finder: Finder(filter: Filter.equals('id', fexpert.id)));
    await db.close();
  }



  Future deleteData(FexpertModel fexpert)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'fexpert.db'));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', fexpert.id)));
    await db.close();
  }


  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'fexpert.db'));
    await store.drop(db);
  }
}
