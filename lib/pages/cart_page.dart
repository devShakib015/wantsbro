import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/custom_widgets/Order%20System/choose_address.dart';
import 'package:wantsbro/custom_widgets/Product%20Details/product_details.dart';
import 'package:wantsbro/providers/cart_provider.dart';
import 'package:wantsbro/providers/product_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        actions: [
          Row(
            children: [
              Text("Total Item: "),
              FirebaseAuth.instance.currentUser != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: Provider.of<CartProvider>(context)
                          .getCartItems(context),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("0");
                        } else if (snapshot.hasError) {
                          return Text("0");
                        } else {
                          return Container(
                            child: Text(snapshot.data.docs.length.toString()),
                          );
                        }
                      },
                    )
                  : Text("0"),
            ],
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Provider.of<CartProvider>(context).getCartItems(context),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Center(
                      child: Text("Error Fetching data"),
                    ),
                  );
                } else {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final _cartDataList = snapshot.data.docs;
                    if (_cartDataList.isNotEmpty) {
                      double _cartTotal = 0;
                      for (var i = 0; i < _cartDataList.length; i++) {
                        _cartTotal += _cartDataList[i].data()["totalPrice"];
                      }
                      return Column(
                        children: [
                          _cartListView(_cartDataList),
                          Container(
                            width: double.infinity,
                            color: mainColor,
                            height: 50,
                            child: Center(
                              child: Text(
                                "Cart Total: $_cartTotal",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              List _cartItems = [];
                              for (var i = 0; i < _cartDataList.length; i++) {
                                _cartItems.add(_cartDataList[i].data());
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChooseAddress(
                                      totalCartPrice: _cartTotal,
                                      cartItems: _cartItems),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              height: 30,
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Proceed to Order",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.arrow_right_alt),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container(
                        child: Center(
                          child: Text("Empty Cart"),
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Expanded _cartListView(List<QueryDocumentSnapshot> dataList) {
    return Expanded(
      child: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            final item = dataList[index];
            int count = item.data()["count"];
            return Dismissible(
              key: Key(item.id),
              onDismissed: (direction) async {
                await Provider.of<CartProvider>(context, listen: false)
                    .deleteItemFromCart(context, item.id);
              },
              background: Container(
                child: Center(
                  child: Text("Delete Item From Cart"),
                ),
              ),
              child: Card(
                  child: FutureBuilder<DocumentSnapshot>(
                future: Provider.of<ProductProvider>(context)
                    .getProductById(item.data()["productID"]),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text("Loading..."));
                  } else if (snapshot.hasError) {
                    return Text("There is an error");
                  } else {
                    final productData = snapshot.data.data();

                    return _singleProductCardCart(
                        context, productData, item, count);
                  }
                },
              )),
            );
          }),
    );
  }

  GestureDetector _singleProductCardCart(BuildContext context,
      Map<String, dynamic> productData, QueryDocumentSnapshot item, int count) {
    final String _productTitle = item.data()["isSingle"]
        ? productData["title"]
        : "${productData["title"]} (${getAttributes(productData["productVariation"][item.data()["variationIndex"]])})";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(
              product: productData,
              productID: item.data()["productID"],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 60,
              height: 60,
              child: Image.network(
                item.data()["isSingle"]
                    ? productData["featuredImages"][0]
                    : productData["productVariation"]
                        [item.data()["variationIndex"]]["variationImageUrl"],
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            _productTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: _cartitemCount(count, context, item, productData),
          trailing: Text(item.data()["totalPrice"].toString()),
        ),
      ),
    );
  }

  String getAttributes(var data) {
    if (data["attributes"].keys.toList()[0] == "color" ||
        data["attributes"].keys.toList()[1] == "color") {
      if (data["attributes"].keys.toList()[0] == "color") {
        return "${data["attributes"].keys.toList()[1]} : ${data["attributes"]["${data["attributes"].keys.toList()[1]}"]}";
      } else {
        return "${data["attributes"].keys.toList()[0]} : ${data["attributes"]["${data["attributes"].keys.toList()[0]}"]}";
      }
    } else {
      return "${data["attributes"].keys.toList()[0]} : ${data["attributes"]["${data["attributes"].keys.toList()[0]}"]} - ${data["attributes"].keys.toList()[1]} : ${data["attributes"]["${data["attributes"].keys.toList()[1]}"]}";
    }
  }

  Widget _cartitemCount(int count, BuildContext context,
      QueryDocumentSnapshot item, Map<String, dynamic> productData) {
    return Container(
      child: Row(
        children: [
          MaterialButton(
            padding: EdgeInsets.zero,
            minWidth: 10,
            onPressed: () async {
              if (count > 1) {
                count--;

                double price = item.data()["isSingle"]
                    ? productData["salePrice"] == 0.0
                        ? (productData["originalPrice"] * count)
                        : (productData["salePrice"] * count)
                    : productData["productVariation"]
                                [item.data()["variationIndex"]]["salePrice"] ==
                            0.0
                        ? productData["productVariation"]
                                    [item.data()["variationIndex"]]
                                ["originalPrice"] *
                            count
                        : productData["productVariation"]
                                [item.data()["variationIndex"]]["salePrice"] *
                            count;

                await Provider.of<CartProvider>(context, listen: false)
                    .increaseCount(context, count, price, item.id);
              }
            },
            child: Icon(Icons.remove),
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            item.data()["count"].toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          MaterialButton(
            padding: EdgeInsets.zero,
            minWidth: 10,
            onPressed: () async {
              if (item.data()["isSingle"]) {
                if (count < productData["stockCount"]) {
                  count++;
                  double price = productData["salePrice"] == 0.0
                      ? (productData["originalPrice"] * count)
                      : (productData["salePrice"] * count);
                  await Provider.of<CartProvider>(context, listen: false)
                      .increaseCount(context, count, price, item.id);
                }
              } else {
                if (count <
                    productData["productVariation"]
                        [item.data()["variationIndex"]]["stockCount"]) {
                  count++;
                  double price = productData["productVariation"]
                              [item.data()["variationIndex"]]["salePrice"] ==
                          0.0
                      ? productData["productVariation"]
                              [item.data()["variationIndex"]]["originalPrice"] *
                          count
                      : productData["productVariation"]
                              [item.data()["variationIndex"]]["salePrice"] *
                          count;
                  await Provider.of<CartProvider>(context, listen: false)
                      .increaseCount(context, count, price, item.id);
                }
              }
            },
            child: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }
}
