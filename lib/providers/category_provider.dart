import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider extends ChangeNotifier {
  CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('categories');

  Stream<QuerySnapshot> getParentCategories() {
    return _categoryCollection.where("parentID", isEqualTo: "").snapshots();
  }

  Stream<QuerySnapshot> getChildCategoriesByparentId(String parentID) {
    return _categoryCollection
        .where("parentID", isEqualTo: parentID)
        .snapshots();
  }
}
