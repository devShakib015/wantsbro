import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {
  CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Stream<QuerySnapshot> getProductsByCategory(String categoryId) {
    return _productCollection
        .where("childCategoryID", isEqualTo: categoryId)
        .snapshots();
  }

  Future<DocumentSnapshot> getProductById(String id) async {
    return await _productCollection.doc(id).get();
  }

  Stream<QuerySnapshot> getProductsByParentCategory(String categoryId) {
    return _productCollection
        .where("parentCategoryID", isEqualTo: categoryId)
        .snapshots();
  }
}
