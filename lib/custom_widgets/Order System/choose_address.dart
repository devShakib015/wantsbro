import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/models/order_model.dart';
import 'package:wantsbro/providers/address_provider.dart';
import 'package:wantsbro/providers/auth_provider.dart';
import 'package:wantsbro/providers/cart_provider.dart';
import 'package:wantsbro/providers/order_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class ChooseAddress extends StatefulWidget {
  final double totalCartPrice;
  final List cartItems;
  const ChooseAddress({
    Key key,
    @required this.totalCartPrice,
    @required this.cartItems,
  }) : super(key: key);
  @override
  _ChooseAddressState createState() => _ChooseAddressState();
}

class _ChooseAddressState extends State<ChooseAddress> {
  Map _selectedAddress = {};

  void _confirmPayment() async {
    String _orderId = "WB${DateTime.now().millisecondsSinceEpoch}";
    await Provider.of<OrderProvider>(context, listen: false).addNewOrder(
        OrderModel(
            orderTime: DateTime.now(),
            orderStatus: "Awaiting Acceptance",
            orderId: _orderId,
            userId: Provider.of<AuthProvider>(context, listen: false)
                .currentUser
                .uid,
            shippingAddress: _selectedAddress,
            cartItems: widget.cartItems,
            totalCartPrice: widget.totalCartPrice),
        _orderId);
    await Provider.of<CartProvider>(context, listen: false).clearCart(context);

    await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.width * 0.6,
            child: Center(
                child: Text(
                    "Order is successfully Placed\n\nOrder ID: $_orderId"))),
      ),
    );

    Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Choose Shipping Address"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Provider.of<AddressProvider>(context).getAddresses(_user),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                final dataList = snapshot.data.docs;

                if (dataList.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: dataList.length,
                          itemBuilder: (context, index) {
                            final _value = dataList[index].data();

                            return ListTile(
                              title: Text(
                                _value["addressType"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle:
                                  Text("${_value["name"]}\n${_value["phone"]}"),
                              leading: Checkbox(
                                activeColor: white,
                                fillColor: MaterialStateProperty.all(mainColor),
                                value: _selectedAddress["addressType"] ==
                                    _value["addressType"],
                                onChanged: (bool isSelected) {
                                  setState(() {
                                    _selectedAddress = _value;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedAddress["addressType"] == null) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Center(
                                        child: Text(
                                            "Select a shipping address first."))),
                              ),
                            );
                          } else {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => SingleChildScrollView(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Icon(Icons.drag_handle),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      PaymentMethod(
                                        imagePath: "assets/images/bkash.png",
                                        onPressed: _confirmPayment,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      PaymentMethod(
                                        imagePath: "assets/images/nagad.png",
                                        onPressed: _confirmPayment,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Pay Now",
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
                      )
                    ],
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text(
                        "No Addresses Available.\nAdd an address in your dashboard \nthen come back here to order. \n\nThank you!!!",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              }
            }
          }),
    );
  }
}

class PaymentMethod extends StatelessWidget {
  final String imagePath;

  final Function onPressed;
  const PaymentMethod({
    Key key,
    this.imagePath,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: white,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.1,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
