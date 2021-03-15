import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/custom_widgets/Product%20Details/product_details.dart';
import 'package:wantsbro/providers/fav_provider.dart';
import 'package:wantsbro/providers/product_provider.dart';

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<FavProvider>(context).getFavItems(context),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error fetching data"),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final dataList = snapshot.data.docs;
          if (dataList.isNotEmpty) {
            return Container(
              child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(dataList[index].id),
                      onDismissed: (direction) async {
                        await Provider.of<FavProvider>(context, listen: false)
                            .deleteItemFromFav(context, dataList[index].id);
                      },
                      background: Container(
                        child: Center(
                          child: Text("Delete Item From Favourites"),
                        ),
                      ),
                      child: Card(
                        child: FutureBuilder<DocumentSnapshot>(
                          future: Provider.of<ProductProvider>(context)
                              .getProductById(dataList[index].id),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text("Loading..."),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error!!!"),
                              );
                            } else {
                              final productData = snapshot.data.data();
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                        product: productData,
                                        productID: dataList[index].id,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    title: Text(
                                      productData["title"],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      productData["description"],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        child: Image.network(
                                          productData["featuredImages"][0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Center(
              child: Text("No Favourite Products"),
            );
          }
        }
      },
    );
  }
}
