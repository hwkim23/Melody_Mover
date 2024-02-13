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
    return buildMyNavBar(context);
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              color: context.watch<Store1>().selectedIndex == 0 ? const Color(0xff0082DF) : const Color(0xff0496FF),
              height: double.infinity,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                enableFeedback: false,
                onPressed: () {
                  onItemTapped(0);
                },
                icon: context.watch<Store1>().selectedIndex == 0
                    ? const Icon(
                  Icons.directions_walk,
                  color: Colors.white,
                  size: 35,
                )
                    : const Icon(
                  Icons.directions_walk_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              color: context.watch<Store1>().selectedIndex == 1 ? const Color(0xff0082DF) : const Color(0xff0496FF),
              height: double.infinity,
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                enableFeedback: false,
                onPressed: () {
                  onItemTapped(1);
                },
                icon: context.watch<Store1>().selectedIndex == 1
                    ? const Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 35,
                )
                    : const Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              color: context.watch<Store1>().selectedIndex == 2 ? const Color(0xff0082DF) : const Color(0xff0496FF),
              height: double.infinity,
              child: IconButton(
                enableFeedback: false,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  onItemTapped(2);
                },
                icon: context.watch<Store1>().selectedIndex == 2
                    ? const Icon(
                  Icons.bar_chart,
                  color: Colors.white,
                  size: 35,
                )
                    : const Icon(
                  Icons.bar_chart_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
