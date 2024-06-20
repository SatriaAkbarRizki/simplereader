import 'package:flutter/material.dart';

class MyTheme {
  var lightTheme = ThemeData(
      scaffoldBackgroundColor: const Color(0xffFDFCFA),
      textTheme: const TextTheme(
          titleMedium: TextStyle(
              fontSize: 26,
              fontFamily: 'GideonRoman',
              fontWeight: FontWeight.w800),
          labelSmall: TextStyle(
              fontSize: 12,
              fontFamily: 'PublicSans',
              fontWeight: FontWeight.w600),
          labelMedium: TextStyle(fontSize: 14)),
      popupMenuTheme: const PopupMenuThemeData(color: Color(0xffFDFCFA)));
}
