import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/Other%20Pages/something_went_wrong.dart';
import 'package:wantsbro/custom_widgets/custom_tappable_card_widget.dart';
import 'package:wantsbro/pages/Tab Bar Pages/dashboardPages/profile.dart';
import 'package:wantsbro/pages/Tab%20Bar%20Pages/dashboardPages/addresses.dart';
import 'package:wantsbro/providers/auth_provider.dart';
import 'package:wantsbro/providers/user_provider.dart';

class Dashboard extends StatelessWidget {
//! Void Callbacks

  void _goToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Profile(),
        fullscreenDialog: true,
      ),
    );
  }

  void _goToAddressesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressesPage(),
      ),
    );
  }

  void _logOut(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out Confirmation'),
          content: Text("Are You Sure Want To Log Out?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("Yes"),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).signOut();
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _currentUser = Provider.of<AuthProvider>(context).currentUser;

    return FutureBuilder<Map>(
      future: Provider.of<UserProvider>(context).getUser(_currentUser),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return SomethingWentWrong();
        } else {
          final userData = snapshot.data;

          return Column(
            children: [
              _dashboardTop(userData),
              _dashboardBottom(context),
            ],
          );
        }
      },
    );
  }

//! Top part of the profile page
  Widget _dashboardTop(Map data) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(data["dp"]),
            maxRadius: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            data["name"],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            data["email"],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Divider(
            height: 50,
            thickness: 2,
          )
        ],
      ),
    );
  }

  //! Bottom part of the profile page

  Widget _dashboardBottom(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        children: [
          CustomTappableCard(
            icon: Icons.person,
            label: "Profile",
            onTap: () => _goToProfile(context),
          ),
          CustomTappableCard(
            icon: Icons.subject,
            label: "Orders",
            onTap: () {},
          ),
          CustomTappableCard(
            icon: Icons.location_on,
            label: "Addresses",
            onTap: () => _goToAddressesPage(context),
          ),
          CustomTappableCard(
            icon: Icons.message,
            label: "Messages",
            onTap: () {},
          ),
          CustomTappableCard(
            icon: Icons.payment,
            label: "Payment History",
            onTap: () {},
          ),
          CustomTappableCard(
            icon: Icons.logout,
            label: "Logout",
            onTap: () => _logOut(context),
          ),
        ],
      ),
    );
  }
}
