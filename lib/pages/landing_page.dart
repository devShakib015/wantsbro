import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/providers/auth_provider.dart';
import 'package:wantsbro/pages/sign_in_page.dart';
import 'package:wantsbro/providers/user_provider.dart';

class LandinPage extends StatelessWidget {
  final Widget pushedPage;

  const LandinPage({
    Key key,
    @required this.pushedPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    return FutureBuilder(
      future: Provider.of<UserProvider>(context).addUser(user, context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Provider.of<AuthProvider>(context).isLoggedIn()
            ? pushedPage
            : SignInPage();
      },
    );
  }
}
