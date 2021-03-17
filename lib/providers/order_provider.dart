import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wantsbro/models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('orders');

  Future<void> addNewOrder(OrderModel orderModel, String orderId) async {
    await _orderCollection
        .doc(orderId)
        .set(orderModel.toMap())
        .catchError((e) {});
  }

  Future<void> cancelOrder(String orderId) async {
    await _orderCollection
        .doc(orderId)
        .update({"orderStatus": "Cancelled"}).catchError((e) {});
    notifyListeners();
  }

  Stream<QuerySnapshot> getAddresses(User user) {
    return _orderCollection.where("userId", isEqualTo: user.uid).snapshots();
  }
}
