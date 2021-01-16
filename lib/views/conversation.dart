import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/constants.dart';
import 'package:hello_fellow/helper/share_preferences.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/widgets/app_bar_widget.dart';
import 'package:hello_fellow/widgets/styles.dart';

typedef double GetOffsetMethod();

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  ConversationScreen(this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageTextController = new TextEditingController();
  ScrollController scrollController = ScrollController();
  double listViewOffset = 0.0;
  GetOffsetMethod getOffsetMethod;
  Query queryMessages;

  @override
  void initState() {
    //Init scrolling to preserve it
    HelperFunctions.getState().then((value) => setOffset(value));
    scrollController =
    new ScrollController(initialScrollOffset: listViewOffset);
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                child: chatMessageList(),
              ),
            ),
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
                    scrollController
                        .jumpTo(scrollController.position.minScrollExtent);
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

  Widget chatMessageList() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
          ),
          child: StreamBuilder<QuerySnapshot>(
              stream: queryMessages.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting){
                  return Text('Loading..');
                }

                return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.only(top: 20),
                    controller: scrollController,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MessageTile(index,snapshot);
                    });
              }),
        ),
      ),
    );
  }

  sendMessage() {
    if (messageTextController.text.isNotEmpty &&
        messageTextController.text != '') {
      Map<String, dynamic> messageMap = {
        'message': messageTextController.text,
        'sendBy': Constants.localName,
        'isUnread': true,
        'time': DateTime
            .now()
            .millisecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageTextController.text = '';
    }
  }

  void setOffset(double offset) {
    this.listViewOffset = offset;
  }
}

class MessageTile extends StatelessWidget {
  final int index;
  final AsyncSnapshot snapshot;

  MessageTile(this.index, this.snapshot);

  @override
  Widget build(BuildContext context) {
    String message = snapshot.data.docs[index].data()['message'];
    bool isSendByMe = snapshot.data.docs[index].data()['sendBy'] ==
        Constants.localName;
    return Container(
      padding: EdgeInsets.only(
          left: isSendByMe ? 24 : 8, right: isSendByMe ? 8 : 24),
      width: MediaQuery
          .of(context)
          .size
          .width,
      margin: EdgeInsets.symmetric(vertical: 4.0),
      alignment: isSendByMe ? Alignment.bottomRight : Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.white12 : Colors.blueGrey,
          borderRadius: getBottomBySender(isSendByMe),
        ),
        child: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

BorderRadius getBottomBySender(bool isSendByMe) {
  return isSendByMe
      ? BorderRadius.only(
      topRight: Radius.circular(20),
      topLeft: Radius.circular(20),
      bottomLeft: Radius.circular(20))
      : BorderRadius.only(
      topLeft: Radius.circular(20),
      topRight: Radius.circular(20),
      bottomRight: Radius.circular(20));
}
