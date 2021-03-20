import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider extends ChangeNotifier {
  CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('products');

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    List<Map<String, dynamic>> _pList = [];

    await _productCollection.get().then((value) => {
          for (var i = 0; i < value.docs.length; i++)
            {
              _pList.add({
                "title": value.docs[i].data()["title"],
                "category": value.docs[i].data()["childCategoryName"],
                "imageUrl": value.docs[i].data()["featuredImages"][0],
                "id": value.docs[i].id,
                "product": value.docs[i].data(),
              })
            }
        });

    return _pList;
  }

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

  Future<List<int>> getSingleProductStockAndSold(String productId) async {
    int stock;
    int sold;
    await _productCollection.doc(productId).get().then((value) {
      stock = value.data()["stockCount"];
      sold = value.data()["soldCount"];
    });
    return [stock, sold];
  }

  Future<List> getMultipleProductVariation(String productId) async {
    List v = [];
    await _productCollection.doc(productId).get().then((value) {
      v = value.data()["productVariation"];
    });
    return v;
  }

  Future<void> updateSingleProductStockAndSold(
      String productId, int newStockCount, int newSoldCount) async {
    await _productCollection
        .doc(productId)
        .update({"stockCount": newStockCount, "soldCount": newSoldCount});
    notifyListeners();
  }

  Future<void> updateMultipleProductStockAndSold(
      String productId, List productVariation) async {
    await _productCollection
        .doc(productId)
        .update({"productVariation": productVariation});
    notifyListeners();
  }
}
