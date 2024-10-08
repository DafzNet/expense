// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:expense/models/vault.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/version.dart';

class VaultDb{
  Database? dbs;

  VaultDb();

  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));
    return dbs;
  }

  Future addData(VaultModel vault)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));

    await store.add(db, vault.toMap());
    await updateDbVersion(vaultDbVersion: 1);
    await db.close();
  }


  ///returns a list of all stored budgets
  Future<List<VaultModel>> retrieveData()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data.map((e) => VaultModel.fromMap(e as Map<String, dynamic>)).toList();
  }


  Future addVaults(List<VaultModel> vaults)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));

    List<Map<String, dynamic>>? _vaults = [];

    for (var vault in vaults) {
      bool existing =await exists(vault: vault);
      if (!existing) {
        _vaults.add(vault.toMap());
      }
    }

    await store.addAll(db, _vaults);
    await db.close();
  }


  Future<bool> exists({VaultModel? vault})async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));

    var key = await store.findKey(db, finder: Finder(
      filter: Filter.equals('id', vault?.id)
    ));
    return key != null ? true : false;
  }



  Future<List<VaultModel>> retrieveBasedOn(Filter filter)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));

    var keys = await store.findKeys(db, finder: Finder(filter: filter));

    var data = await store.records(keys).get(db);
    await db.close();

    return data.map((e) => VaultModel.fromMap(e as Map<String, dynamic>)).toList();
  }



  Future updateData(VaultModel vault)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));

    await store.update(db, vault.toMap(), finder: Finder(filter: Filter.equals('id', vault.id)));
    await updateDbVersion(vaultDbVersion: 1);
    await db.close();
  }



  Future deleteData(VaultModel vault)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', vault.id)));
    await updateDbVersion(vaultDbVersion: 1);
    await db.close();
  }


  Future wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'vault.db'));
    await store.drop(db);
  }


  Stream<List<VaultModel>> onVaults(Database db, {int? month}){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query();
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => VaultModel.fromMap(e.value)).toList(growable: false)
      );
    return subscription;
  }
}
