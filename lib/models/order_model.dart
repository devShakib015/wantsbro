import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OrderModel {
  DateTime orderTime;
  String orderStatus;
  String orderId;
  String userId;
  Map shippingAddress;
  List cartItems;
  double totalCartPrice;
  OrderModel({
    @required this.orderTime,
    @required this.orderStatus,
    @required this.orderId,
    @required this.userId,
    @required this.shippingAddress,
    @required this.cartItems,
    @required this.totalCartPrice,
  });

  OrderModel copyWith({
    DateTime orderTime,
    String orderStatus,
    String orderId,
    String userId,
    Map shippingAddress,
    List cartItems,
    double totalCartPrice,
  }) {
    return OrderModel(
      orderTime: orderTime ?? this.orderTime,
      orderStatus: orderStatus ?? this.orderStatus,
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      cartItems: cartItems ?? this.cartItems,
      totalCartPrice: totalCartPrice ?? this.totalCartPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderTime': Timestamp.fromDate(orderTime),
      'orderStatus': orderStatus,
      'orderId': orderId,
      'userId': userId,
      'shippingAddress': shippingAddress,
      'cartItems': cartItems,
      'totalCartPrice': totalCartPrice,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderTime: DateTime.fromMillisecondsSinceEpoch(map['orderTime']),
      orderStatus: map['orderStatus'],
      orderId: map['orderId'],
      userId: map['userId'],
      shippingAddress: Map.from(map['shippingAddress']),
      cartItems: List.from(map['cartItems']),
      totalCartPrice: map['totalCartPrice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModel(orderTime: $orderTime, orderStatus: $orderStatus, orderId: $orderId, userId: $userId, shippingAddress: $shippingAddress, cartItems: $cartItems, totalCartPrice: $totalCartPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderModel &&
        other.orderTime == orderTime &&
        other.orderStatus == orderStatus &&
        other.orderId == orderId &&
        other.userId == userId &&
        mapEquals(other.shippingAddress, shippingAddress) &&
        listEquals(other.cartItems, cartItems) &&
        other.totalCartPrice == totalCartPrice;
  }

  @override
  int get hashCode {
    return orderTime.hashCode ^
        orderStatus.hashCode ^
        orderId.hashCode ^
        userId.hashCode ^
        shippingAddress.hashCode ^
        cartItems.hashCode ^
        totalCartPrice.hashCode;
  }
}
