import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/helpfunctions.dart';
import 'package:hello_fellow/services/auth.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/views/chatroom.dart';
import 'package:hello_fellow/widgets/app_bar_widget.dart';
import 'package:hello_fellow/widgets/styles.dart';

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  // HelperFunctions helpFunctions = new HelperFunctions();

  final formKey = GlobalKey<FormState>();

  TextEditingController userNameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signUpButtonPressed() {
    if (formKey.currentState.validate()) {
      Map<String, String> userInfoMap = {
        'name': userNameTextEditingController.text,
        'email': emailTextEditingController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(
          userNameTextEditingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) {
        databaseMethods.uploadUserInfo(userInfoMap);
        HelperFunctions.saveUserLoggedInSharedPreference(true);
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
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
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
                                return val.isEmpty || val.length < 4
                                    ? 'Incorrect user name ('
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: whiteTextStyle(),
                              decoration: textFieldInputDecoration('username'),
                            ),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        // Padding(
                        // padding: const EdgeInsets.only(left: 200),
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'Forgot password?',
                            style: white38TextStyleWithFontSize(14.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      ///Sign Up button
                      GestureDetector(
                        onTap: () {
                          signUpButtonPressed();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: gradientButton(),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Text(
                            'Sing Up',
                            style: whiteTextStyleWithSize(18.0),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),

                      ///Sing Up with Google
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: gradientButton(),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          'Sing Up with Google',
                          style: whiteTextStyleWithSize(18.0),
                        ),
                      ),
                      SizedBox(height: 8),

                      ///Already has account row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have account? ',
                            style: whiteTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'SignIn now',
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
