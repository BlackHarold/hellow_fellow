import 'package:email_validator/email_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/services/auth.dart';
import 'package:hello_fellow/widgets/app_bar_widget.dart';

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
  AuthMethods authMethods = new AuthMethods();

  final formKey = GlobalKey<FormState>();

  signInButtonPressed() {
    FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('error');
        } else if (snapshot.connectionState == ConnectionState.done) {
          print("state done");
        }
        return null;
      },
    );

    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoom(),
            ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (val) {
                  //bad request: RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-\/=?^_'{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                  return EmailValidator.validate(val)
                      ? null
                      : 'Please enter a valid email';
                },
                controller: emailTextEditingController,
                style: whiteTextStyle(),
                decoration: textFieldInputDecoration('email'),
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
    );
  }
}
