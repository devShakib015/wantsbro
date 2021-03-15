import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wantsbro/custom_widgets/Product%20Details/product_details.dart';
import 'package:wantsbro/theming/color_constants.dart';

class SingleProductCard extends StatelessWidget {
  final QueryDocumentSnapshot e;

  const SingleProductCard({
    Key key,
    this.e,
  }) : super(key: key);

  void _goToProductDetails(BuildContext context, Map<String, dynamic> product) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetails(
                  product: product,
                  productID: e.id,
                )));
  }

  String getMultipleProductPrices(var list, String price) {
    List prices = [];
    for (var i = 0; i < list.length; i++) {
      prices.add(list[i][price]);
    }

    prices.sort();
    return "${prices.first} - ${prices.last}";
  }

  Stack _productViewImageWithOnSaleMark(QueryDocumentSnapshot e) {
    return Stack(
      children: [
        _productViewImage(e),
        Positioned(
          top: 20,
          right: 0,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: mainBackgroundColor),
                child: Text(
                  'On Sale!!!',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                )),
          ),
        ),
      ],
    );
  }

  Material _productViewImage(QueryDocumentSnapshot e) {
    return Material(
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Hero(
          tag: e.data()["title"],
          child: Image.network(
            e.data()["featuredImages"][0],
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: MediaQuery.of(context).size.width / 2 - 30,
                height: MediaQuery.of(context).size.width / 2 - 70,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          _goToProductDetails(context, e.data());
        },
        child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 2,
          shadowColor: Colors.red,
          child: Container(
            width: MediaQuery.of(context).size.width / 2 - 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                e.data()["isSingle"]
                    ? e.data()["salePrice"] == 0.0
                        ? _productViewImage(e)
                        : _productViewImageWithOnSaleMark(e)
                    : getMultipleProductPrices(
                                e.data()["productVariation"], "salePrice") ==
                            "0.0 - 0.0"
                        ? _productViewImage(e)
                        : _productViewImageWithOnSaleMark(e),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          e.data()["title"],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        e.data()["isSingle"] == true
                            ? (e.data()["salePrice"] == 0.0
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.data()["originalPrice"].toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      )
                                    ],
                                  )
                                : DoublePriceTag(
                                    originalPrice:
                                        e.data()["originalPrice"].toString(),
                                    salePrice: e.data()["salePrice"].toString(),
                                  ))
                            : getMultipleProductPrices(
                                        e.data()["productVariation"],
                                        "salePrice") ==
                                    "0.0 - 0.0"
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getMultipleProductPrices(
                                            e.data()["productVariation"],
                                            "originalPrice"),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      )
                                    ],
                                  )
                                : DoublePriceTag(
                                    originalPrice: getMultipleProductPrices(
                                        e.data()["productVariation"],
                                        "originalPrice"),
                                    salePrice: getMultipleProductPrices(
                                        e.data()["productVariation"],
                                        "salePrice"),
                                  ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoublePriceTag extends StatelessWidget {
  final String originalPrice;
  final String salePrice;

  const DoublePriceTag({
    Key key,
    this.originalPrice,
    this.salePrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(40),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            originalPrice,
            style: TextStyle(
              decorationThickness: 2,
              color: mainBackgroundColor,
              decoration: TextDecoration.lineThrough,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          salePrice,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
          ),
        )
      ],
    );
  }
}
