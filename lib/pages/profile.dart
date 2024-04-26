import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../appbar.dart';
import '../bottomnavigationbar.dart';
import '../drawer.dart';
import '../store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  String fullName = "";
  String email = "";
  int numFriends = 0;
  List<Map<String, dynamic>> myPosts = [];
  List<String> dates = [];
  bool isClicked = false;
  String profileURL = "";
  Future<void> _uploadCamera() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> _uploadGallery() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  XFile? _pickedImage;
  CroppedFile? _croppedFile;
  late File imageFile;
  late String fileName;
  late String imageURL;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  bool isSelected = false;

  void unselectImage() {
    setState(() {
      isSelected = false;
    });
  }

  //Method to crop the selected image in to fixed ratio of 1 to 1
  Future<void> _cropImage() async {
    if (_pickedImage != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedImage!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
          fileName = path.basename(_croppedFile!.path);
          imageFile = File(_croppedFile!.path);
          isSelected = true;
        });
        await uploadImage(imageFile);
        setState(() {
          profileURL = imageURL;
        });
      }
    }
  }

  Future<void> uploadImage(imageFile) async {
    try{
      Reference ref = storage.ref(fileName);
      await ref.putFile(imageFile);
      var url = await ref.getDownloadURL();
      setState(() {
        imageURL = url.toString();
      });
      const SnackBar(content: Text("Uploaded Successfully"));
    } catch (e) {
      SnackBar(content: Text("Error: $e"));
    }
  }

  void getData() async {
    final uid = auth.currentUser?.uid;
    var result = await firestore.collection("users").get();
    for (var doc in result.docs) {
      if (doc.id == uid) {
        fullName = doc['first_name'] + " " + doc["last_name"];
        email = doc['email'];
        List<dynamic> friendsList = doc['friends'];
        numFriends = friendsList.length;
        if (doc.data().containsKey('profileURL')) {
          profileURL = doc["profileURL"];
        }
      }
    }
    var result2 = await firestore.collection("posts").get();
    for (var doc in result2.docs) {
      if (doc["uploader"] == uid) {
        myPosts.add(doc.data());
        dates.add(convertDate(doc["date"].toDate()));
      }
    }
    setState(() {
      isLoading = false;
    });
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
        height: height - 60,
        child: context.watch<Store1>().selectedIndex == -1
            ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
                child: SizedBox(
                  height: height - 177,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: Stack(
                              children: [
                                profileURL.isEmpty
                                  ? const Icon(Icons.account_circle,size: 120)
                                  : CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 48, // Image radius
                                      backgroundImage: NetworkImage(profileURL),
                                ),
                                Visibility(
                                  visible: isClicked,
                                  child: Positioned(
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {
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
                                                      "Choose option",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 50,
                                                        child: TextButton(
                                                          style: TextButton.styleFrom(
                                                              textStyle: const TextStyle(fontSize: 16, color: Color(0xff0496FF))
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.of(context).pop();
                                                            await _uploadCamera();
                                                            await _cropImage();
                                                          },
                                                          child: const Text(
                                                              "Camera"
                                                          ),
                                                        )
                                                    ),
                                                    SizedBox(
                                                        width: MediaQuery.of(context).size.width,
                                                        height: 50,
                                                        child: TextButton(
                                                          style: TextButton.styleFrom(
                                                              textStyle: const TextStyle(fontSize: 16, color: Color(0xff0496FF))
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.of(context).pop();
                                                            await _uploadGallery();
                                                            await _cropImage();
                                                          },
                                                          child: const Text(
                                                              "Gallery"
                                                          ),
                                                        )
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                        );
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffD1EFFF),
                                          borderRadius: BorderRadius.circular(30),
                                          border: Border.all(color: const Color(0xffD1EFFF), width: 1.5),
                                        ),
                                        child: const Icon(Icons.edit, color: Color(0xff0496FF), size: 20),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("$numFriends Friends", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Color(0xff0496FF))),
                                  Text(fullName, style: const TextStyle(fontSize:25, fontWeight: FontWeight.bold)),
                                  Text(email, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
                                  Container(
                                    height: 65,
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    //color: Colors.red,
                                    child: const Text(
                                      "Hi everyone, it’s Anna! If you’re looking for someone to walk with in Naperville, let’s chat!",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 35,
                                    child: FilledButton(
                                        style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(const Color(0xffD1EFFF)),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0)
                                                )
                                            )
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            if (isClicked) {
                                              final uid = auth.currentUser?.uid;
                                              firestore.collection('users')
                                                  .doc(uid)
                                                  .set({
                                                'profileURL': imageURL
                                              },SetOptions(merge: true));
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Profile Updated")));
                                              setState(() {});
                                            }
                                            isClicked = !isClicked;
                                          });
                                        },
                                        child: Text(
                                          !isClicked ? "Edit" : "Save",
                                          style: const TextStyle(color: Color(0xff0496FF), fontSize: 15)
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // number of items in each row
                              mainAxisSpacing: 10, // spacing between rows
                              crossAxisSpacing: 10, // spacing between columns
                              childAspectRatio: 0.65
                            ),
                            itemCount: myPosts.length, // total number of items
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: const Color(0xffACACAC), width: 1.5),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff0496FF),
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(8.5),
                                          topLeft: Radius.circular(8.5)
                                        ),
                                        border: Border.all(color: Colors.transparent, width: 0),
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          dates[index],
                                          style: const TextStyle(fontSize: 12, color: Colors.white)
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 125,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(myPosts[index]['imageURL'])
                                          ),
                                        color: Colors.white
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.only(
                                              bottomRight: Radius.circular(8.5),
                                              bottomLeft: Radius.circular(8.5)
                                          ),
                                          border: Border.all(color: Colors.transparent, width: 0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(myPosts[index]['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                              Text(
                                                myPosts[index]['caption'],
                                                style: const TextStyle(fontSize: 13, color: Color(0xff535353)),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      )
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
