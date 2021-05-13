import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/providers/auth_provider.dart';

class FavProvider extends ChangeNotifier {
  Future<void> addToFav(BuildContext context, String productID) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context, listen: false).currentUser.uid)
        .collection("favs")
        .doc(productID)
        .set({
      "productID": productID,
    });
    notifyListeners();
  }

  Future<void> deleteItemFromFav(BuildContext context, String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context, listen: false).currentUser.uid)
        .collection("favs")
        .doc(id)
        .delete();
    notifyListeners();
  }

  Stream<QuerySnapshot> getFavItems(BuildContext context) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context).currentUser?.uid)
        .collection("favs")
        .snapshots();
  }
}
