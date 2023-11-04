import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../appbar.dart';
import '../bottomnavigationbar.dart';
import '../drawer.dart';
import '../store.dart';

class Faqs extends StatefulWidget {
  const Faqs({super.key});

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
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
                  child: Text("Common Questions", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))
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
