import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:melody_mover/pages/home.dart';
import 'package:melody_mover/pages/stats.dart';
import 'package:melody_mover/pages/walk.dart';

class Store1 extends ChangeNotifier {
  int selectedIndex = 1;

  final List<Widget> pages = <Widget>[
    const Walking(),
    const Home(),
    const Statistics()
  ];

  //TODO: Implement a function to check for unread notifications
  bool hasUnread = false;

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void initialIndex() {
    selectedIndex = 1;
  }

  void inactiveIndex() {
    selectedIndex = -1;
  }
}