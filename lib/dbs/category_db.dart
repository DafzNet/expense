import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import '../models/category_model.dart';

class CategoryDb{
  Database? dbs;

  CategoryDb();



  Future<Database?> openDb() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var factory = databaseFactoryIo;
    dbs = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));
    return dbs;
  }

  Future addData(Map<String, dynamic>data)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    await store.add(db, data);

    await db.close();
  }

  Future retrieveData()async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

     var keys = await store.findKeys(db);

     var data = await store.records(keys).get(db);
     await db.close();

     return data;
  }


  Future updateData(Map<String, dynamic>newData, id)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    await store.update(db, newData, finder: Finder(filter: Filter.equals('id', id)));
    await db.close();
  }

  Future<Map> deleteData(id)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'category.db'));

    var r =await store.find(db, finder: Finder(filter: Filter.equals('id', id)));

    await store.delete(db, finder: Finder(filter: Filter.equals('id', id)));
    await db.close();
    
    return r.first.value;
  }
  

  // var CategoryTransformer = StreamTransformer<
  //     List<RecordSnapshot<int, Map<String, Object?>>>,
  //     List<CategoryModel>>.fromHandlers(handleData: (snapshotList, sink) {
  //       List<CategoryModel> cats = snapshotList.map((e) => CategoryModel.fromMap(e.value as Map<String, dynamic>)).toList();
  //   sink.add(cats);
  // });

  // var noteTransformer = StreamTransformer<
  //     RecordSnapshot<int, Map<String, Object?>>?,
  //     DbNote?>.fromHandlers(handleData: (snapshot, sink) {
  //   sink.add(snapshot == null ? null : snapshotToNote(snapshot));
  // });

  /// Listen for changes on any note
  // Stream<List<ExpenseModel>> onExpenses() {
  //   return notesStore
  //       .query(finder: Finder(sortOrders: [SortOrder('date', false)]))
  //       .onSnapshots(db!)
  //       .transform(notesTransformer);
  // }


  Stream<List<CategoryModel>> onCategories(Database db){
    var store = intMapStoreFactory.store();
    var storeQuery = store.query();
    var subscription = storeQuery.onSnapshots(db).map((snapshot) => snapshot.map((e) => CategoryModel.fromMap(e.value)).toList(growable: false)
      );
    //.transform(expensesTransformer);
    return subscription;
  }
}
