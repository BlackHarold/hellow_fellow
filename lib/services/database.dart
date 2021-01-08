import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUsersByUserName(String username) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    Future<QuerySnapshot> futureQuerySnapshot =
        users.where('name', isEqualTo: username).get();
    // return await FirebaseFirestore.instance
    //     .collection('users')
    //     .where('name', isEqualTo: username)
    //     .get()
    //     .then((value) {
    //   print(value);
    // });
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
}
