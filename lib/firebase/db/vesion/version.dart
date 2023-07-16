// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense/models/version.dart';

class FirebaseVersionDb{
  dynamic uid;

  FirebaseVersionDb({this.uid});

  final CollectionReference versionCollection = FirebaseFirestore.instance.collection('db_version');

  ///Takee an expense and add them to firestore 
  Future createVersion(VersionModel version)async{
      await versionCollection
      .doc(uid).get()
        .then((versionDoc)async{
          if (!versionDoc.exists) {
            await versionCollection.doc(uid).set(version.toMap()).onError((error, stackTrace) => null);
          }
        }
      ); 
  }


  Future<VersionModel> get getVersion async{
    DocumentSnapshot version = await versionCollection.doc(uid).get();
    final data = version.data() as Map<String, dynamic>;
    return VersionModel.fromMap(data);
  }

  ///retturns the corresponding expense
  Future update(VersionModel version)async{
    await versionCollection.doc(uid).update(version.toMap());
  }

  Future delete(VersionModel version)async{
    await versionCollection.doc(uid).delete();
  }
}