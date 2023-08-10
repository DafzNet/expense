// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:expense/firebase/db/vesion/version.dart';
import 'package:expense/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../models/version.dart';
import '../db/user.dart';

class FireAuth{
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? get currentUser => auth.currentUser;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Stream<User?> get authStateChange => auth.authStateChanges();
      

  Future createUserWithEmail({required String email, required String password, required String name})async{
    ///Create a user using email and password
    UserCredential _user = await auth.createUserWithEmailAndPassword(email: email, password: password);
    
    
    User newUser = _user.user!;

    ///Create user on firestore
    FirebaseUserDb userDb = FirebaseUserDb(uid: newUser.uid);
    
    //Create user remote db versions
    await FirebaseVersionDb(uid: newUser.uid).createVersion(
      VersionModel(
          id: DateTime.now().millisecondsSinceEpoch
        )
    );

    LightUser lightUser = LightUser(
      id: newUser.uid, 
      firstName: name.split(' ')[0], 
      lastName: name.split(' ').getRange(1, name.split(' ').length).join(' '), 
      email: email);

    await userDb.createNewUser(lightUser);

    return newUser;
  }


  Future signinUserWithEmail({required String email, required String password})async{
    UserCredential _user = await auth.signInWithEmailAndPassword(email: email, password: password);

    User newUser = _user.user!;

    return newUser;
  }

  /////////////
  ///google signin
  

  Future<User?> googleReg() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuth = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken,
        );
        final UserCredential authResult = await auth.signInWithCredential(credential);
        final User? user = authResult.user;

        User newUser = user!;

    ///Create user on firestore
        FirebaseUserDb userDb = FirebaseUserDb(uid: newUser.uid);
        
        //Create user remote db versions
        await FirebaseVersionDb(uid: newUser.uid).createVersion(
          VersionModel(
              id: DateTime.now().millisecondsSinceEpoch
            )
        );

        LightUser lightUser = LightUser(
            id: newUser.uid, 
            firstName: user.displayName!.split(' ')[0], 
            lastName: user.displayName!.split(' ').getRange(1, user.displayName!.split(' ').length).join(' '), 
            email: user.email,
            dp: user.photoURL
          );

        await userDb.createNewUser(lightUser);

        return newUser;

        //return user;
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
    return null;
  }






  Future signout()async{
    await auth.signOut();
  }
}