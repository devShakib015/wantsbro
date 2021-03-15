import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/models/cart_model.dart';
import 'package:wantsbro/pages/cart_page.dart';
import 'package:wantsbro/pages/landing_page.dart';
import 'package:wantsbro/providers/cart_provider.dart';
import 'package:wantsbro/providers/fav_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class ProductDetails extends StatefulWidget {
  final Map<String, dynamic> product;
  final String productID;

  const ProductDetails({
    Key key,
    this.product,
    this.productID,
  }) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
//! variables for cart
  int _selectedIndex = 0;
  int _count = 1;

//! variables
  int _currentImage = 1;

//! Void Callbacks

//! add to cart callbacks
  void _addToCart() async {
    if (FirebaseAuth.instance.currentUser == null) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              child: Center(child: Text("Please login first."))),
        ),
      );
    } else {
      if (widget.product["isSingle"]) {
        await Provider.of<CartProvider>(context, listen: false).addToCart(
            context,
            CartModel(
              count: _count,
              isSingle: true,
              productID: widget.productID,
              totalPrice: (widget.product["salePrice"] == 0.0
                  ? (widget.product["originalPrice"] * _count)
                  : (widget.product["salePrice"] * _count)),
            ));
      } else {
        await Provider.of<CartProvider>(context, listen: false).addToCart(
          context,
          CartModel(
            count: _count,
            isSingle: false,
            productID: widget.productID,
            variationIndex: _selectedIndex,
            totalPrice: (widget.product["productVariation"][_selectedIndex]
                        ["salePrice"] ==
                    0.0
                ? (widget.product["productVariation"][_selectedIndex]
                        ["originalPrice"] *
                    _count)
                : (widget.product["productVariation"][_selectedIndex]
                        ["salePrice"] *
                    _count)),
          ),
        );
      }
    }
  }

//! go to cart callbacks
  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandinPage(
          pushedPage: CartPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> product = widget.product;
    int _numberOfFI = product["featuredImages"].length;
    final _pageController = PageController();
    return Scaffold(
      bottomNavigationBar: _productDetailsBottomAppBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _addToCartButton(),
      body: CustomScrollView(
        slivers: [
          _productFeaturedImagesSection(
              context, _pageController, _numberOfFI, product),
          SliverToBoxAdapter(
            child: _productDetailsBody(product),
          )
        ],
      ),
    );
  }

//! Product Details Body
  Container _productDetailsBody(Map<String, dynamic> product) {
    List<dynamic> productVariation = product["productVariation"];
    return Container(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 5,
            ),
            Text(
                "${product["parentCategoryName"]} - ${product["childCategoryName"]}"),
            SizedBox(
              height: 5,
            ),
            Text(
              "${product["title"]}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(
              height: 5,
            ),

            product["isSingle"]
                ? _singleProductBody(product)
                : _multipleProductBody(productVariation),

            SizedBox(
              height: 5,
            ),

            //! Product review Will come here

            SizedBox(
              height: 5,
            ),
            Text(
              "Description: \n${product["description"]}",
            ),
            SizedBox(
              height: 5,
            ),
            product["descImages"] != null
                ? Column(
                    children: [
                      for (var i = 0; i < product["descImages"].length; i++)
                        Image.network(product["descImages"][i])
                    ],
                  )
                : Container(
                    height: 200,
                    width: double.infinity,
                    child: Center(
                      child: Text("No Images found"),
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Container _multipleProductBody(List<dynamic> productVariation) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 200,
                  height: 200,
                  child: Image.network(
                      productVariation[_selectedIndex]["variationImageUrl"],
                      fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                          Widget child, ImageChunkEvent loadingProgress) {
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
                  }),
                ),
              ),
              Expanded(
                child: Container(
                    child: Column(
                  children: [
                    Column(
                      children: productVariation[_selectedIndex]["salePrice"] ==
                              0.0
                          ? [
                              Text(
                                productVariation[_selectedIndex]
                                        ["originalPrice"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amberAccent),
                              ),
                            ]
                          : [
                              Text(
                                productVariation[_selectedIndex]
                                        ["originalPrice"]
                                    .toString(),
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                productVariation[_selectedIndex]["salePrice"]
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amberAccent),
                              ),
                            ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        "In Stock: ${productVariation[_selectedIndex]["stockCount"]}"),
                    Text(
                        "Total Sold: ${productVariation[_selectedIndex]["soldCount"]}"),
                  ],
                )),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    if (_count > 1) {
                      setState(() {
                        _count--;
                      });
                    }
                  },
                  child: Icon(Icons.remove),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(_count.toString()),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    if (_count <
                        productVariation[_selectedIndex]["stockCount"]) {
                      setState(() {
                        _count++;
                      });
                    }
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: productVariation
                  .map((e) => MaterialButton(
                        color: productVariation.indexOf(e) == _selectedIndex
                            ? mainColor
                            : null,
                        onPressed: () {
                          setState(() {
                            _count = 1;
                            _selectedIndex = productVariation.indexOf(e);
                          });
                        },
                        child: e["attributes"].keys.toList()[0] == "color" ||
                                e["attributes"].keys.toList()[1] == "color"
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border:
                                            Border.all(width: 2, color: white),
                                        color: Color(int.parse(
                                            e["attributes"]["color"]
                                                .split('(0x')[1]
                                                .split(')')[0],
                                            radix: 16)),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      e["attributes"][
                                          "${e["attributes"].keys.toList()[0] == "color" ? e["attributes"].keys.toList()[1] : e["attributes"].keys.toList()[0]}"],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  children: [
                                    Text(
                                        e["attributes"][
                                            "${e["attributes"].keys.toList()[0]}"],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      e["attributes"][
                                          "${e["attributes"].keys.toList()[1]}"],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                      ))
                  .toList(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Container _singleProductBody(Map<String, dynamic> product) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 10,
          ),
          product["salePrice"] != 0.0
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("Original Price: "),
                        Text(
                          "${product["originalPrice"]}",
                          style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Sale Price: "),
                        Text(
                          "${product["salePrice"]}",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text("Original Price: "),
                    Text(
                      "${product["originalPrice"]}",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.amberAccent),
                    ),
                  ],
                ),
          SizedBox(
            height: 10,
          ),
          Text("Weight: ${product["weight"]}"),
          Text("Size: ${product["size"]}"),
          Text("In Stock: ${product["stockCount"]}"),
          Text("Total Sold: ${product["soldCount"]}"),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    if (_count > 1) {
                      setState(() {
                        _count--;
                      });
                    }
                  },
                  child: Icon(Icons.remove),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(_count.toString()),
                SizedBox(
                  width: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    if (_count < product["stockCount"]) {
                      setState(() {
                        _count++;
                      });
                    }
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

//! Add to cart Button
  FloatingActionButton _addToCartButton() {
    return FloatingActionButton(
      child: Icon(Icons.add_shopping_cart),
      onPressed: _addToCart,
      tooltip: "Add to Cart",
    );
  }

//! Bottom App Bar
  BottomAppBar _productDetailsBottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Row(
          children: [
            _addToFavButton(context),
            _cartButton(),
          ],
        ),
      ),
      shape: CircularNotchedRectangle(),
    );
  }

//! Cart Buttton
  MaterialButton _cartButton() {
    return MaterialButton(
      onPressed: _goToCart,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: disableWhite,
            )),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border:
                      Border(right: BorderSide(width: 2, color: disableWhite))),
              child: Text(
                "My Cart",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: FirebaseAuth.instance.currentUser != null
                  ? StreamBuilder<QuerySnapshot>(
                      stream: Provider.of<CartProvider>(context)
                          .getCartItems(context),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Text("0");
                        } else if (snapshot.hasError) {
                          return Text("0");
                        } else {
                          return Container(
                            child: Text(snapshot.data.docs.length.toString()),
                          );
                        }
                      },
                    )
                  : Text("0"),
            ),
          ],
        ),
      ),
    );
  }

//! Add to favourite button
  ClipPath _addToFavButton(BuildContext context) {
    return ClipPath(
      clipper: SkewCut(),
      child: Container(
          padding: EdgeInsets.only(right: 10),
          height: double.infinity,
          width: MediaQuery.of(context).size.width * 0.3,
          color: Colors.amber,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: Provider.of<FavProvider>(context).getFavItems(context),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.black,
                      size: 36,
                    );
                  } else if (snapshot.hasError) {
                    return Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.black,
                      size: 36,
                    );
                  } else {
                    var _favList = [];
                    final favDataList = snapshot.data.docs;

                    for (var i = 0; i < favDataList.length; i++) {
                      _favList.add(favDataList[i].data()["productID"]);
                    }
                    if (_favList.contains(widget.productID)) {
                      return GestureDetector(
                        onTap: () {
                          if (FirebaseAuth.instance.currentUser != null) {
                            Provider.of<FavProvider>(context, listen: false)
                                .deleteItemFromFav(context, widget.productID);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Center(
                                        child: Text("Please login first."))),
                              ),
                            );
                          }
                        },
                        child: Icon(
                          Icons.favorite,
                          color: mainColor,
                          size: 36,
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () {
                          if (FirebaseAuth.instance.currentUser != null) {
                            Provider.of<FavProvider>(context, listen: false)
                                .addToFav(context, widget.productID);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Center(
                                        child: Text("Please login first."))),
                              ),
                            );
                          }
                        },
                        child: Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.black,
                          size: 36,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          )),
    );
  }

//! Appbar with Featured Images
  SliverAppBar _productFeaturedImagesSection(
      BuildContext context,
      PageController _pageController,
      int _numberOfFI,
      Map<String, dynamic> product) {
    return SliverAppBar(
      elevation: 10,
      pinned: true,
      floating: false,
      expandedHeight: MediaQuery.of(context).size.height * 0.4,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.symmetric(horizontal: 50, vertical: 22),
        background: Container(
          child: Stack(
            children: [
              PageView(
                  onPageChanged: (n) {
                    setState(() {
                      _currentImage = n + 1;
                    });
                  },
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (var i = 0; i < _numberOfFI; i++)
                      Container(
                        child: Hero(
                          tag: product["title"],
                          child: Image.network(
                            product["featuredImages"][i],
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                  ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: mainBackgroundColor,
                      borderRadius: BorderRadius.circular(40)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Text(
                    "$_currentImage / $_numberOfFI",
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SkewCut extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);

    path.lineTo(size.width - 20, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(SkewCut oldClipper) => false;
}
