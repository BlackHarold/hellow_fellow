import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hello_fellow/views/signin.dart';
import 'package:hello_fellow/views/signup.dart';

// void main() => runApp(MyApp());

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

const Color containerBackground = Color(0xFF112734);
const Color backgroundColor = Color(0xFF283F4D);
const Color gradientButtonColor = Color(0xFF004875);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Hello Fellow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        scaffoldBackgroundColor: containerBackground,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: SignIn(),
      home: SignUp(),
    );
  }
}

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           iconSize: 30.0,
//           color: Colors.white,
//           onPressed: () {},
//         ),
//         title: Text(
//           'Chats',
//           style: TextStyle(
//             fontSize: 28.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.search),
//             iconSize: 30.0,
//             onPressed: () {},
//           ),
//         ],
//       ),
//       backgroundColor: backgroundColor,
//       body: Column(
//         children: <Widget>[
//           CategoriesSelector(),
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: containerBackground,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30.0),
//                   topRight: Radius.circular(30.0),
//                 ),
//               ),
//               child: Column(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20.0, vertical: 10.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text(
//                           'Favorite Contacts',
//                           style: TextStyle(
//                             fontSize: 18.0,
//                             color: Colors.white54,
//                             fontWeight: FontWeight.w400,
//                             letterSpacing: 0.8,
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.more_horiz),
//                           iconSize: 40.0,
//                           color: Colors.white54,
//                           onPressed: () {},
//                         ),
//                       ],
//                     ),
//                   ),
//                   FavoriteContacts(),
//                   MenuChat(),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
