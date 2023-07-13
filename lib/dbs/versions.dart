// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/version.dart';


class VersionDb{
  Database? dbs;

  VersionDb();

  Future addData(VersionModel version)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'version.db'));

    await store.add(db, version.toMap());

    await db.close();
  }


  ///returns a list of all stored budgets
  Future<VersionModel> retrieveData()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'version.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data.map((e) => VersionModel.fromMap(e as Map<String, dynamic>)).toList().first;
  }



  Future updateData(VersionModel version)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'version.db'));

    await store.update(db, version.toMap(), finder: Finder(filter: Filter.equals('id', version.id)));
    await db.close();
  }



  Future deleteData(VersionModel version)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'version.db'));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', version.id)));
    await db.close();
  }


  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'version.db'));
    await store.drop(db);
  }
}



