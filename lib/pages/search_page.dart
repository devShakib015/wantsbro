import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/Other%20Pages/loading.dart';
import 'package:wantsbro/custom_widgets/Product%20Details/product_details.dart';
import 'package:wantsbro/providers/product_provider.dart';

class SearchProducts extends SearchDelegate<String> {
  String result;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, result);
          // Navigator.pop(context);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future:
          Provider.of<ProductProvider>(context, listen: false).getAllProducts(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.data == null) {
          return Loading();
        } else {
          final data = snapshot.data;

          var sugg = data.where((element) {
            return element["title"]
                .toLowerCase()
                .contains(query.trim().toLowerCase());
          }).toList();

          sugg.shuffle();

          return Container(
            child: ListView.builder(
              itemCount: sugg.length > 10 ? 7 : sugg.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetails(
                        product: sugg.elementAt(index)["product"],
                        productID: sugg.elementAt(index)["id"],
                      ),
                    ),
                  );
                },
                child: Card(
                  child: ListTile(
                    leading: Container(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        width: 50,
                        child: Image.network(
                          sugg.elementAt(index)["imageUrl"],
                          fit: BoxFit.cover,
                        )),
                    title: Text(sugg.elementAt(index)["title"]),
                    subtitle: Text(sugg.elementAt(index)["category"]),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
