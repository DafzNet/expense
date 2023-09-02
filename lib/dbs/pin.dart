// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import '../models/pin_model.dart';

class PinDb{
  PinDb();

  Future commit(Pin pin)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'pin.db'));

    await store.add(db, pin.toMap());
    await db.close();
  }



  Future<Pin?> fetch(Pin pin)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'pin.db'));

    var key = await store.findKey(db, finder: Finder(filter: Filter.equals('pin', pin.pin)));

    var data;

    if (key != null) {
      data = await store.record(key).get(db);
      return Pin.fromMap(data);
    } else {
      return null;
    }
  }


  Future update(Pin pin)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'pin.db'));

    await store.update(db, pin.toMap(), finder: Finder(filter: Filter.equals('pin', pin.pin)));
    await db.close();
  }


  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'pin.db'));
    await store.drop(db);
  }
}