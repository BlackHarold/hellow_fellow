import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/authenticate.dart';
import 'package:hello_fellow/helper/constants.dart';
import 'package:hello_fellow/helper/share_preferences.dart';
import 'package:hello_fellow/services/auth.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/widgets/styles.dart';

import 'conversation.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream streamChats;

  @override
  void initState() {
    setState(() {
      getUserInfoChats();
    });
    super.initState();
  }

  getUserInfoChats() async {
    Constants.localName = await HelperFunctions.getUserNameSharedPreference();
    streamChats =
        DatabaseMethods().getChatRooms(Constants.localName).asStream();
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
      body: chatList(streamChats),
    );
  }

  Widget chatList(Stream stream) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          decoration: BoxDecoration(),
          child: StreamBuilder<QuerySnapshot>(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Text(
                    'Loading...',
                    style: opacityBlackTextStyle(),
                  ));
                }

                return ListView.builder(
                    padding: EdgeInsets.only(top: 20),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ChatTile(index, snapshot);
                    });
              }),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final int index;
  final AsyncSnapshot snapshot;

  ChatTile(this.index, this.snapshot);

  @override
  Widget build(BuildContext context) {
    String chatRoomId = snapshot.data.docs[index].data()['chatroomId'];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ConversationScreen(chatRoomId)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
            child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 10),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                height: 40.0,
                width: 40.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: getRandomColor(),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  getLiterate(chatRoomId),
                  style: whiteTextStyle(),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Text(cutChatRoomId(chatRoomId), style: whiteTextStyle()),
            ],
          ),
        )),
      ),
    );
  }

  String getLiterate(String string) {
    return string.substring(0, 1).toUpperCase();
  }

  String cutChatRoomId(String chatRoomId) {
    String cutString = chatRoomId.substring(0, chatRoomId.indexOf("_"));
    return cutString;
  }
}
