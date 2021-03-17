import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/custom_widgets/address_card.dart';
import 'package:wantsbro/providers/order_provider.dart';
import 'package:wantsbro/providers/product_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class ViewOrder extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> orderDetails;
  const ViewOrder({
    Key key,
    @required this.orderId,
    @required this.orderDetails,
  }) : super(key: key);

  @override
  _ViewOrderState createState() => _ViewOrderState();
}

class _ViewOrderState extends State<ViewOrder> {
  Future<void> updateStock(List cartItems) async {
    for (var i = 0; i < cartItems.length; i++) {
      if (cartItems[i]["isSingle"]) {
        List<int> stockAndSold =
            await Provider.of<ProductProvider>(context, listen: false)
                .getSingleProductStockAndSold(cartItems[i]["productID"]);

        await Provider.of<ProductProvider>(context, listen: false)
            .updateSingleProductStockAndSold(
                cartItems[i]["productID"],
                stockAndSold[0] + cartItems[i]["count"],
                stockAndSold[1] - cartItems[i]["count"]);
      } else {
        List productVariation =
            await Provider.of<ProductProvider>(context, listen: false)
                .getMultipleProductVariation(cartItems[i]["productID"]);
        productVariation[cartItems[i]["variationIndex"]]["stockCount"] +=
            cartItems[i]["count"];
        productVariation[cartItems[i]["variationIndex"]]["soldCount"] -=
            cartItems[i]["count"];

        await Provider.of<ProductProvider>(context, listen: false)
            .updateMultipleProductStockAndSold(
                cartItems[i]["productID"], productVariation);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime _time = widget.orderDetails["orderTime"].toDate();
    List cartItems = widget.orderDetails["cartItems"];
    Color bgColor = widget.orderDetails["orderStatus"] == "Awaiting Acceptance"
        ? Colors.blueGrey
        : (widget.orderDetails["orderStatus"] == "Processing"
            ? Colors.lightBlue
            : (widget.orderDetails["orderStatus"] == "Cancelled"
                ? mainColor
                : Colors.teal));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(widget.orderId),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: bgColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${_time.year}-${_time.month}-${_time.day}  ${_time.hour}:${_time.minute}:${_time.second}\nStatus: ${widget.orderDetails["orderStatus"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              widget.orderDetails["orderStatus"] == "Completed"
                  ? ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal)),
                      onPressed: () {},
                      child: Text("Review Now"))
                  : widget.orderDetails["orderStatus"] == "Cancelled"
                      ? ElevatedButton(
                          onPressed: null, child: Text("Already Cancelled"))
                      : widget.orderDetails["orderStatus"] == "Processing"
                          ? ElevatedButton(
                              onPressed: null,
                              child: Text(
                                  "The order is packed and ready to ship."))
                          : ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Cancelling Confirmation!'),
                                      content: Text(
                                          "Are You Sure Want To Cancel the order?"),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          child: Text("Yes"),
                                          onPressed: () async {
                                            await Provider.of<OrderProvider>(
                                                    context,
                                                    listen: false)
                                                .cancelOrder(widget.orderId);

                                            await updateStock(cartItems);

                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ElevatedButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text("Cancel Order")),
              Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Text(
                    "Total Price: ${widget.orderDetails["totalCartPrice"]}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Column(children: [
                for (var i = 0; i < cartItems.length; i++)
                  Card(
                      child: FutureBuilder<DocumentSnapshot>(
                    future: Provider.of<ProductProvider>(context)
                        .getProductById(cartItems[i]["productID"]),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Text("Loading..."));
                      } else if (snapshot.hasError) {
                        return Text("There is an error");
                      } else {
                        final productData = snapshot.data.data();

                        //return Text(cartItems.toString());

                        return _singleProductCardCart(
                            context, productData, cartItems[i]);
                      }
                    },
                  ))
              ]),
              addressCard(
                  addressType: widget.orderDetails["shippingAddress"]
                      ["addressType"],
                  opacity: 0.0,
                  name: widget.orderDetails["shippingAddress"]["name"],
                  address: widget.orderDetails["shippingAddress"]["address"],
                  area: widget.orderDetails["shippingAddress"]["area"],
                  district: widget.orderDetails["shippingAddress"]["district"],
                  phone: widget.orderDetails["shippingAddress"]["phone"],
                  postCode: widget.orderDetails["shippingAddress"]["postCode"],
                  onPressed: null),
            ],
          ),
        ),
      ),
    );
  }

  Widget _singleProductCardCart(BuildContext context,
      Map<String, dynamic> productData, Map<String, dynamic> item) {
    final String _productTitle = item["isSingle"]
        ? productData["title"]
        : "${productData["title"]} (${getAttributes(productData["productVariation"][item["variationIndex"]])})";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 60,
            height: 60,
            child: Image.network(
              item["isSingle"]
                  ? productData["featuredImages"][0]
                  : productData["productVariation"][item["variationIndex"]]
                      ["variationImageUrl"],
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
        trailing: Text(item["totalPrice"].toString()),
        subtitle: Text(
          "Count: ${item["count"]}",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
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
}
