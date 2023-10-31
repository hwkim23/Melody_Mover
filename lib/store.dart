import 'package:flutter/cupertino.dart';

class Store1 extends ChangeNotifier {
  int selectedIndex = 1;

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}