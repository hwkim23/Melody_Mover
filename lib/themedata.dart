import 'package:flutter/material.dart';

class MyThemeData {
  ThemeData themedata = ThemeData(
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          highlightColor: Colors.blue
        ),
      ),
      scaffoldBackgroundColor: const Color(0xffF8F8F8),
    iconTheme: const IconThemeData(
      color: Colors.black
    )
  );
}
