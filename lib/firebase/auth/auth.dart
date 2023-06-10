// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:expense/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../db/user.dart';

class FireAuth{
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;

  Stream<User?> get authStateChange => auth.authStateChanges();
      

  Future<LightUser?> createUserWithEmail({required String email, required String password, required String name})async{
    ///Create a user using email and password
    var _user = await auth.createUserWithEmailAndPassword(email: email, password: password);
    User newUser = _user.user!;

    ///Create user on firestore
    FirebaseUserDb userDb = FirebaseUserDb(uid: newUser.uid);

    LightUser lightUser = LightUser(
      id: newUser.uid, 
      firstName: name.split(' ')[0], 
      lastName: name.split(' ').getRange(1, name.split(' ').length).join(' '), 
      email: email);

    await userDb.createNewUser(lightUser);

    return lightUser;
  }


  Future<LightUser?> signinUserWithEmail({required String email, required String password})async{
    var _user = await auth.signInWithEmailAndPassword(email: email, password: password);

    User newUser = _user.user!;

    FirebaseUserDb userDb = FirebaseUserDb(uid: newUser.uid);

    return userDb.getUserData();
  }


  Future signout()async{
    await auth.signOut();
  }
}