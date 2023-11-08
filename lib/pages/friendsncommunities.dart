import 'package:flutter/material.dart';
import 'package:melody_mover/appbar.dart';
import 'package:melody_mover/bottomnavigationbar.dart';
import 'package:melody_mover/drawer.dart';
import 'package:provider/provider.dart';

import '../store.dart';

class FnC extends StatefulWidget {
  const FnC({super.key});

  @override
  State<FnC> createState() => _FnCState();
}

class _FnCState extends State<FnC> with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController friendController = TextEditingController();
  TextEditingController communityController = TextEditingController();
  int currentIndex = 0;

  @override
  void initState() {
    context.read<Store1>().inactiveIndex();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
        if (currentIndex == 0) {
          friendController = TextEditingController();
        } else {
          communityController = TextEditingController();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    friendController.dispose();
    communityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar()),
      drawer: const BaseDrawer(),
      body: SizedBox(
        width: width,
        height: height,
        child: context.watch<Store1>().selectedIndex == -1
          ? SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
            child: Column(
              children: <Widget>[
                SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: currentIndex == 0
                        ? const Text("Friends", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))
                        : const Text("Communities", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))
                ),
                Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(text: "Friends"),
                      Tab(text: "Community")
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  height: 45,
                  child: currentIndex == 0
                      ? searchBar("Friends", friendController)
                      : searchBar("Communities", communityController),
                ),
              ],
            ),
          ),
        )
          : context.watch<Store1>().pages.elementAt(context.watch<Store1>().selectedIndex),
      ),
      bottomNavigationBar: const BaseBottomNavigationBar(),
    );
  }
}

Widget searchBar(String title, TextEditingController controller) {
  return SearchBar(
    elevation: MaterialStateProperty.all(0),
    controller: controller,
    leading: const Icon(Icons.search),
    hintText: "Search $title",
  );
}
