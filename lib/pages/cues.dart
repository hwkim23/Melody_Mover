import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../appbar.dart';
import '../bottomnavigationbar.dart';
import '../drawer.dart';
import '../store.dart';

class Cues extends StatefulWidget {
  const Cues({super.key});

  @override
  State<Cues> createState() => _CuesState();
}

class _CuesState extends State<Cues> {
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
                    child: Text("Cues", style: TextStyle(fontSize:37, fontWeight: FontWeight.bold))
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
