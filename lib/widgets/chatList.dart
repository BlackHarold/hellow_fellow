import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/views/conversation.dart';
import 'package:hello_fellow/widgets/styles.dart';

class ChatList extends StatelessWidget {
  // final Query queryChats;
  final Stream streamChats;

  ChatList(this.streamChats);

  @override
  Widget build(BuildContext context) {
    if (streamChats != null) {
      return StreamBuilder<QuerySnapshot>(
        stream: streamChats,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Loading...');
          }

          return ListView(
            children:
                snapshot.data.docs.map((DocumentSnapshot documentSnapshot) {
              return ChatsTile(documentSnapshot.data()['chatroomId']);
            }).toList(),
          );
        },
      );
    } else {
      return Container(
        height: 10,
      );
    }
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
