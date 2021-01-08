import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

const Color containerBackground = Color(0xFF112734);
const Color backgroundColor = Color(0xFF283F4D);
const Color gradientButtonColor = Color(0xFF004875);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello Fellow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        scaffoldBackgroundColor: containerBackground,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: SignIn(),
      // home: SignUp(),
      home: Authenticate(),
    );
  }
}
