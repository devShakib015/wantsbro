import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import 'package:wantsbro/models/address_model.dart';
import 'package:wantsbro/providers/address_provider.dart';
import 'package:wantsbro/providers/auth_provider.dart';

class AddressEditPage extends StatefulWidget {
  final String id;
  final Map value;

  const AddressEditPage({
    Key key,
    this.id,
    this.value,
  }) : super(key: key);

  @override
  _AddressEditPageState createState() => _AddressEditPageState();
}

class _AddressEditPageState extends State<AddressEditPage> {
  String addressType;
  String name;
  String phone;
  String address;
  String postCode;
  String area;
  String district;

  final _fomrkey = GlobalKey<FormState>();

  Widget _customTextFormField(
      {String title, String hint, String initialValue, Function onChnaged}) {
    return TextFormField(
      onChanged: onChnaged,
      initialValue: initialValue != null ? initialValue : null,
      decoration: InputDecoration(labelText: title, hintText: hint),
      validator: (value) {
        if (value.isEmpty) {
          return "Can't be empty";
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User _currentUser = Provider.of<AuthProvider>(context).currentUser;

    return Scaffold(
      appBar: AppBar(
        title: widget.id != null ? Text("Edit Address") : Text("Add Address"),
        actions: [
          widget.id != null
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    Navigator.pop(context);
                    await Provider.of<AddressProvider>(context, listen: false)
                        .deleteAddress(widget.id);
                  },
                )
              : Opacity(
                  opacity: 0,
                  child: Icon(
                    Icons.delete,
                  )),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Form(
            key: _fomrkey,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                _customTextFormField(
                    onChnaged: (value) {
                      setState(() {
                        addressType = value;
                      });
                    },
                    initialValue:
                        widget.id != null ? widget.value["addressType"] : null,
                    title: "Address Type",
                    hint: "Home Address, Work Address, Cousin's Address"),
                SizedBox(
                  height: 10,
                ),
                _customTextFormField(
                    onChnaged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    initialValue:
                        widget.id != null ? widget.value["name"] : null,
                    title: "Full name",
                    hint: "Full name of the person who will receive"),
                SizedBox(
                  height: 10,
                ),
                IntlPhoneField(
                  autoValidate: true,
                  maxLength: 10,
                  initialValue: widget.id != null
                      ? widget.value["phone"]
                          .substring(widget.value["phone"].length - 10)
                      : null,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  initialCountryCode: 'BD',
                  onChanged: (text) {
                    setState(() {
                      phone = text.completeNumber;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                _customTextFormField(
                    onChnaged: (value) {
                      setState(() {
                        address = value;
                      });
                    },
                    initialValue:
                        widget.id != null ? widget.value["address"] : null,
                    title: "Address",
                    hint: "House no, Road no"),
                SizedBox(
                  height: 10,
                ),
                _customTextFormField(
                    onChnaged: (value) {
                      setState(() {
                        area = value;
                      });
                    },
                    initialValue:
                        widget.id != null ? widget.value["area"] : null,
                    title: "Area",
                    hint: "Mirpur 10, Dhanmondi, Gulshan"),
                SizedBox(
                  height: 10,
                ),
                _customTextFormField(
                    onChnaged: (value) {
                      setState(() {
                        postCode = value;
                      });
                    },
                    initialValue:
                        widget.id != null ? widget.value["postCode"] : null,
                    title: "Post Code",
                    hint: "1207, 6600"),
                SizedBox(
                  height: 10,
                ),
                _customTextFormField(
                    onChnaged: (value) {
                      setState(() {
                        district = value;
                      });
                    },
                    initialValue:
                        widget.id != null ? widget.value["district"] : null,
                    title: "District",
                    hint: "Dhaka, Sylhet, Pabna"),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    if (_fomrkey.currentState.validate()) {
                      Navigator.pop(context);
                      if (widget.id != null) {
                        await Provider.of<AddressProvider>(context,
                                listen: false)
                            .updateAddress(widget.id, {
                          'address': address ?? widget.value["address"],
                          'addressType':
                              addressType ?? widget.value["addressType"],
                          'area': area ?? widget.value["area"],
                          'district': district ?? widget.value["district"],
                          'name': name ?? widget.value["name"],
                          'phone': phone ?? widget.value["phone"],
                          'postCode': postCode ?? widget.value["postCode"],
                        });
                      } else
                        await Provider.of<AddressProvider>(context,
                                listen: false)
                            .addNewAddress(AddressModel(
                          id: _currentUser.uid,
                          address: address,
                          addressType: addressType,
                          area: area,
                          district: district,
                          name: name,
                          phone: phone,
                          postCode: postCode,
                        ));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
