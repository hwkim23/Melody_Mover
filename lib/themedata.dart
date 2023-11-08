import 'package:flutter/material.dart';

class MyThemeData {
  ThemeData themedata = ThemeData(
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          highlightColor: Colors.blue
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.black
    )
  );
}
