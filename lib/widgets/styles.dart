import 'package:flutter/material.dart';

const Color containerBackground = Color(0xFF112734);
const Color backgroundColor = Color(0xFF283F4D);
const Color gradientButtonColor = Color(0xFF004875);

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