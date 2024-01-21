import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:melody_mover/pages/mainpage.dart';
import 'package:melody_mover/store.dart';
import 'package:melody_mover/test.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:melody_mover/themedata.dart';

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
  @override
  void initState() {
    super.initState();
    permission();
    context.read<Store1>().initialIndex();
  }

  Future<void> permission() async {
    await Geolocator.checkPermission();

    Map<Permission, PermissionStatus> statuses = await [
      Permission.activityRecognition,
    ].request();
    if (kDebugMode) {
      print(statuses[Permission.activityRecognition]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: const SizedBox(
                height: 100,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Let's move \n together.", style: TextStyle(fontSize:40, fontWeight: FontWeight.w500))
                ),
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: 50,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 2, color: Color(0xff0496FF)),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  onPressed: () {
                    //TODO: Sign In function
                  },
                  child: const Text("Sign Up", style: TextStyle(color: Color(0xff0496FF), fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 120),
                height: 50,
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xff0496FF),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    )
                  ),
                  onPressed: () {
                    //TODO: Login function
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
                  },
                  child: const Text("Log In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}