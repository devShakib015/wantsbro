import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/Other%20Pages/loading.dart';
import 'package:wantsbro/custom_widgets/product_grid_view.dart';
import 'package:wantsbro/providers/category_provider.dart';
import 'package:wantsbro/providers/product_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class ProductWithCategory extends StatefulWidget {
  final String categoryName;
  final String categoryId;
  const ProductWithCategory({
    Key key,
    this.categoryName,
    this.categoryId,
  }) : super(key: key);

  @override
  _ProductWithCategoryState createState() => _ProductWithCategoryState();
}

class _ProductWithCategoryState extends State<ProductWithCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Provider.of<CategoryProvider>(context)
            .getChildCategoriesByparentId(widget.categoryId),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text("Error Fetching data"),
              ),
            );
          } else {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              final dataList = snapshot.data.docs;

              if (dataList.isNotEmpty) {
                return DefaultTabController(
                  length: dataList.length,
                  child: Scaffold(
                      appBar: TabBar(
                        isScrollable: true,
                        labelPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        indicatorColor: mainColor,
                        labelColor: white,
                        tabs: dataList
                            .map((e) => Text(e.data()["name"]))
                            .toList(),
                      ),
                      body: ProductTabBarView(dataList: dataList)),
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
        },
      ),
    );
  }
}

class ProductTabBarView extends StatelessWidget {
  const ProductTabBarView({
    Key key,
    @required this.dataList,
  }) : super(key: key);

  final List<QueryDocumentSnapshot> dataList;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: dataList
          .map(
            (e) => StreamBuilder<QuerySnapshot>(
              stream: Provider.of<ProductProvider>(context)
                  .getProductsByCategory(e.id),
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
                    return Loading();
                  } else {
                    final productDataList = snapshot.data.docs;
                    productDataList.shuffle();

                    if (productDataList.isNotEmpty) {
                      return ProductGridView(productDataList: productDataList);
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
          .toList(),
    );
  }
}
