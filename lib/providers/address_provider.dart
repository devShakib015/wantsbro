import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:wantsbro/models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  CollectionReference _addressCollection =
      FirebaseFirestore.instance.collection('addresses');

  Future<void> addNewAddress(AddressModel addresses) async {
    await _addressCollection.doc().set(addresses.toMap()).catchError((e) {});
  }

  Future<void> updateAddress(String id, Map<String, dynamic> fields) async {
    await _addressCollection.doc(id).update(fields);
  }

  Future<void> deleteAddress(String id) async {
    await _addressCollection.doc(id).delete();
  }

  Stream<QuerySnapshot> getAddresses(User user) {
    return _addressCollection.where("id", isEqualTo: user.uid).snapshots();
  }
}
