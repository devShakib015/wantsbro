import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String newText;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Phone number"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: IntlPhoneField(
                  autoValidate: true,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  initialCountryCode: 'BD',
                  onChanged: (phone) {
                    newText = phone.completeNumber;
                  },
                ),
              ),
              ButtonBar(
                children: [
                  ElevatedButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                  ),
                  ElevatedButton(
                    child: Text("Save"),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.pop(context, newText);
                      }
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
