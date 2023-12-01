import 'package:flutter/material.dart';
import 'package:melody_mover/store.dart';
import 'package:provider/provider.dart';

class BaseBottomNavigationBar extends StatefulWidget {
  const BaseBottomNavigationBar({super.key});

  @override
  State<BaseBottomNavigationBar> createState() => _BaseBottomNavigationBarState();
}

class _BaseBottomNavigationBarState extends State<BaseBottomNavigationBar> {
  void onItemTapped(int index) {
    context.read<Store1>().onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xff0496FF),
      selectedItemColor: (context.watch<Store1>().selectedIndex != -1) ? Colors.white : Colors.grey,
      unselectedItemColor: Colors.grey,
      elevation: 10.0,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.radio_button_checked_rounded),
          label: 'Walk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Stats',
        ),
      ],
      currentIndex: (context.watch<Store1>().selectedIndex != -1) ? context.watch<Store1>().selectedIndex : 0, //New
      onTap: onItemTapped
    );
  }
}
