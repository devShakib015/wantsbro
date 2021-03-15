import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/pages/Tab%20Bar%20Pages/category%20pages/category.dart';
import 'package:wantsbro/pages/Tab%20Bar%20Pages/dashboard.dart';
import 'package:wantsbro/pages/Tab%20Bar%20Pages/favourites.dart';
import 'package:wantsbro/pages/Tab%20Bar%20Pages/home.dart';
import 'package:wantsbro/pages/cart_page.dart';
import 'package:wantsbro/pages/landing_page.dart';
import 'package:wantsbro/providers/cart_provider.dart';
import 'package:wantsbro/providers/tabBar_nav_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class App extends StatelessWidget {
// !Void Callbacks

  void _goToCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LandinPage(
          pushedPage: CartPage(),
        ),
      ),
    );
  }

  void _searchProducts() {}
  void _contactUs() {}
  void _aboutUs() {}
  void _rateOurApp() {}
  void _likeUsOnFacebook() {}
  void _getHelp() {}
  void _privacyPolicy() {}
  void _termsAndConditions() {}

// !Build Method
  @override
  Widget build(BuildContext context) {
    int _currentIndex = Provider.of<TabBarNavProvider>(context).currentIndex;
    return Scaffold(
      appBar: appBar(context),
      drawer: drawer(context),
      bottomNavigationBar: navigationBar(context, _currentIndex),
      body: toggleNavigation(_currentIndex),
    );
  }

// !Drawer

  Widget drawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Image.asset(
                'assets/images/logo/logo.png',
                width: MediaQuery.of(context).size.width * 0.2,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  onTap: _contactUs,
                  leading: Icon(Icons.phone),
                  title: Text('Contact Us'),
                ),
                ListTile(
                  onTap: _aboutUs,
                  leading: Icon(Icons.business),
                  title: Text('About Us'),
                ),
                ListTile(
                  onTap: _rateOurApp,
                  leading: Icon(Icons.star_rate),
                  title: Text('Rate our app'),
                ),
                ListTile(
                  onTap: _likeUsOnFacebook,
                  leading: Icon(Icons.thumb_up),
                  title: Text('Like Us On Facebook'),
                ),
                ListTile(
                  onTap: _getHelp,
                  leading: Icon(Icons.help),
                  title: Text('Need Help?'),
                ),
                ListTile(
                  onTap: _privacyPolicy,
                  leading: Icon(Icons.privacy_tip),
                  title: Text('Privacy Policy'),
                ),
                ListTile(
                  onTap: _termsAndConditions,
                  leading: Icon(Icons.description),
                  title: Text('Terms and conditions'),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text("Copyright © wantsBro | ${DateTime.now().year}"),
          ),
        ],
      ),
    );
  }

// !Appbar

  Widget appBar(BuildContext context) {
    return AppBar(
      title: appBarSearchBar(),
      actions: [
        appBarCartButton(context),
      ],
    );
  }

  //! Appbar Cart Button

  Widget appBarCartButton(BuildContext context) {
    return MaterialButton(
      minWidth: double.minPositive,
      padding: EdgeInsets.symmetric(horizontal: 16),
      onPressed: () => _goToCart(context),
      child: Badge(
        badgeColor: mainColor,
        elevation: 5,
        position: BadgePosition(top: 5, end: -10),
        padding: EdgeInsets.all(5),
        badgeContent: FirebaseAuth.instance.currentUser != null
            ? StreamBuilder<QuerySnapshot>(
                stream:
                    Provider.of<CartProvider>(context).getCartItems(context),
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
        animationType: BadgeAnimationType.scale,
        child: Icon(Icons.shopping_basket),
      ),
    );
  }

  //! Appbar Search bar

  Widget appBarSearchBar() {
    return MaterialButton(
      minWidth: double.maxFinite,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: StadiumBorder(
        side: BorderSide(width: 2, color: mainColor),
      ),
      onPressed: _searchProducts,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.search),
          SizedBox(
            width: 10,
          ),
          Flexible(child: Text("Search products")),
        ],
      ),
    );
  }

// !Bottom Navigation Bar

  Widget navigationBar(BuildContext context, int index) {
    return BottomNavigationBar(
      selectedItemColor: white,
      unselectedItemColor: disableWhite,
      onTap: (int value) {
        Provider.of<TabBarNavProvider>(context, listen: false)
            .updateIndex(value);
      },
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
          backgroundColor: mainBackgroundColor,
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          backgroundColor: Colors.teal,
          icon: Icon(Icons.category_outlined),
          activeIcon: Icon(Icons.category),
          label: "Categories",
        ),
        BottomNavigationBarItem(
          backgroundColor: mainColor,
          icon: Icon(Icons.favorite_outline),
          activeIcon: Icon(Icons.favorite),
          label: "Favourites",
        ),
        BottomNavigationBarItem(
          backgroundColor: Color(0xff088DC9),
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: "Dashboard",
        ),
      ],
    );
  }

// !NavigationToggle

  Widget toggleNavigation(int index) {
    if (index == 0) {
      return Home();
    } else if (index == 1) {
      return Category();
    } else if (index == 2) {
      return LandinPage(
        pushedPage: Favourites(),
      );
    } else
      return LandinPage(
        pushedPage: Dashboard(),
      );
  }
}
