import 'package:flutter/material.dart';
import 'challenges.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController friendController = TextEditingController();
  TextEditingController communityController = TextEditingController();
  int currentIndex = 0;
  //TODO: Load items from the database
  List<int> items = [3, 5];

  @override
  void initState() {
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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: currentIndex == 0,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 2, color: Color(0xff0496FF)),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        )
                      ),
                      onPressed: () {
                        //TODO: Content function
                      },
                      child: const Text("Create Post", style: TextStyle(color: Color(0xff0496FF))),
                    ),
                  ),
                ),
                SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: currentIndex == 0
                      ? const Text("Friends", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))
                      : const Text("Communities", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))
                ),
                Container(
                  height: 50,
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
                SizedBox(
                  height: currentIndex == 0 ? items[currentIndex] * 320.0 : items[currentIndex] * 320.0 + 61,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: items[currentIndex],
                        itemBuilder: (BuildContext c, int index) {
                          return Container(
                            height: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Text("Content Number $index"),
                          );
                        },
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Morris St. Crew", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items[currentIndex],
                            itemBuilder: (BuildContext c, int index) {
                              return Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Text("Content Number $index"),
                              );
                            },
                          ),
                        ],
                      )
                    ]
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Challenges()));
            },
            elevation: 3,
            backgroundColor: Colors.black,
            child: const Icon(Icons.emoji_events),
          ),
        ),
      ],
    );
  }
}