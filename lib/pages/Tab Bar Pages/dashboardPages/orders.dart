import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/providers/auth_provider.dart';
import 'package:wantsbro/providers/order_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<AuthProvider>(context).currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: Provider.of<OrderProvider>(context).getAddresses(_user),
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
                var _dataList = snapshot.data.docs;

                if (_dataList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _dataList.length,
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final _value = _dataList[index].data();
                      //final _valueID = dataList[index].id;

                      DateTime _time = _value["orderTime"].toDate();

                      return Card(
                        color: _value["orderStatus"] == "Awaiting Acceptance"
                            ? Colors.blueGrey
                            : (_value["orderStatus"] == "Processing"
                                ? Colors.lightBlue
                                : (_value["orderStatus"] == "Cancelled"
                                    ? mainColor
                                    : Colors.teal)),
                        child: ListTile(
                          leading: Text("${index + 1}."),
                          title: Text(_value["orderId"]),
                          trailing: Text(_value["totalCartPrice"].toString()),
                          subtitle: Text(
                            "${_time.year}-${_time.month}-${_time.day}  ${_time.hour}:${_time.minute}:${_time.second}\nStatus: ${_value["orderStatus"]}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text("No Orders"),
                    ),
                  );
                }
              }
            }
          }),
    );
  }
}