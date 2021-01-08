import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/services/database.dart';
import 'package:hello_fellow/widgets/app_bar_widget.dart';

import '../main.dart';

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

  searchList() {
    if(searchSnapshot!=null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: ListView.builder(
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return SearchTile(
                userName: searchSnapshot.docs[index].data()['name'],
                userEmail: searchSnapshot.docs[index].data()['email'],
              );
            }),
        height: 350.0,
      );
    } else{
      return Container(
        height: 350.0,
      );
    }
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
                        decoration: textFieldInputDecoration("search user. . ."),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
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

class SearchTile extends StatelessWidget {
  final String userName;
  final String userEmail;

  SearchTile({this.userName, this.userEmail});

  @override
  Widget build(BuildContext context) {
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
          Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30.0)),
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Text("Message"),
          )
        ],
      ),
    );
  }
}
