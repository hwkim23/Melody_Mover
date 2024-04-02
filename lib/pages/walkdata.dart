import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../appbar.dart';
import '../bottomnavigationbar.dart';
import '../drawer.dart';
import '../store.dart';
import 'endwalk.dart';

class WalkData extends StatefulWidget {
  final String timeElapsed;
  final String stepCount;
  final double distanceTravelled;
  final int freezes;
  final double avgRate ;
  final double avgSpeed;
  final double avgStepLength;
  final double avgStepLengthVar;
  final double stepDur;
  final double stepDurVar;
  final List<dynamic> avgRates;
  final String date;
  const WalkData({
    super.key,
    required this.timeElapsed,
    required this.stepCount,
    required this.distanceTravelled,
    required this.freezes,
    required this.avgRate,
    required this.avgSpeed,
    required this.avgStepLength,
    required this.avgStepLengthVar,
    required this.stepDur,
    required this.stepDurVar,
    required this.avgRates,
    required this.date
  });

  @override
  State<WalkData> createState() => _WalkDataState();
}

class _WalkDataState extends State<WalkData> {

  @override
  void initState() {
    context.read<Store1>().inactiveIndex();
    super.initState();
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        child: const Icon(Icons.arrow_back_ios, color: Color(0xffACACAC),),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Flexible(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Walk Data", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Here is the data for your walk completed at ${widget.date}.",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.blue)
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
                              "${widget.stepCount} Steps",
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SharePost(timeElapsed: widget.timeElapsed, stepCount: widget.stepCount)));
                    },
                    child: const Text("Share", style: TextStyle(color: Colors.white, fontSize: 18))
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
                        "${widget.avgRate.toStringAsFixed(1)} Steps/Minute",
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
                        "${widget.avgSpeed.toStringAsFixed(1)} Meters/Second",
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
                        "${widget.avgStepLength.toStringAsFixed(1)} Meters",
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
                        "${widget.avgStepLengthVar.toStringAsFixed(1)} Meters",
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
                        "${widget.stepDur.toStringAsFixed(1)} Seconds",
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
                        "${widget.stepDurVar.toStringAsFixed(1)} Seconds",
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
            ],
          ),
      ),
      ) : context.watch<Store1>().pages.elementAt(context.watch<Store1>().selectedIndex),
      bottomNavigationBar: const BaseBottomNavigationBar()
    );
  }
}
