import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wantsbro/custom_widgets/product_card.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({
    Key key,
    @required this.productDataList,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> productDataList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: productDataList
              .map((e) => SingleProductCard(
                    e: e,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
