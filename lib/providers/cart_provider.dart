import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/models/cart_model.dart';
import 'package:wantsbro/providers/auth_provider.dart';

class CartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartList = [];

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

  Future<void> clearCart(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context, listen: false).currentUser.uid)
        .collection("cart")
        .get()
        .then((value) => {
              for (DocumentSnapshot ds in value.docs) {ds.reference.delete()}
            });

    notifyListeners();
  }

  Stream<QuerySnapshot> getCartItems(BuildContext context) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context).currentUser.uid)
        .collection("cart")
        .snapshots();
  }

  Future<void> makeCartList(BuildContext context) async {
    //_cartList.clear();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(Provider.of<AuthProvider>(context).currentUser.uid)
        .collection("cart")
        .snapshots()
        .forEach((element) {
      _cartList.clear();
      final data = element.docs;
      for (var i = 0; i < data.length; i++) {
        _cartList.add({
          "productId": data[i].data()["productID"],
          "index": data[i].data()["variationIndex"]
        });
      }
    });

    print(_cartList);
  }

  List<Map<String, dynamic>> get getCartItemsAndIndex {
    return _cartList;
  }

  double cartTotal(double total) {
    return total;
  }
}
