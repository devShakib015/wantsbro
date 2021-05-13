import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  bool isLoggedIn() {
    if (_firebaseAuth.currentUser != null) {
      if (_users.doc(_firebaseAuth.currentUser.uid).id != null) {
        return true;
      } else
        return false;
    } else {
      return false;
    }
  }

  Future<User> signInWithGoogle() async {
    // Trigger the authentication flow_de
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final GoogleAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        notifyListeners();

        return authResult.user;
      } else
        throw PlatformException(
            code: "Authentication_failed",
            message: "There is a problem with authenticating");
    } else
      throw PlatformException(
          code: "Not_Signed_In", message: "User doesn't want to sign in");
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    await _firebaseAuth.signOut();
    notifyListeners();
  }

  User get currentUser {
    if (_firebaseAuth.currentUser != null) {
      return _firebaseAuth.currentUser;
    } else
      return null;
  }
}
