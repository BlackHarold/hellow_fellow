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

  Widget chatMessageList() {
    return null;
  }

  sendMessage() {
    if (messageTextController.text.isNotEmpty &&
        messageTextController.text != '') {
      Map<String, String> messageMap = {
        'message': messageTextController.text,
        'sendBy': Constants.localName
      };
      databaseMethods.getConversationMessages(widget.chatRoomId, messageMap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            Container(
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
                      // initiateSearch(searchTextEditingController.text);
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
      ),
    );
  }
}
