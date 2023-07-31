// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'dart:async';
import 'package:expense/models/fexpert_like.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class LikeDb{
  dynamic fexpertId;

  LikeDb(this.fexpertId);

  Future create(FLike like)async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;
    var db = await factory.openDatabase(join(appDocumentDir.path, 'fxlike.db'));

    await store.add(db, like.toMap());

    await db.close();
  }


  Future<FLike> fetch()async{
    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'fxlike.db'));

    int? key = await store.findKey(db, finder: Finder(filter: Filter.equals('fexpertId', fexpertId)));

    if (key != null) {
      
    }else{
      await create(
          FLike(
            fexpertId: fexpertId,
            likes: []
          )
        );

      return FLike(
            fexpertId: fexpertId,
            likes: []
          );
    }

    final data = await store.record(key).get(db);
    await db.close();

    return FLike.fromMap(
      data as Map<String, dynamic>
    );
  }


  Future update(FLike like)async{

    final appDocumentDir = await getApplicationDocumentsDirectory();
    var store = intMapStoreFactory.store();
    var factory = databaseFactoryIo;

    var db = await factory.openDatabase(join(appDocumentDir.path, 'fxlike.db'));

    await store.update(db, like.toMap(), finder: Finder(filter: Filter.equals('fexpertId', fexpertId)));
    await db.close();
  }



}
