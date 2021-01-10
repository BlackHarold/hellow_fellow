import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/authenticate.dart';
import 'package:hello_fellow/helper/constants.dart';
import 'package:hello_fellow/helper/share_preferences.dart';
import 'package:hello_fellow/services/auth.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/views/search.dart';
import 'package:hello_fellow/widgets/chatList.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Query queryChats;

  @override
  void initState() {
    setState(() {
      HelperFunctions.getUserNameSharedPreference().then((value) {
        Constants.localName = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    queryChats = databaseMethods.getChatRooms(Constants.localName);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/hello_logo.png', height: 45),
        actions: [
          GestureDetector(
            onTap: () {
              print('exit button pushed');
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: ChatList(queryChats),
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
