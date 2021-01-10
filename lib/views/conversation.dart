import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/constants.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/widgets/app_bar_widget.dart';

import '../main.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextController = new TextEditingController();

  Query queryMessages;

  Widget chatMessageList() {
    return StreamBuilder<QuerySnapshot>(
      stream: queryMessages.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        return ListView(
          children:
              snapshot.data.documents.map((DocumentSnapshot documentSnapshot) {
            return MessageTile(documentSnapshot.data()['message']);
          }).toList(),
        );
      },
    );
  }

  sendMessage() {
    if (messageTextController.text.isNotEmpty &&
        messageTextController.text != '') {
      Map<String, dynamic> messageMap = {
        'message': messageTextController.text,
        'sendBy': Constants.localName,
        'isUnread': true,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextController.text = '';
    }
  }

  @override
  void initState() {
    setState(() {
      queryMessages =
          databaseMethods.getConversationMessages(widget.chatRoomId);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Column(
        children: <Widget>[
          Container(
            height: 350,
            child: chatMessageList(),
          ),
          Container(
            height: 50,
            alignment: Alignment.bottomCenter,
            color: backgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageTextController,
                    decoration: textFieldInputDecoration("Message. . ."),
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: gradientButtonColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.white54,
                      size: 25.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;

  MessageTile(this.message);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: new Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
