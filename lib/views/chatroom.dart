import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/authenticate.dart';
import 'package:hello_fellow/helper/constants.dart';
import 'package:hello_fellow/helper/helpfunctions.dart';
import 'package:hello_fellow/services/auth.dart';
import 'package:hello_fellow/views/search.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();

  @override
  void initState() {
    getUserInfo();
  }

  getUserInfo() async {
    Constants.localName = await HelperFunctions.getUserNameSharedPreference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/hello_logo.png', height: 45),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                  // context, MaterialPageRoute(builder: (context) => SignIn()));
                  context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),
    );
  }
}
