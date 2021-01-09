import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUsersByUserName(String name) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<QuerySnapshot> futureQuerySnapshot =
        users.where('name', isEqualTo: name).get();

    return futureQuerySnapshot;
  }

  getUserByUserEmail(String email) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<QuerySnapshot> futureQuerySnapshot =
        users.where('email', isEqualTo: email).get();
    futureQuerySnapshot.then((value) => print(value.docs));
    return futureQuerySnapshot;
  }

  ///userMap = {'name','email'}
  uploadUserInfo(userMap) async {
    await FirebaseFirestore.instance
        .collection('users')
        .add(userMap)
        .catchError((e) {
      print(e.toString);
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) => print(e.toString()));
  }

  /// Sending message to Cloud FireStore path is:
  /// chat_room/'receiver username'_'self email'/chats (hash)/Map{$message, $sendBy}
  getConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }
}
