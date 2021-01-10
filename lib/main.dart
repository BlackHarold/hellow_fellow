import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/views/chatroom.dart';
import 'package:hello_fellow/widgets/styles.dart';

import 'helper/authenticate.dart';
import 'helper/helpfunctions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool userIsLoggedIn = false;
  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference()
        .then((value) => setState(() {
              userIsLoggedIn = value;
              print('getLoggedInState $value');
            }));
  }

  @override
  Widget build(BuildContext context) {
    HelperFunctions.getUserLoggedInSharedPreference()
        .then((value) => userIsLoggedIn = value);
    print('$userIsLoggedIn');
    return MaterialApp(
      title: 'Hello Fellow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        scaffoldBackgroundColor: containerBackground,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ? ChatRoom() : Authenticate(),
    );
  }
}
