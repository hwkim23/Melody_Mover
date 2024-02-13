import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melody_mover/main.dart';
import 'package:melody_mover/pages/cues.dart';
import 'package:melody_mover/pages/faq.dart';
import 'package:melody_mover/pages/friendsncommunities.dart';
import 'package:melody_mover/pages/mymusic.dart';
import 'package:melody_mover/pages/settings.dart';

class BaseDrawer extends StatefulWidget {
  const BaseDrawer({super.key});

  @override
  State<BaseDrawer> createState() => _BaseDrawerState();
}

class _BaseDrawerState extends State<BaseDrawer> {
  final firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() async {
    await _auth.signOut().whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged Out Successfully")),
    ).closed.whenComplete(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyApp()))));
  }

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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FnC()));
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Setting()));
              },
            ),
            Expanded(
              child: Align(
                alignment: const FractionalOffset(0.5, 0.5),
                child: ListTile(
                  title: const Text("Logout", style: TextStyle(fontSize: 16, decoration: TextDecoration.underline)),
                  onTap: () {
                    try {
                      signOut();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Error caused during log out")));
                    }
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
