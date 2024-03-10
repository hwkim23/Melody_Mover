import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:melody_mover/appbar.dart';
import 'package:melody_mover/drawer.dart';
import 'package:provider/provider.dart';
import '../bottomnavigationbar.dart';
import '../store.dart';
import 'mainpage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EndWalk extends StatefulWidget {
  final String timeElapsed;
  final String stepCount;
  final double distanceTravelled;
  final List<int> stepCounts;
  final int freezes;
  final List<double> distances;
  const EndWalk({
    super.key,
    required this.timeElapsed,
    required this.stepCount,
    required this.distanceTravelled,
    required this.stepCounts,
    required this.freezes,
    required this.distances
  });

  @override
  State<EndWalk> createState() => _EndWalkState();
}

class _EndWalkState extends State<EndWalk> {
  double avgRate = 0;
  double avgSpeed = 0;
  double avgStepLength = 0;
  double avgStepLengthVar = 0;
  double stepDur = 0;
  double stepDurVar = 0;
  List<double> avgStepLengths = [];
  List<double> stepDurs = [];
  List<int> avgRates = [];
  late int showingTooltip;
  List<BarChartGroupData>? listOfBars = [];

  BarChartGroupData generateGroupData(int x, int y) {
    return BarChartGroupData(
        x: x,
        showingTooltipIndicators: showingTooltip == x ? [0] : [],
        barRods: [
          BarChartRodData(toY: y.toDouble())
        ]
    );
  }

  @override
  void initState() {
    context.read<Store1>().inactiveIndex();
    showingTooltip = -1;
    setState(() {
      avgRate = int.parse(widget.stepCount) / (int.parse(widget.timeElapsed)/60);
      avgSpeed = widget.distanceTravelled / int.parse(widget.timeElapsed);
      avgStepLength = widget.distanceTravelled / int.parse(widget.stepCount);
      stepDur = int.parse(widget.timeElapsed) / int.parse(widget.stepCount);
      for (int i = 0; i < widget.stepCounts.length; i++) {
        avgStepLengths.add(widget.distances[i] / (widget.stepCounts[i]));
        stepDurs.add(60 / (widget.stepCounts[i]));
        avgRates.add(((widget.stepCounts[i] / (60*(i+1))) * 60).round());
        listOfBars?.add(generateGroupData(i+1, avgRates[i]));
      }
      avgStepLengths.sort();
      stepDurs.sort();
      if (avgStepLengths.isNotEmpty && stepDurs.isNotEmpty) {
        avgStepLengthVar = avgStepLengths.last - avgStepLengths.first;
        stepDurVar = stepDurs.last - stepDurs.first;
      } else {
        avgStepLengthVar = 0;
        stepDurVar = 0;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_){
      try {
        upload();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Saved Walking Data Successfully")));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error caused during the upload")));
      }
    });
    super.initState();
  }

  void upload() async {
    final firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
      await firestore.collection('walks').add({
        "userID" : uid,
        "date" : Timestamp.now(),
        "time" : widget.timeElapsed,
        "steps" : widget.stepCount,
        "distance" : widget.distanceTravelled.toString(),
        "avgRate" : avgRate.toString(),
        "avgSpeed" : avgSpeed.toString(),
        "avgStep" : avgStepLength.toString(),
        "avgStepVar" : avgStepLengthVar.toString(),
        "stepDur" : stepDur.toString(),
        "stepDurVar" : stepDurVar.toString(),
        "freezes" : widget.freezes.toString(),
        "avgRates" : avgRates,
      });
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff0496FF),
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('\$ $value', style: style),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff0496FF),
      fontSize: 12,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text('\$ $value', style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar()),
      drawer: const BaseDrawer(),
      body: context.watch<Store1>().selectedIndex == -1 ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text("Great Job!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Walk completed! Give yourself a pat\non the back and keep on movin’.",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xffD1EFFF),
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 13, right: 15, top: 15),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                                "Summary",
                                style: TextStyle(fontSize:14, fontWeight: FontWeight.w600, color: Colors.black)
                            )
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.black
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                                "Time Elapsed",
                                style: TextStyle(fontSize:14, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                            )
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            widget.timeElapsed,
                            style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                                "Steps Taken",
                                style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                            )
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            widget.stepCount,
                              style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                                "Moved to",
                                style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                            )
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Oldies Bops",
                                    style: TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                                ),
                                Text(
                                    "Playlist from Spotify",
                                    style: TextStyle(fontSize:15, fontWeight: FontWeight.w400, color: Colors.black)
                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
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
                      //TODO: Share function
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SharePost(timeElapsed: widget.timeElapsed, stepCount: widget.stepCount)));
                    },
                    child: const Text("Share", style: TextStyle(color: Colors.white, fontSize: 18))
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                height: 50,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 2, color: Color(0xff0496FF)),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainPage()));
                    },
                    child: const Text("Back Home", style: TextStyle(color: Color(0xff0496FF), fontSize: 18))
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text("Other Data", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Private to you and your trusted care provider(s).",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Distance Walked",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "${widget.distanceTravelled.toStringAsFixed(1)} Meters",
                        style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Average Rate",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "${avgRate.toStringAsFixed(1)} Steps/Minute",
                        style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Average Speed",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "${avgSpeed.toStringAsFixed(1)} Meters/Second",
                        style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Average Step Length",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "${avgStepLength.toStringAsFixed(1)} Meters",
                        style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Average Step Length Variation",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "${avgStepLengthVar.toStringAsFixed(1)} Meters",
                        style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Step Duration",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "${stepDur.toStringAsFixed(1)} Seconds",
                        style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Step Duration Variation",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "${stepDurVar.toStringAsFixed(1)} Seconds",
                        style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Freezes Detected",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                        "${widget.freezes} Freezes",
                        style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                    ),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Average Rate",
                        style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xff0496FF))
                    ),
                  )
              ),
              /*Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: BarChart(
                  BarChartData(
                    barGroups: listOfBars,
                    /*titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        axisNameWidget: const Text(
                          'Minutes in Walk',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xff0496FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 18,
                          interval: 1,
                          getTitlesWidget: bottomTitleWidgets,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        axisNameWidget: const Text(
                          'Steps/Minute',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xff0496FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 18,
                          interval: 1,
                          getTitlesWidget: leftTitleWidgets,
                        ),
                      ),
                    ),*/
                    barTouchData: BarTouchData(
                      enabled: true,
                      handleBuiltInTouches: false,
                      touchCallback: (event, response) {
                        if (response != null && response.spot != null) {
                          setState(() {
                            final x = response.spot!.touchedBarGroup.x;
                            final isShowing = showingTooltip == x;
                            if (isShowing) {
                              showingTooltip = -1;
                            } else {
                              showingTooltip = x;
                            }
                          });
                        }
                      },
                    )
                  )
                ),
              )*/
            ],
          ),
        ),
      ) : context.watch<Store1>().pages.elementAt(context.watch<Store1>().selectedIndex),
      bottomNavigationBar: const BaseBottomNavigationBar()
    );
  }
}

final TextEditingController _titleController = TextEditingController();
final TextEditingController _textController = TextEditingController();

class SharePost extends StatefulWidget {
  final String timeElapsed;
  final String stepCount;
  const SharePost({super.key, required this.timeElapsed, required this.stepCount});

  @override
  State<SharePost> createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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

  void toSuccessfulPost() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SuccessfulPost()));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  final firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar()),
      drawer: const BaseDrawer(),
      body: context.watch<Store1>().selectedIndex == -1 ? SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text("Share Some\nPositivity!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                width: double.infinity,
                height: 300,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: const Color(0xff0496FF),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 13, right: 15, top: 15),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                                "Walk Data",
                                style: TextStyle(fontSize:14, fontWeight: FontWeight.w600, color: Color(0xffD1EFFF))
                            )
                        ),
                      ),
                      const Divider(
                          thickness: 1,
                          color: Color(0xffD1EFFF)
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                                "Time Elapsed",
                                style: TextStyle(fontSize:14, fontWeight: FontWeight.w600, color: Color(0xffD1EFFF))
                            )
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              widget.timeElapsed,
                              style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.white)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                                "Steps Taken",
                                style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color:Color(0xffD1EFFF))
                            )
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              widget.stepCount,
                              style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.white)
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Text(
                                "Moved to",
                                style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: Color(0xffD1EFFF))
                            )
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Oldies Bops",
                                    style: TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.white)
                                ),
                                Text(
                                    "Playlist from Spotify",
                                    style: TextStyle(fontSize:15, fontWeight: FontWeight.w400, color: Colors.white)
                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 600,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: const Color(0xff0496FF),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 13, right: 15, top: 15),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formkey,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 50,
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Colors.red
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xff008BEE)
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                        color: Color(0xff008BEE)
                                    )
                                ),
                                hintText: 'Add Post Title',
                                filled: true,
                                fillColor: Color(0xffD1EFFF)
                            ),
                            validator: RequiredValidator(errorText: "* Required")
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 200,
                          margin: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.red
                                      )
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Colors.red
                                      )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Color(0xff008BEE)
                                      )
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                          color: Color(0xff008BEE)
                                      )
                                  ),
                                  hintText: 'Add Text or Caption',
                                  filled: true,
                                  fillColor: Color(0xffD1EFFF)
                              ),
                              validator: RequiredValidator(errorText: "* Required")
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 50),
                          height: 50,
                          width: double.infinity,
                          child: isSelected == false ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(width: 2, color: Colors.white),
                              backgroundColor: const Color(0xff0496FF),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                            ),
                            onPressed: () async {
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
                            child: const Text("Add Media", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          ) : Row(
                            children: [
                              Text(fileName),
                              IconButton(onPressed: (){}, icon: const Icon(Icons.delete_outline))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      await uploadImage(imageFile);
                      try {
                        await firestore.collection('posts').doc().set({
                          'imageURL' : imageURL,
                          'title' : _titleController.text,
                          'caption' : _textController.text,
                          'uploader' : uid
                        });
                      } catch (e) {
                        SnackBar(content: Text("Error: $e"));
                      }
                      toSuccessfulPost();
                    },
                    child: const Text("Share Post", style: TextStyle(color: Colors.white, fontSize: 18))
                ),
              ),
            ],
          ),
        ),
      ) : context.watch<Store1>().pages.elementAt(context.watch<Store1>().selectedIndex),
      bottomNavigationBar: const BaseBottomNavigationBar()
    );
  }
}

class SuccessfulPost extends StatefulWidget {
  const SuccessfulPost({super.key});

  @override
  State<SuccessfulPost> createState() => _SuccessfulPostState();
}

class _SuccessfulPostState extends State<SuccessfulPost> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}