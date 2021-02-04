import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello_fellow/helper/share_preferences.dart';
import 'package:hello_fellow/model/user.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserObject _getUserFromFirebaseUser(User user) {
    return user != null ? UserObject(user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    UserCredential result = await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((error) {
      // Handle Errors here.
      var errorCode = error.code;
      var errorMessage = error.message;
      if (errorCode == 'auth/wrong-password') {
        print('Wrong password.');
      } else {
        print(errorMessage);
      }
    });
    User user = result.user;
    UserObject userObject = _getUserFromFirebaseUser(user);
    return userObject;
  }

  Future signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      HelperFunctions.saveUserNameSharedPreference(name);

      return _getUserFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}

Future firebaseSignIn() async {
  FirebaseAuth.instance.authStateChanges().listen((User user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
}
