import 'package:flutter/material.dart';

Widget addressCard(
    {String addressType,
    String name,
    String phone,
    String address,
    String postCode,
    String area,
    String district,
    double opacity,
    Function onPressed}) {
  return Card(
    child: Column(
      children: [
        ListTile(
          leading: Icon(Icons.location_on),
          trailing: Opacity(
            opacity: opacity,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: onPressed,
            ),
          ),
          title: Text(
            addressType,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                phone,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("$address, $area, $district-$postCode"),
            ],
          ),
        ),
      ],
    ),
  );
}
