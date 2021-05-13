import 'dart:convert';

class CartModel {
  String productID;
  int count;
  int variationIndex;
  bool isSingle;
  double totalPrice;
  CartModel({
    this.productID,
    this.count,
    this.variationIndex,
    this.isSingle,
    this.totalPrice,
  });

  CartModel copyWith({
    String productID,
    int count,
    int variationIndex,
    bool isSingle,
    double totalPrice,
  }) {
    return CartModel(
      productID: productID ?? this.productID,
      count: count ?? this.count,
      variationIndex: variationIndex ?? this.variationIndex,
      isSingle: isSingle ?? this.isSingle,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productID': productID,
      'count': count,
      'variationIndex': variationIndex,
      'isSingle': isSingle,
      'totalPrice': totalPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      productID: map['productID'],
      count: map['count'],
      variationIndex: map['variationIndex'],
      isSingle: map['isSingle'],
      totalPrice: map['totalPrice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartModel(productID: $productID, count: $count, variationIndex: $variationIndex, isSingle: $isSingle, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartModel &&
        other.productID == productID &&
        other.count == count &&
        other.variationIndex == variationIndex &&
        other.isSingle == isSingle &&
        other.totalPrice == totalPrice;
  }

  @override
  int get hashCode {
    return productID.hashCode ^
        count.hashCode ^
        variationIndex.hashCode ^
        isSingle.hashCode ^
        totalPrice.hashCode;
  }
}
