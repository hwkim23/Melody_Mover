import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:melody_mover/appbar.dart';
import 'package:melody_mover/drawer.dart';
import 'package:provider/provider.dart';
import '../bottomnavigationbar.dart';
import '../store.dart';

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
  List<double> avgRates = [];

  @override
  void initState() {
    context.read<Store1>().inactiveIndex();
    setState(() {
      avgRate = int.parse(widget.stepCount) / (int.parse(widget.timeElapsed)/60);
      avgSpeed = widget.distanceTravelled / int.parse(widget.timeElapsed);
      avgStepLength = widget.distanceTravelled / int.parse(widget.stepCount);
      stepDur = int.parse(widget.timeElapsed) / int.parse(widget.stepCount);
      for (int i = 0; i < widget.stepCounts.length; i++) {
        avgStepLengths.add(widget.distances[i] / (widget.stepCounts[i]));
        stepDurs.add(60 / (widget.stepCounts[i]));
        avgRates.add((widget.stepCounts[i] / (60*(i+1))) * 60);
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
                    onPressed: () async {
                      //TODO: Return home function
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
              Container(
                //TODO: Bar Chart
              )
            ],
          ),
        ),
      ) : context.watch<Store1>().pages.elementAt(context.watch<Store1>().selectedIndex),
      bottomNavigationBar: const BaseBottomNavigationBar(),
    );
  }
}
