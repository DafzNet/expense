// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/models/fexpert_like.dart';

class FexpertLikesDb{
  dynamic fexpertId;

  FexpertLikesDb(this.fexpertId);

  final CollectionReference fexpertLikesCollection = FirebaseFirestore.instance.collection('fexpert_likes');

  Future<FLike> fetch()async{
    await create(
      FLike(fexpertId: fexpertId)
    );
    final a = await fexpertLikesCollection.doc(fexpertId.toString()).get();
    return FLike.fromMap(
      a.data() as Map<String, dynamic>
    );
  }

  Future create(FLike like)async{
    await fexpertLikesCollection.doc(fexpertId.toString()).get().then((value)async{
          if (!value.exists){
            await fexpertLikesCollection.doc(fexpertId.toString()).set(like.toMap());
          }
        });
  }

  ///retturns the corresponding expense
  Future update(FLike like)async{
    if (like.likes.isEmpty) {
      await create(like);
    }
    await fexpertLikesCollection.doc(fexpertId.toString()).update(like.toMap());
  }

  Future delete(FLike like)async{
    await fexpertLikesCollection.doc(fexpertId.toString()).delete();
  }
}