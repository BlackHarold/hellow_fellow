import 'package:flutter/material.dart';

import '../main.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset('assets/images/hello_logo.png', height: 45),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white38,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white38),
    ),
  );
}

TextStyle whiteTextStyleWithSize(double fontSize) {
  return TextStyle(
    color: Colors.white,
    fontSize: fontSize,
  );
}

TextStyle whiteTextStyle() {
  return TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  );
}

TextStyle white38TextStyle() {
  return TextStyle(
    color: Colors.white38,
  );
}

TextStyle white38TextStyleWithFontSize(double fontSize) {
  return TextStyle(
    color: Colors.white38,
    fontSize: fontSize,
  );
}

LinearGradient gradientButton() {
  return LinearGradient(colors: [gradientButtonColor, backgroundColor]);
}
