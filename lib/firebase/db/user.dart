// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class FirebaseUserDb{
  dynamic uid;

  FirebaseUserDb({this.uid});

  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future createNewUser(LightUser lightUser)async{
    await users.doc(uid).set(lightUser.toMap());
  }


  Future<LightUser?> getUserData()async{
    DocumentSnapshot? _doc;
    try {
      _doc = await users.doc(uid).get(const GetOptions(source: Source.cache));
    } catch (e) {
      DocumentSnapshot _doc = await users.doc(uid).get(const GetOptions(source: Source.serverAndCache));
    }
    Map<String, dynamic> docUser = _doc!.data() as Map<String, dynamic>;

    return LightUser.fromMap(docUser);
  }


  Future updateUser(LightUser user)async{
    await users.doc(uid).update(user.toMap());
  }

}