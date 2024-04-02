import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'challenges.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController commentController = TextEditingController();
  late TabController _tabController;
  int currentIndex = 0;
  List<String> imageURLs = [];
  List<String> titles = [];
  List<String> captions = [];
  List<String> uploaders = [];
  List<String> dates = [];
  List<String> names = [];
  List<String> firstNames = [];
  List<String> docIDs = [];
  List<dynamic> comments = [];
  List<dynamic> likes = [];
  bool isLoading = true;
  List<bool> isLiked = [];
  String uid = "";
  var friendsList = [];
  bool showCommentOverlay = false;
  bool showCommentsOverlay = false;
  String setName = "";
  String setUID = "";
  String commentUploader = "";
  String userFullName = "";
  int selectedIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    if (isLoading) { getData(); }
    super.initState();
  }

  void getData() async {
    uid = auth.currentUser!.uid;
    var result = await firestore.collection("posts").orderBy('date', descending: true).get();
    var friendResult = await firestore.collection("users").get();
    for (var friendDoc in friendResult.docs) {
      if (friendDoc.id == uid) {
        for (var friend in friendDoc['friends']) {
          friendsList.add(friend);
        }
      }
    }
    for (var doc in result.docs) {
      if (doc['uploader'] != uid && friendsList.contains(doc['uploader'])) {
        imageURLs.add(doc['imageURL']);
        titles.add(doc["title"]);
        captions.add(doc["caption"]);
        uploaders.add(doc["uploader"]);
        dates.add(convertDate(doc["date"].toDate()));
        docIDs.add(doc.id);
        comments.add(doc["comments"]);
        likes.add(doc["likes"]);
        if (doc["likes"].contains(uid)) {
          isLiked.add(true);
        } else {
          isLiked.add(false);
        }
        var nameData = await firestore.collection("users").get();
        for (var userDoc in nameData.docs) {
          if (userDoc.id == uid) {
            userFullName = userDoc["first_name"] + " " + userDoc["last_name"];
          }
          if (userDoc.id == doc["uploader"]) {
            String fullName = userDoc["first_name"] + " " + userDoc["last_name"];
            names.add(fullName);
            firstNames.add(userDoc["first_name"]);
          }
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String convertDate(DateTime date) {
    final currentTime = DateTime.now();
    if (currentTime.difference(date).inMinutes < 1) {
      return "Now";
    } else if (currentTime.difference(date).inMinutes < 60) {
      return "${currentTime.difference(date).inMinutes} minutes ago";
    } else if (currentTime.difference(date).inHours < 24) {
      return "${currentTime.difference(date).inHours} hours ago";
    } else {
      return "${currentTime.difference(date).inDays} days ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Refresh when scrolled up
    final width = MediaQuery.of(context).size.width;
    return isLoading ? const Center(child: CircularProgressIndicator()) : Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
            child: titles.isEmpty ? const Text("Add friends to see posts") : Column(
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
                    unselectedLabelColor: const Color(0xff0496FF),
                    tabs: const [
                      Tab(text: "Friends"),
                      Tab(text: "Communities")
                    ],
                  ),
                ),
                SizedBox(
                  height: currentIndex == 0 ? titles.length * 450.0 : titles.length * 450.0 + 61,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: titles.length,
                        itemBuilder: (BuildContext c, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: const Color(0xffACACAC))
                            ),
                            margin: const EdgeInsets.only(bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(right: 15),
                                            child: const Icon(Icons.account_circle)
                                          ),
                                          Text(names[index], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))
                                        ],
                                      ),
                                      Text(dates[index], style: const TextStyle(fontSize: 12, color: Color(0xff868686)))
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  height: 250,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(imageURLs[index])
                                    )
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(titles[index], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                                      Text(captions[index], style: const TextStyle(fontSize: 15, color: Color(0xff535353))),
                                      Container(
                                        margin: const EdgeInsets.only(top: 10, bottom: 15),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(right: 15),
                                              height: 35,
                                              child: FilledButton(
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(6.0),
                                                    ),
                                                  ),
                                                  backgroundColor: MaterialStateProperty.all(const Color(0xffD1EFFF))
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    isLiked[index] = !isLiked[index];
                                                  });
                                                  var result = await firestore.collection('posts').doc(docIDs[index]).get();
                                                  var data = result.data();
                                                  List<dynamic> likes = data?['likes'];
                                                  if (isLiked[index]) {
                                                    likes.add(uid);
                                                  } else {
                                                    likes.remove(uid);
                                                  }
                                                  firestore.collection('posts')
                                                      .doc(docIDs[index])
                                                      .set({
                                                    'likes': likes
                                                  },SetOptions(merge: true));
                                                },
                                                child: !isLiked[index] ? const Icon(Icons.favorite_border, color: Colors.blue,) : const Icon(Icons.favorite, color: Colors.redAccent,),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 35,
                                              child: FilledButton(
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(6.0),
                                                      ),
                                                    ),
                                                    backgroundColor: MaterialStateProperty.all(const Color(0xffD1EFFF))
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    showCommentOverlay = true;
                                                    setName = firstNames[index];
                                                    setUID = docIDs[index];
                                                    selectedIndex = index;
                                                  });
                                                },
                                                child: const Icon(Icons.comment_outlined, color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Morris St. Crew", style: TextStyle(fontSize:37, fontWeight: FontWeight.bold))
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: titles.length,
                            itemBuilder: (BuildContext c, int index) {
                              return Container(
                                height: 300,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: const Color(0xffACACAC))
                                ),
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Row(),
                                    ),
                                    Container(),
                                    Container(
                                      child: Column(
                                        children: [
                                          Text(titles[index])
                                        ],
                                      ),
                                    )
                                  ],
                                ),
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
          bottom: 25,
          right: 25,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Challenges()));
            },
            elevation: 5,
            backgroundColor: const Color(0xff0496FF),
            child: const Icon(Icons.emoji_events, color: Colors.white,),
          ),
        ),
        Visibility(
          visible: showCommentOverlay,
          child: Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        Visibility(
          visible: showCommentOverlay,
          child: Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Material(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Comment on $setName's Post", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    showCommentOverlay = false;
                                  });
                                  commentController.clear();
                                },
                                icon: const Icon(Icons.close, color: Colors.blue)
                            )
                          ],
                        ),
                        Container(
                          height: 5 * 25,
                          margin: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            maxLines: 5,
                            controller: commentController,
                            decoration: const InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xffF0F0F0)
                                    )
                                ),
                                hintText: 'Add Comment',
                                filled: true,
                                fillColor: Color(0xffF0F0F0)
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              height: 35,
                              width: 90,
                              child: FilledButton(
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size.zero),
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(const Color(0xffD1EFFF))
                                ),
                                onPressed: () {
                                  setState(() {
                                    showCommentOverlay = false;
                                    showCommentsOverlay = true;
                                  });
                                },
                                child: const Text("Read Others", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600)),
                              ),
                            ),
                            SizedBox(
                              height: 35,
                              width: 90,
                              child: FilledButton(
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(Size.zero),
                                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(Colors.blue)
                                ),
                                onPressed: () async {
                                  if (commentController.text.isNotEmpty) {
                                    var result = await firestore.collection('posts').doc(setUID).get();
                                    var data = result.data();
                                    List<dynamic> comments = data?['comments'];
                                    List<String> likes = [];
                                    Map<String, String> replies = {};
                                    comments.add({
                                      "uid" : uid,
                                      "full_name" : userFullName,
                                      "comment" : commentController.text.capitalize(),
                                      "date" : Timestamp.now(),
                                      "likes" : likes,
                                      "replies" : replies
                                    });
                                    firestore.collection('posts')
                                        .doc(setUID)
                                        .set({
                                      'comments': comments
                                    },SetOptions(merge: true)).then((value){
                                      commentController.clear();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Successfully commented")));
                                    });
                                    setState(() {
                                      showCommentOverlay = false;
                                    });
                                  }
                                },
                                child: const Text("Comment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: showCommentsOverlay,
          child: Positioned(
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        Visibility(
          visible: showCommentsOverlay,
          child: Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Material(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Comments on $setName's Post", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showCommentsOverlay = false;
                                        });
                                      },
                                      icon: const Icon(Icons.close, color: Colors.blue)
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: 400,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            shrinkWrap: true,
                            //TODO: Change comments[0] to selected post's index
                            itemCount: comments[selectedIndex].length,
                            itemBuilder: (BuildContext c, int index) {
                              commentUploader = comments[selectedIndex][index]["full_name"];
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(color: const Color(0xffACACAC))
                                ),
                                margin: const EdgeInsets.only(bottom: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(right: 15),
                                                  child: const Icon(Icons.account_circle)
                                              ),
                                              Text(commentUploader, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))
                                            ],
                                          ),
                                          Text(convertDate(comments[selectedIndex][index]["date"].toDate()), style: const TextStyle(fontSize: 12, color: Color(0xff868686)))
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xffACACAC)
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              margin: const EdgeInsets.only(top: 10),
                                              child: Text(comments[selectedIndex][index]["comment"], style: const TextStyle(fontSize: 15, color: Color(0xff535353)))
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(top: 10, bottom: 15),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  margin: const EdgeInsets.only(right: 15),
                                                  height: 35,
                                                  child: FilledButton(
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(6.0),
                                                          ),
                                                        ),
                                                        backgroundColor: MaterialStateProperty.all(const Color(0xffD1EFFF))
                                                    ),
                                                    onPressed: () async {
                                                      /*setState(() {
                                                                isLiked[index] = !isLiked[index];
                                                              });
                                                              var result = await firestore.collection('posts').doc(docIDs[index]).get();
                                                              var data = result.data();
                                                              List<dynamic> likes = data?['likes'];
                                                              if (isLiked[index]) {
                                                                likes.add(uid);
                                                              } else {
                                                                likes.remove(uid);
                                                              }
                                                              firestore.collection('posts')
                                                                  .doc(docIDs[index])
                                                                  .set({
                                                                'likes': likes
                                                              },SetOptions(merge: true));*/
                                                    },
                                                    child: const Icon(Icons.favorite_border, color: Colors.blue,),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 35,
                                                  child: FilledButton(
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(6.0),
                                                          ),
                                                        ),
                                                        backgroundColor: MaterialStateProperty.all(const Color(0xffD1EFFF))
                                                    ),
                                                    onPressed: () async {
                                                      /*setState(() {
                                                                isLiked[index] = !isLiked[index];
                                                              });
                                                              var result = await firestore.collection('posts').doc(docIDs[index]).get();
                                                              var data = result.data();
                                                              List<dynamic> likes = data?['likes'];
                                                              if (isLiked[index]) {
                                                                likes.add(uid);
                                                              } else {
                                                                likes.remove(uid);
                                                              }
                                                              firestore.collection('posts')
                                                                  .doc(docIDs[index])
                                                                  .set({
                                                                'likes': likes
                                                              },SetOptions(merge: true));*/
                                                    },
                                                    child: const Icon(Icons.subdirectory_arrow_left_outlined, color: Colors.blue),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xffACACAC)
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 35,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 35,
                                width: 90,
                                child: FilledButton(
                                  style: ButtonStyle(
                                      minimumSize: MaterialStateProperty.all(Size.zero),
                                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6.0),
                                        ),
                                      ),
                                      backgroundColor: MaterialStateProperty.all(Colors.blue)
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      showCommentsOverlay = false;
                                      showCommentOverlay = true;
                                    });
                                  },
                                  child: const Text("Comment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}