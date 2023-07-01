// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:expense/utils/settings/settings.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';


class SettingsDb{
  Database? dbs;

  SettingsDb();

  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'setting.db'));
    return dbs;
  }

  Future addData(SettingsObj setting)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'setting.db'));
    await store.drop(db);
    await store.add(db, setting.toMap());
    await db.close();
  }


  ///returns a list of all stored budgets
  Future<List<SettingsObj>> retrieveData()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'setting.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     //await db.close();

     print(data);

     return data.map((e) => SettingsObj.fromMap(e as Map<String, dynamic>)).toList(growable: false);
  }


  Future updateData(SettingsObj setting)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'setting.db'));

    await store.update(db, setting.toMap(), finder: Finder(filter: Filter.equals('id', setting.id)));
    //await db.close();
  }


  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'setting.db'));
    await store.drop(db);
  }
}
