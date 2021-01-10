import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/share_preferences.dart';
import 'package:hello_fellow/views/signin.dart';
import 'package:hello_fellow/views/signup.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  void initState() {
    HelperFunctions.getUserNameSharedPreference().then(
        (value) => value != null ? showSignIn = true : showSignIn = false);
    print('init state: $showSignIn');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('show sign in: $showSignIn');
    HelperFunctions.getUserNameSharedPreference()
        .then((value) => print('user name toogle view: $value'));
    return showSignIn ? SignIn(toggleView) : SignUp(toggleView);
  }
}
