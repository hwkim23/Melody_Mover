import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController _tabController;
  int currentIndex = 0;
  List<int> items = [3, 5];

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentIndex = _tabController.index;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            )
                        )
                    ),
                    onPressed: () {
                      //TODO: Content function
                    },
                    child: const Text("Create Post +", style: TextStyle(color: Colors.blue)))),
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
                    color: Colors.blue
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.blue,
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
            /*const SizedBox(
              height: 100,
            )*/
          ],
        ),
      ),
    );
  }
}
