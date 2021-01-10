import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/helpfunctions.dart';
import 'package:hello_fellow/model/user.dart';
import 'package:hello_fellow/services/auth.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/widgets/app_bar_widget.dart';
import 'package:hello_fellow/widgets/styles.dart';

import 'chatroom.dart';

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;

  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  AuthMethods authMethods = new AuthMethods();

  final formKey = GlobalKey<FormState>();

  QuerySnapshot signInSnapshot;

  signInButtonPressed() {
    if (formKey.currentState.validate()) {
      String email = emailTextEditingController.text;
      String password = passwordTextEditingController.text;
      print('email: $email');
      HelperFunctions.saveUserEmailSharedPreference(email);

      print('future step');
      Future<dynamic> futureQuerySnapshot =
          databaseMethods.getUserByUserEmail(email);
      futureQuerySnapshot.then((value) {
        signInSnapshot = value;
        HelperFunctions.saveUserEmailSharedPreference(
            signInSnapshot.docs[0].data()['email']);
        HelperFunctions.saveUserNameSharedPreference(
            signInSnapshot.docs[0].data()['name']);
      });

      setState(() {
        isLoading = true;
      });

      print('auth step');
      authMethods.signInWithEmailAndPassword(email, password).then((value) {
        if (value != null) {
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          UserObject signingUser = value;
          print('$signingUser');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChatRoom(),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          print('email validator $val');
                          //bad request: RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-\/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                          return EmailValidator.validate(val)
                              ? null
                              : 'Please enter a valid email';
                        },
                        controller: emailTextEditingController,
                        style: whiteTextStyle(),
                        decoration: textFieldInputDecoration('email'),
                      ),
                    ],
                  ),
                ),
                TextFormField(
                  obscureText: true,
                  validator: (val) {
                    return val.length > 6
                        ? null
                        : "Please provide password more than 6 characters";
                  },
                  controller: passwordTextEditingController,
                  style: whiteTextStyle(),
                  decoration: textFieldInputDecoration('password'),
                ),
                SizedBox(height: 8),
                Container(
                  // Padding(
                  // padding: const EdgeInsets.only(left: 200),
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      'Forgot password?',
                      style: white38TextStyleWithFontSize(14.0),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    signInButtonPressed();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        gradient: gradientButton(),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Text(
                      'Sing In',
                      style: whiteTextStyleWithSize(18.0),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      gradient: gradientButton(),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Text(
                    'Sing In with Google',
                    style: whiteTextStyleWithSize(18.0),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have account? ',
                      style: whiteTextStyle(),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
