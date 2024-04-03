import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late TabController _tabController;
  TextEditingController friendController = TextEditingController();
  TextEditingController communityController = TextEditingController();
  int currentIndex = 0;
  List<List<String>> possibleFriends = [];
  bool isLoading = true;

  void getData() async {
    final uid = auth.currentUser?.uid;
    var result = await firestore.collection("users").get();
    for (var doc in result.docs) {
      final List<dynamic> friendsList = doc["friends"];
      if (doc.id != uid && !friendsList.contains(uid)) {
        String fullName = doc['first_name'] + " " + doc["last_name"];
        possibleFriends.add([doc.id, fullName]);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

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
    if (isLoading) { getData(); }
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
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SizedBox(
        width: width,
        height: height,
        child: context.watch<Store1>().selectedIndex == -1
          ? Padding(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
            child: Column(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: const Color(0xff0496FF), width: 1.5),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        border: Border.all(color: const Color(0xff0496FF), width: 1.5),
                        borderRadius: BorderRadius.circular(8.5),
                        color: const Color(0xff0496FF)
                    ),
                    labelColor: Colors.white,
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: const Color(0xff0496FF),
                    tabs: const [
                      Tab(text: "Friends"),
                      Tab(text: "Communities")
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
                SizedBox(
                  height: 450,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "People you may know",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            height: 400,
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(color: const Color(0xffACACAC))
                            ),
                            child: SingleChildScrollView(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: possibleFriends.length,
                                itemBuilder: (BuildContext c, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(right: 10),
                                                child: const Icon(Icons.account_circle)
                                            ),
                                            Text(possibleFriends[index][1], style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 35,
                                          width: 90,
                                          child: OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.zero,
                                              side: const BorderSide(width: 2, color: Colors.blue),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6.0),
                                              )
                                            ),
                                            onPressed: () {

                                            },
                                            child: const Text("Request", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Container()
                    ],
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

Widget searchBar(String title, TextEditingController controller) {
  return SearchBar(
    elevation: MaterialStateProperty.all(0),
    controller: controller,
    leading: const Icon(Icons.search),
    hintText: "Search $title",
  );
}
