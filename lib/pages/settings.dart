import 'package:flutter/material.dart';
import 'package:melody_mover/appbar.dart';
import 'package:melody_mover/drawer.dart';
import 'package:provider/provider.dart';
import '../bottomnavigationbar.dart';
import '../store.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
    context.read<Store1>().inactiveIndex();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar()),
      drawer: const BaseDrawer(),
      body: SizedBox(
        width: width,
        height: height,
        child: context.watch<Store1>().selectedIndex == -1
          ? Padding(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
            child: Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Settings", style: TextStyle(fontSize:37, fontWeight: FontWeight.bold))
                  ),
                )
              ],
            ),
          )
          : context.watch<Store1>().pages.elementAt(context.watch<Store1>().selectedIndex),
      ),
      bottomNavigationBar: const BaseBottomNavigationBar(),
    );
  }
}
