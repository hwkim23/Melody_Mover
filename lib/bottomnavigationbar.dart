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
      backgroundColor: Colors.white,
      elevation: 10.0,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          //TODO: Replace record icon
          icon: Icon(Icons.fiber_manual_record),
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
      currentIndex: context.watch<Store1>().selectedIndex, //New
      onTap: onItemTapped
    );
  }
}
