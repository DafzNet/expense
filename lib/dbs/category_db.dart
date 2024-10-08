// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/category_model.dart';
import '../models/version.dart';

class CategoryDb{
  Database? dbs;

  CategoryDb();



  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));
    return dbs;
  }

  Future addData(CategoryModel category)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    await store.add(db, category.toMap());
    await updateDbVersion(categoryDbVersion: 1);

    await db.close();
  }

  Future<List<CategoryModel>> retrieveData()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data.map((e){
        var el =  e as Map<String, dynamic>;
        return CategoryModel.fromMap(el);}
    ).toList();
  }


    Future addCategories(List<CategoryModel> categories)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    List<Map<String, dynamic>>? _cats = [];

    for (var cat in categories) {
      bool existing =await exists(cat: cat);
      if (!existing) {
        _cats.add(cat.toMap());
      }
    }

    await store.addAll(db, _cats);


    await db.close();
  }


    Future<bool> exists({CategoryModel? cat})async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    var key = await store.findKey(db, finder: Finder(
      filter: Filter.equals('id', cat?.id)
    ));
    return key != null ? true : false;
  }




  Future<List<CategoryModel>> retrieveBasedOn({List<Filter>? filters})async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    var keys = await store.findKeys(db, finder: Finder(filter: Filter.and(filters!)));

    var data = await store.records(keys).get(db);
    await db.close();

    return data.map((e) => CategoryModel.fromMap(e as Map<String, dynamic>)).toList();
  }


  Future updateData(CategoryModel category)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    await store.update(db, category.toMap(), finder: Finder(filter: Filter.equals('id', category.id)));
    await updateDbVersion(categoryDbVersion: 1);
    await db.close();
  }

  Future deleteData(CategoryModel category)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', category.id)));
    await updateDbVersion(categoryDbVersion: 1);
    await db.close();
  }


  Future<dynamic> wipe()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));
    await store.drop(db);
  }
  

  Stream<List<CategoryModel>> onCategories(Database db){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query(finder: Finder(
      filter: Filter.equals('hidden', false)
      
    ));
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => CategoryModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
