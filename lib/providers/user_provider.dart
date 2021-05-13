import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wantsbro/custom_widgets/show_dialog.dart';
import 'package:wantsbro/models/user_model.dart';

class UserProvider extends ChangeNotifier {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User user, BuildContext context) async {
    if (user != null) {
      final _user = await _users.doc(user.uid).get();

      if (_user.exists) {
        return null;
      } else
        return _users
            .doc(user.uid)
            .set(UserModel(
              id: user.uid,
              name: user.displayName,
              dpURL: user.photoURL,
              email: user.email,
              phone: user.phoneNumber,
              userRole: "Customer",
              customerId: "${user.email.split("@")[0]}",
            ).toMap())
            .then((value) {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.all(20),
                child: Text(
                  "Welcome to wantsBro",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }).catchError(
          (error) => showErrorDialog(context,
              "There is an error adding your info in the database, please login again."),
        );
    }
  }

  Future<DocumentSnapshot> getUserData(User currentUser) async {
    return await _users.doc(currentUser.uid).get();
  }

  void updateName(
      BuildContext context, String newName, User currentUser) async {
    try {
      await currentUser.updateProfile(displayName: newName);
      await _users.doc(currentUser.uid).update({"name": newName});
      notifyListeners();
    } catch (e) {
      return showErrorDialog(context, "Error saving data");
    }
  }

  void updatePhone(
      BuildContext context, String newPhone, User currentUser) async {
    try {
      await _users.doc(currentUser.uid).update({"phone": newPhone}).catchError(
          (e) => showErrorDialog(context, "Error saving data"));
      notifyListeners();
    } catch (e) {
      print(e.toString());
      return showErrorDialog(context, "Error saving data");
    }
  }

  void updateGender(
      BuildContext context, String gender, User currentUser) async {
    try {
      await _users.doc(currentUser.uid).update({"gender": gender});
      notifyListeners();
    } catch (e) {
      return showErrorDialog(context, "Error saving data");
    }
  }

  void updateDateOfBirth(
      BuildContext context, DateTime dob, User currentUser) async {
    try {
      await _users.doc(currentUser.uid).update({"dateOfBirth": dob});
      notifyListeners();
    } catch (e) {
      return showErrorDialog(context, "Error saving data");
    }
  }

  void updateOccupation(
      BuildContext context, String occupation, User currentUser) async {
    try {
      await _users.doc(currentUser.uid).update({"occupation": occupation});
      notifyListeners();
    } catch (e) {
      return showErrorDialog(context, "Error saving data");
    }
  }

  Future<Map<String, dynamic>> getUser(User user) async {
    return {
      "dp": user.photoURL,
      "name": user.displayName,
      "email": user.email,
    };
  }
}
