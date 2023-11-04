import 'package:flutter/material.dart';
import 'package:melody_mover/pages/cues.dart';
import 'package:melody_mover/pages/faq.dart';
import 'package:melody_mover/pages/mymusic.dart';
import 'package:melody_mover/pages/settings.dart';
import 'main.dart';

class BaseDrawer extends StatelessWidget {
  const BaseDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              padding: const EdgeInsets.only(top: 50, left: 15),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text("Menu", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))),
            ),
            ListTile(
              title: const Text("Friends and Communities", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp()));
              },
            ),
            ListTile(
              title: const Text("Cues", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Cues()));
              },
            ),
            ListTile(
              title: const Text("My Music", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyMusic()));
              },
            ),
            ListTile(
              title: const Text("Help Using App", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Faqs()));
              },
            ),
            ListTile(
              title: const Text("Settings", style: TextStyle(fontSize: 16)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Settings()));
              },
            ),
            Expanded(
              child: Align(
                alignment: const FractionalOffset(0.5, 0.5),
                child: ListTile(
                  title: const Text("Logout", style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)),
                  onTap: () {
                    //TODO: Logout function
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
