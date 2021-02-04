import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/helper/constants.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/widgets/app_bar_widget.dart';
import 'package:hello_fellow/widgets/styles.dart';

import 'conversation.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;
  Widget searchWidget;

  Widget searchList() {
    if (searchSnapshot != null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView.builder(
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                userName: searchSnapshot.docs[index].data()['name'],
                userEmail: searchSnapshot.docs[index].data()['email'],
              );
            }),
        height: 350.0,
      );
    } else {
      return Container(
        height: 350.0,
      );
    }
  }

  initiateSearch(String userName) {
    Future<dynamic> futureQuerySnapshot =
        databaseMethods.getUsersByUserName(userName);

    futureQuerySnapshot.then((value) {
      searchSnapshot = value;
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  /// create chatroom, sent user to conversation screen, pushReplacement
  createChatRoomAndStartConversation({String userName}) {
    if (userName != Constants.localName) {
      String chatRoomId = getChatRoomId(userName, Constants.localName);
      List<String> users = [userName, Constants.localName];
      Map<String, dynamic> chatRoomMap = {
        'users': users,
        'chatroomId': chatRoomId
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId)));
    } else {
      print('you cannot sen message to yourself');
    }
  }

  Widget searchTile({String userName, String userEmail}) {
    return Container(
      child: Row(
        children: [
          Column(children: [
            Text(
              userName,
              style: whiteTextStyle(),
            ),
            Text(
              userEmail,
              style: whiteTextStyle(),
            )
          ]),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(
                userName: userName,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0)),
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text("Message"),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                color: backgroundColor,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchTextEditingController,
                        decoration:
                            textFieldInputDecoration("search user. . ."),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        initiateSearch(searchTextEditingController.text);
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: gradientButtonColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 5.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.white54,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  print('a: $a, b: $b');
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return '$b\_$a';
  } else {
    return '$a\_$b';
  }
}
