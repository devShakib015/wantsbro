import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wantsbro/custom_widgets/show_dialog.dart';
import 'package:wantsbro/providers/auth_provider.dart';
import 'package:wantsbro/theming/color_constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        opacity: 0,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You must sign in \nto view this page",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              googleSignInButton(context),
            ],
          ),
        ),
      ),
    );
  }

  //! Google Sign In button

  Widget googleSignInButton(BuildContext context) {
    return MaterialButton(
      splashColor: mainColor,
      padding: EdgeInsets.all(16.0),
      color: Color(0xff4081EC),
      onPressed: () async {
        setState(() {
          _showSpinner = true;
        });
        try {
          await Provider.of<AuthProvider>(context, listen: false)
              .signInWithGoogle();
        } catch (e) {
          setState(() {
            _showSpinner = false;
          });
          print("Errrrrrrrorrrrr: $e");
          showErrorDialog(
              context, "There is an error while singing you in. Sorry!");
        }
      },
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Image.asset(
              'assets/images/google.png',
              height: MediaQuery.of(context).size.height * 0.04,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Sign In With Google",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
