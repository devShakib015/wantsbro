import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/Other%20Pages/something_went_wrong.dart';
import 'package:wantsbro/custom_widgets/edit_phone.dart';
import 'package:wantsbro/providers/auth_provider.dart';
import 'package:wantsbro/providers/user_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';

class Profile extends StatelessWidget {
  void _updateName(BuildContext context, User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String newText;

        return AlertDialog(
          title: Text("Change your name"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newText = value;
                },
                decoration: InputDecoration(labelText: "New Name"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                Navigator.pop(context);
                if (newText != null) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateName(context, newText, user);
                }
              },
            )
          ],
        );
      },
    );
  }

  void _updatePhone(BuildContext context, User user) async {
    final number = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneNumberPage(),
        fullscreenDialog: true,
      ),
    );

    if (number != null) {
      Provider.of<UserProvider>(context, listen: false)
          .updatePhone(context, "$number", user);
    }
  }

  void _updateGender(BuildContext context, User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String newText;

        return AlertDialog(
          title: Text("What's your gender?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newText = value;
                },
                decoration: InputDecoration(
                    labelText: "Gender", hintText: "Male, Female or Others"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                Navigator.pop(context);
                if (newText != null) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateGender(context, newText, user);
                }
              },
            )
          ],
        );
      },
    );
  }

  void _updateOccupation(BuildContext context, User user) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        String newText;

        return AlertDialog(
          title: Text("Your Occupation..."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  newText = value;
                },
                decoration: InputDecoration(
                    labelText: "Occupation", hintText: "Student"),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: Text("Save"),
              onPressed: () {
                Navigator.pop(context);
                if (newText != null) {
                  Provider.of<UserProvider>(context, listen: false)
                      .updateOccupation(context, newText, user);
                }
              },
            )
          ],
        );
      },
    );
  }

  void _updateDateOfBirth(BuildContext context, User user) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950, 1),
        helpText: "Select Your BirthDay",
        lastDate: DateTime.now());

    if (picked != null) {
      Provider.of<UserProvider>(context, listen: false)
          .updateDateOfBirth(context, picked, user);
    }
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<AuthProvider>(context).currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: Provider.of<UserProvider>(context).getUserData(currentUser),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return SomethingWentWrong();
          } else {
            final data = snapshot.data.data();
            if (data != null) {
              DateTime date;
              if (data["dateOfBirth"] != null) {
                date = DateTime.fromMicrosecondsSinceEpoch(
                    data["dateOfBirth"].microsecondsSinceEpoch);
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(data["dpURL"]),
                          maxRadius: 50,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Customer ID : ${data["customerId"]}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          data["email"],
                          textAlign: TextAlign.center,
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
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        _profileListTile(
                          leadingIcon: Icons.perm_identity,
                          onTapTrailingIcon: () =>
                              _updateName(context, currentUser),
                          subtitle: data["name"],
                          title: "Name",
                          trailingIcon: Icons.edit,
                        ),
                        _profileListTile(
                          leadingIcon: Icons.phone,
                          onTapTrailingIcon: () =>
                              _updatePhone(context, currentUser),
                          subtitle: data["phone"] ?? "Not set",
                          title: "Phone",
                          trailingIcon: Icons.edit,
                        ),
                        _profileListTile(
                          leadingIcon: Icons.person_search,
                          onTapTrailingIcon: () =>
                              _updateGender(context, currentUser),
                          subtitle: data["gender"] ?? "Not Set",
                          title: "Gender",
                          trailingIcon: Icons.edit,
                        ),
                        _profileListTile(
                          leadingIcon: Icons.calendar_today,
                          onTapTrailingIcon: () =>
                              _updateDateOfBirth(context, currentUser),
                          subtitle: date != null
                              ? "${date.year}-${date.month}-${date.day}"
                              : "Not Set",
                          title: "Date Of Birthday",
                          trailingIcon: Icons.edit,
                        ),
                        _profileListTile(
                          leadingIcon: Icons.work_outline,
                          onTapTrailingIcon: () =>
                              _updateOccupation(context, currentUser),
                          subtitle: data["occupation"] ?? "Not Set",
                          title: "Occupation",
                          trailingIcon: Icons.edit,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else
              return SomethingWentWrong();
          }
        },
      ),
    );
  }

  Widget _profileListTile(
      {String title,
      String subtitle,
      IconData leadingIcon,
      IconData trailingIcon,
      Function onTapTrailingIcon}) {
    return Card(
      child: ListTile(
        tileColor: mainColor,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              leadingIcon,
              size: 30,
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: onTapTrailingIcon,
          icon: Icon(
            trailingIcon,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: disableWhite,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
