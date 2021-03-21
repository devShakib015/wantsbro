import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/Other%20Pages/loading.dart';
import 'package:wantsbro/pages/Tab%20Bar%20Pages/category%20pages/product_with_category.dart';
import 'package:wantsbro/providers/category_provider.dart';

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Provider.of<CategoryProvider>(context).getParentCategories(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text("Error Fetching data"),
              ),
            );
          } else {
            if (!snapshot.hasData) {
              return Center(
                child: Loading(),
              );
            } else {
              final dataList = snapshot.data.docs;

              if (dataList.isNotEmpty) {
                return GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisCount: 3,
                  children: dataList
                      .map(
                        (e) => _categoryCard(
                          name: e.data()["name"],
                          context: context,
                          id: e.id,
                          url: e.data()["imageUrl"],
                        ),
                      )
                      .toList(),
                );
              } else {
                return Container(
                  child: Center(
                    child: Text("No Categories"),
                  ),
                );
              }
            }
          }
        });
  }

  Widget _categoryCard(
      {BuildContext context, String id, String name, String url}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductWithCategory(
              categoryId: id,
              categoryName: name,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 5,
          shadowColor: Colors.red,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
