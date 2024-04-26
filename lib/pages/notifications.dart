import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../appbar.dart';
import '../bottomnavigationbar.dart';
import '../drawer.dart';
import '../store.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  Map<dynamic, dynamic> notifications = {};
  List<List<dynamic>> notificationsList = [];
  Map<String, String> requestNames = {};

  void getData() async {
    final uid = auth.currentUser?.uid;
    var result = await firestore.collection("users").doc(uid).get();
    var data = result.data();
    if (data!.containsKey("notifications")) {
      setState(() {
        if (data["notifications"].isNotEmpty) {
          notifications = data["notifications"];
        }
      });
      notifications.forEach((key, value) {
        for (var val in value) {
          List<dynamic> list = [key, val];
          setState(() {
            notificationsList.add(list);
          });
        }
      });
    }
    for (int i = 0; i < notificationsList.length; i++) {
      if (notificationsList[i][0] == "Friend Requests") {
        var result = await firestore.collection("users").doc(notificationsList[i][1]).get();
        var data = result.data();
        String fullName = data?['first_name'] + " " + data?["last_name"];
        setState(() {
          requestNames[notificationsList[i][1]] = fullName;
        });
      }
    }
    //print(notificationsList);
    setState(() {
      isLoading = false;
    });
  }

  void showFriendDialog(int idx) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              const Text(
                "Accept Friend Request?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16, color: Color(0xff0496FF))
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          notificationsList.removeAt(idx);
                          final uid = auth.currentUser?.uid;
                          var myResult = await firestore.collection("users").doc(uid).get();
                          var myData = myResult.data();
                          Map<dynamic, dynamic> notifications = myData?['notifications'];
                          List<dynamic> friendRequestNotifications = notifications['Friend Requests'];
                          friendRequestNotifications.remove(notificationsList[idx][1]);
                          firestore.collection("users").doc(uid).set({
                            'notifications' : notifications
                          },SetOptions(merge: true));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Request Declined")));
                          setState(() {});
                        },
                        child: const Text(
                          "Decline",
                          style: TextStyle(
                            color: Color(0xff0496FF),
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16, color: Color(0xff0496FF))
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          final uid = auth.currentUser?.uid;
                          var friendResult = await firestore.collection("users").doc(notificationsList[idx][1]).get();
                          var myResult = await firestore.collection("users").doc(uid).get();
                          var myData = myResult.data();
                          var friendData = friendResult.data();
                          List<dynamic> myFriends = myData?['friends'];
                          myFriends.add(notificationsList[idx][1]);
                          List<dynamic> friendFriends = friendData?['friends'];
                          friendFriends.add(uid);
                          Map<dynamic, dynamic> notifications = myData?['notifications'];
                          List<dynamic> friendRequestNotifications = notifications['Friend Requests'];
                          friendRequestNotifications.remove(notificationsList[idx][1]);
                          firestore.collection("users").doc(notificationsList[idx][1]).set({
                            'friends' : friendFriends
                          },SetOptions(merge: true));
                          firestore.collection("users").doc(uid).set({
                            'friends' : myFriends,
                            'notifications' : notifications
                          },SetOptions(merge: true));
                          notificationsList.removeAt(idx);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Request Accepted")));
                          setState(() {});
                        },
                        child: const Text(
                          "Accept",
                          style: TextStyle(
                              color: Color(0xff0496FF),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<Store1>().inactiveIndex();
    getData();
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
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Notifications", style: TextStyle(fontSize:37, fontWeight: FontWeight.bold))
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Recent", style: TextStyle(fontSize:18, fontWeight: FontWeight.bold))
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: notificationsList.length,
                    itemBuilder: (BuildContext c, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (notificationsList[index][0] == "Friend Requests") {
                            showFriendDialog(index);
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                              color: notificationsList[index][0] == "Challenges"
                                  ? const Color(0xffF06543)
                                  : const Color(0xff0496FF),
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
                                child: Center(
                                  child: Icon(
                                    notificationsList[index][0] == "Challenges"
                                      ? Icons.local_fire_department
                                      : Icons.group_rounded,
                                    color: notificationsList[index][0] == "Challenges"
                                        ? const Color(0xffF06543)
                                        : const Color(0xff0496FF),
                                    size: 30,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    notificationsList[index][0] == "Friend Requests"
                                        ? "New Friend Request From ${requestNames[notificationsList[index][1]]}"
                                        : "3 days so far! Let’s keep this streak going!",
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
                        ),
                      );
                    },
                  )
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
