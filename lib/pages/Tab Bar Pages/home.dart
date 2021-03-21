import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/custom_widgets/product_grid_view.dart';
import 'package:wantsbro/providers/product_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class Home extends StatelessWidget {
  final List<String> images = [
    "https://firebasestorage.googleapis.com/v0/b/wantsbro-73b9b.appspot.com/o/Display%20Pictures%2Fhuman.jpg?alt=media&token=1e92635c-796e-436e-a08d-7fcea45a4d89",
    "https://firebasestorage.googleapis.com/v0/b/wantsbro-73b9b.appspot.com/o/Display%20Pictures%2Fmeans.jpg?alt=media&token=aafd8cfb-8ace-41e9-971f-2ff45c572f87",
    "https://firebasestorage.googleapis.com/v0/b/wantsbro-73b9b.appspot.com/o/Display%20Pictures%2FWelcome%20To%20wantsBro.jpg?alt=media&token=5985a5a7-c83d-42a3-a439-ce20bd2e9be8",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Swiper(
                itemCount: images.length,
                itemWidth: MediaQuery.of(context).size.width * 0.83,
                layout: SwiperLayout.STACK,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: mainColor,
                      child: Image.network(
                        images[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: Provider.of<ProductProvider>(context).allProducts,
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
                        child: Container(
                          width: 100,
                          child: Image.asset('assets/images/load.gif'),
                        ),
                      );
                    } else {
                      final productDataList = snapshot.data.docs;
                      productDataList.shuffle();

                      if (productDataList.isNotEmpty) {
                        return ProductGridView(
                            productDataList: productDataList);
                      } else {
                        return Container(
                          child: Center(
                            child: Text("No Products"),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
