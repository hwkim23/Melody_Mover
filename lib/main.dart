import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:melody_mover/pages/home.dart';
import 'package:melody_mover/pages/stats.dart';
import 'package:melody_mover/store.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'appbar.dart';
import 'bottomnavigationbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:melody_mover/themedata.dart';
import 'pages/walk.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (c) => Store1(),
      child: MaterialApp(
        theme: MyThemeData().themedata,
        home: const MyApp()
      ),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const List<Widget> pages = <Widget>[
    Walking(),
    Home(),
    Statistics()
  ];

  @override
  void initState() {
    super.initState();
    permission();
  }

  Future<void> permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.activityRecognition,
    ].request();
    if (kDebugMode) {
      print(statuses[Permission.activityRecognition]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar()),
      body: SizedBox (
        width: width,
        height: height,
        child: pages.elementAt(context.watch<Store1>().selectedIndex),
      ),
      bottomNavigationBar: const BaseBottomNavigationBar(),
    );
  }
}