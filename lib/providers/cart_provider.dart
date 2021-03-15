import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/models/cart_model.dart';
import 'package:wantsbro/providers/auth_provider.dart';

class CartProvider extends ChangeNotifier {
  Future<void> addToCart(BuildContext context, CartModel cartModel) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context, listen: false).currentUser.uid)
        .collection("cart")
        .add(cartModel.toMap());
    notifyListeners();
  }

  Future<void> increaseCount(
      BuildContext context, int count, double price, String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context, listen: false).currentUser.uid)
        .collection("cart")
        .doc(id)
        .update({"count": count, "totalPrice": price});
    notifyListeners();
  }

  Future<void> deleteItemFromCart(BuildContext context, String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context, listen: false).currentUser.uid)
        .collection("cart")
        .doc(id)
        .delete();
    notifyListeners();
  }

  Stream<QuerySnapshot> getCartItems(BuildContext context) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context).currentUser.uid)
        .collection("cart")
        .snapshots();
  }

  double cartTotal(double total) {
    return total;
  }
}
