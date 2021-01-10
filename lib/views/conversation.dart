import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/constants.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/widgets/app_bar_widget.dart';
import 'package:hello_fellow/widgets/styles.dart';

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
          children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
            return MessageTile(documentSnapshot.data()['message'],
                documentSnapshot.data()['sendBy'] == Constants.localName);
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
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 24.0,
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
  final bool isSendByMe;

  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 24 : 8, right: isSendByMe ? 8 : 24),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      alignment: isSendByMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.white12 : Colors.blueGrey,
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20))
              : BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
