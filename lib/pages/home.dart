import 'package:flutter/material.dart';

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
    return SingleChildScrollView(
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