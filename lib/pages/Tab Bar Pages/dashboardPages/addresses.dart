import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/custom_widgets/address_card.dart';
import 'package:wantsbro/pages/Tab%20Bar%20Pages/dashboardPages/address_edit.dart';
import 'package:wantsbro/providers/address_provider.dart';
import 'package:wantsbro/providers/auth_provider.dart';

class AddressesPage extends StatelessWidget {
//! void callbacks

  void _addNewAddress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressEditPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User _user = Provider.of<AuthProvider>(context).currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Addresses"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addNewAddress(context),
          )
        ],
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
                  return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final _value = dataList[index].data();
                      final _valueID = dataList[index].id;

                      return addressCard(
                          addressType: _value["addressType"],
                          opacity: 1,
                          name: _value["name"],
                          address: _value["address"],
                          area: _value["area"],
                          district: _value["district"],
                          phone: _value["phone"],
                          postCode: _value["postCode"],
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddressEditPage(
                                  id: _valueID,
                                  value: _value,
                                ),
                              ),
                            );
                          });
                    },
                  );
                } else {
                  return Container(
                    child: Center(
                      child: Text("No Addresses"),
                    ),
                  );
                }
              }
            }
          }),
    );
  }
}
