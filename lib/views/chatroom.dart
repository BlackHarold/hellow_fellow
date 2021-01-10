import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/authenticate.dart';
import 'package:hello_fellow/helper/constants.dart';
import 'package:hello_fellow/helper/helpfunctions.dart';
import 'package:hello_fellow/services/auth.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/views/conversation.dart';
import 'package:hello_fellow/views/search.dart';
import 'package:hello_fellow/widgets/styles.dart';

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
      getUserInfo();
      print('constants localName: ${Constants.localName}');
    });
    queryChats = databaseMethods.getChatRooms(Constants.localName);
    super.initState();
  }

  getUserInfo() async {
    Constants.localName = await HelperFunctions.getUserNameSharedPreference();
    print('localName: ${Constants.localName}');
  }

  Widget chatChatsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: queryChats.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
            return ChatsTile(documentSnapshot.data()['chatroomId']);
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/hello_logo.png', height: 45),
        actions: [
          GestureDetector(
            onTap: () {
              print('exit button pushed');
              HelperFunctions.saveUserLoggedInSharedPreference(false);
              Navigator.pushReplacement(
                  // context, MaterialPageRoute(builder: (context) => SignIn()));
                  context,
                  MaterialPageRoute(builder: (context) => Authenticate()));
              authMethods.signOut();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatChatsList(),
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

class ChatsTile extends StatelessWidget {
  final String chatRoom;

  ChatsTile(this.chatRoom);

  @override
  Widget build(BuildContext context) {
    print('chatRoom: $chatRoom');
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConversationScreen(chatRoom)),
        );
      },
      child: Container(
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                '${chatRoom.substring(0, 1).toUpperCase()}',
                style: whiteTextStyle(),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Container(
              child: Text(
                '${chatRoom.substring(0, chatRoom.indexOf('_'))}',
                style: whiteTextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
