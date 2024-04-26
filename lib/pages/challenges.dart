import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../appbar.dart';
import '../bottomnavigationbar.dart';
import '../drawer.dart';
import '../store.dart';
import 'package:quiver/time.dart';

class Challenges extends StatefulWidget {
  const Challenges({super.key});

  @override
  State<Challenges> createState() => _ChallengesState();
}

class _ChallengesState extends State<Challenges> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  List<Timestamp> dateList = [];
  int streak = 0;
  int days = 0;

  void getData() async {
    final uid = auth.currentUser?.uid;
    var resultStat = await firestore.collection("walks").orderBy('date').where("userID", isEqualTo: uid).get();
    for (var doc in resultStat.docs) {
      dateList.add(doc['date']);
    }
    days = daysInMonth(DateTime.now().year, DateTime.now().month);
    if (DateTime.now().difference(dateList.last.toDate()).inDays < 1) {
      setState(() {
        streak++;
      });
      DateTime prev = dateList.last.toDate();
      for (int i = dateList.length - 2; i > 0; i--) {
        DateTime curr = dateList[i].toDate();
        if (prev.difference(curr).inDays > 1 && prev.difference(curr).inDays < 2) {
          setState(() {
            streak++;
          });
          prev = curr;
        } else {
          break;
        }
      }
    }
    var result = await firestore.collection("users").doc(uid).get();
    var data = result.data();
    if (data!.containsKey("highestStreak")) {
      if (data["highestStreak"] < streak) {
        firestore.collection('users')
            .doc(uid)
            .set({
          'highestStreak': streak
        },SetOptions(merge: true));
      }
    } else {
      firestore.collection('users')
          .doc(uid)
          .set({
        'highestStreak': streak
      },SetOptions(merge: true));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<Store1>().inactiveIndex();
    if (isLoading) { getData(); }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar()),
      drawer: const BaseDrawer(),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SizedBox(
        width: width,
        height: height,
        child: context.watch<Store1>().selectedIndex == -1
          ? SingleChildScrollView(
            child: SizedBox(
              height: height,
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Stack(
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text("Challenges", style: TextStyle(fontSize:37, fontWeight: FontWeight.bold))
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xffACACAC), size: 30,),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Text("My Streak", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold))
                      ),
                    ),
                    streak > 0 ? Container(
                      width: double.infinity,
                      height: 60,
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: const Color(0xffF06543),
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.transparent)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.transparent)
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.local_fire_department,
                                color: Color(0xffF06543),
                                size: 30,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                streak == 1 ? "1 day so far! Can you beat your streak of 5 days this month?"
                                : "",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold
                                ),
                                softWrap: true,
                              ),
                            ),
                          )
                        ],
                      ),
                    ) : const Text("There is no streak yet. Start walking!"),
                    Container(
                      height: 352,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: const Color(0xffACACAC), width: 1),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(9),
                                  topLeft: Radius.circular(9)
                              ),
                              border: Border(bottom: BorderSide(color: Color(0xffACACAC), width: 1)),
                            ),
                            child: Center(
                              child: Text(
                                DateFormat('MMMM').format(DateTime.now()),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(color: Color(0xffACACAC), width: 1)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      "S",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      "M",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      "T",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      "W",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      "Th",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      "F",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Center(
                                    child: Text(
                                      "S",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(color: Color(0xffACACAC), width: 1)),
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(color: Color(0xffACACAC), width: 1)),
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(color: Color(0xffACACAC), width: 1)),
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(bottom: BorderSide(color: Color(0xffACACAC), width: 1)),
                            ),
                          ),
                          Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(9),
                                  bottomRight: Radius.circular(9)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      child: Text(
                        "You’re doing great, keep it up! Your highest streak ever was $streak day(s) long.",
                        style: const TextStyle(
                          color: Color(0xff535353)
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text("My Goals", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
                              Text(
                                "To add more goals, scroll down to challenges!",
                                style: TextStyle(
                                    color: Color(0xff535353)
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: const Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text("Challenges", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold)),
                              Text(
                                "Add challenges to help keep track of your goals!",
                                style: TextStyle(
                                    color: Color(0xff535353)
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 50,
                      child: FilledButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff0496FF)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0)
                                  )
                              )
                          ),
                          onPressed: () async {

                          },
                          child: const Text("Add Your Own Challenge", style: TextStyle(color: Colors.white, fontSize: 18))
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          : context.watch<Store1>().pages.elementAt(context.watch<Store1>().selectedIndex),
      ),
      bottomNavigationBar: const BaseBottomNavigationBar(),
    );
  }
}
