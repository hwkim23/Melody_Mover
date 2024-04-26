import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melody_mover/pages/allwalk.dart';
import 'package:melody_mover/pages/walkdata.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> with TickerProviderStateMixin {
  final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> avgRateList = [];
  List<List<dynamic>> avgRatesList = [];
  List<String> avgSpeedList = [];
  List<String> avgStepList = [];
  List<String> avgStepVarList = [];
  List<String> distanceList = [];
  List<String> freezesList = [];
  List<String> stepDurList = [];
  List<String> stepDurVarList = [];
  List<String> stepsList = [];
  List<String> timeList = [];
  List<Timestamp> dateList = [];
  var format = DateFormat('yyyy-MM-dd HH:mm');
  late TabController _tabController;
  bool isLoading = true;
  double todayDistance = 0.0;
  double todayAvgRate = 0.0;
  double todayAvgSpeed = 0.0;
  double todayAvgStepLength = 0.0;
  double todayAvgStepLengthVar = 0.0;
  double todayStepDur = 0.0;
  double todayStepDurVar = 0.0;
  int todayFreezes = 0;
  double weekDistance = 0.0;
  double weekAvgRate = 0.0;
  double weekAvgSpeed = 0.0;
  double weekAvgStepLength = 0.0;
  double weekAvgStepLengthVar = 0.0;
  double weekStepDur = 0.0;
  double weekStepDurVar = 0.0;
  int weekFreezes = 0;
  double monthDistance = 0.0;
  double monthAvgRate = 0.0;
  double monthAvgSpeed = 0.0;
  double monthAvgStepLength = 0.0;
  double monthAvgStepLengthVar = 0.0;
  double monthStepDur = 0.0;
  double monthStepDurVar = 0.0;
  int monthFreezes = 0;
  double sixMonthDistance = 0.0;
  double sixMonthAvgRate = 0.0;
  double sixMonthAvgSpeed = 0.0;
  double sixMonthAvgStepLength = 0.0;
  double sixMonthAvgStepLengthVar = 0.0;
  double sixMonthStepDur = 0.0;
  double sixMonthStepDurVar = 0.0;
  int sixMonthFreezes = 0;
  double yearDistance = 0.0;
  double yearAvgRate = 0.0;
  double yearAvgSpeed = 0.0;
  double yearAvgStepLength = 0.0;
  double yearAvgStepLengthVar = 0.0;
  double yearStepDur = 0.0;
  double yearStepDurVar = 0.0;
  int yearFreezes = 0;
  double allDistance = 0.0;
  double allAvgRate = 0.0;
  double allAvgSpeed = 0.0;
  double allAvgStepLength = 0.0;
  double allAvgStepLengthVar = 0.0;
  double allStepDur = 0.0;
  double allStepDurVar = 0.0;
  int allFreezes = 0;

  void getData() async {
    final uid = auth.currentUser?.uid;
    var resultStat = await firestore.collection("walks").orderBy('date').where("userID", isEqualTo: uid).get();
    for (var doc in resultStat.docs) {
      avgRateList.add(doc['avgRate']);
      avgRatesList.add(doc['avgRates']);
      avgSpeedList.add(doc['avgSpeed']);
      avgStepList.add(doc['avgStep']);
      avgStepVarList.add(doc['avgStepVar']);
      distanceList.add(doc['distance']);
      freezesList.add(doc['freezes']);
      stepDurList.add(doc['stepDur']);
      stepDurVarList.add(doc['stepDurVar']);
      stepsList.add(doc['steps']);
      timeList.add(doc['time']);
      dateList.add(doc['date']);
    }
    setState(() {
      avgRateList = avgRateList.reversed.toList();
      avgRatesList = avgRatesList.reversed.toList();
      avgSpeedList = avgSpeedList.reversed.toList();
      avgStepList = avgStepList.reversed.toList();
      avgStepVarList = avgStepVarList.reversed.toList();
      distanceList = distanceList.reversed.toList();
      freezesList = freezesList.reversed.toList();
      stepDurList = stepDurList.reversed.toList();
      stepDurVarList = stepDurVarList.reversed.toList();
      stepsList = stepsList.reversed.toList();
      timeList = timeList.reversed.toList();
      dateList = dateList.reversed.toList();
      isLoading = false;
      int idx = 0;
      for (var date in dateList) {
        DateTime convert = date.toDate();
        if (DateTime.now().difference(convert).inDays > 1) {
          break;
        } else {
          idx++;
        }
      }
      for (int i = 0; i < idx; i++) {
        todayDistance += double.parse(distanceList[i]);
        todayAvgRate += double.parse(avgRateList[i]);
        todayAvgSpeed += double.parse(avgSpeedList[i]);
        todayAvgStepLength += double.parse(avgStepList[i]);
        todayAvgStepLengthVar += double.parse(avgStepVarList[i]);
        todayStepDur += double.parse(stepDurList[i]);
        todayStepDurVar += double.parse(stepDurVarList[i]);
        todayFreezes += int.parse(freezesList[i]);
      }
      todayAvgRate /= idx;
      todayAvgSpeed /= idx;
      todayAvgStepLength /= idx;
      todayAvgStepLengthVar /= idx;
      todayStepDur /= idx;
      todayStepDurVar /= idx;
      idx = 0;
      for (var date in dateList) {
        DateTime convert = date.toDate();
        if (DateTime.now().difference(convert).inDays > 7) {
          break;
        } else {
          idx++;
        }
      }
      for (int i = 0; i < idx; i++) {
        weekDistance += double.parse(distanceList[i]);
        weekAvgRate += double.parse(avgRateList[i]);
        weekAvgSpeed += double.parse(avgSpeedList[i]);
        weekAvgStepLength += double.parse(avgStepList[i]);
        weekAvgStepLengthVar += double.parse(avgStepVarList[i]);
        weekStepDur += double.parse(stepDurList[i]);
        weekStepDurVar += double.parse(stepDurVarList[i]);
        weekFreezes += int.parse(freezesList[i]);
      }
      weekAvgRate /= idx;
      weekAvgSpeed /= idx;
      weekAvgStepLength /= idx;
      weekAvgStepLengthVar /= idx;
      weekStepDur /= idx;
      weekStepDurVar /= idx;
      idx = 0;
      for (var date in dateList) {
        DateTime convert = date.toDate();
        if (DateTime.now().difference(convert).inDays > 30) {
          break;
        } else {
          idx++;
        }
      }
      for (int i = 0; i < idx; i++) {
        monthDistance += double.parse(distanceList[i]);
        monthAvgRate += double.parse(avgRateList[i]);
        monthAvgSpeed += double.parse(avgSpeedList[i]);
        monthAvgStepLength += double.parse(avgStepList[i]);
        monthAvgStepLengthVar += double.parse(avgStepVarList[i]);
        monthStepDur += double.parse(stepDurList[i]);
        monthStepDurVar += double.parse(stepDurVarList[i]);
        monthFreezes += int.parse(freezesList[i]);
      }
      monthAvgRate /= idx;
      monthAvgSpeed /= idx;
      monthAvgStepLength /= idx;
      monthAvgStepLengthVar /= idx;
      monthStepDur /= idx;
      monthStepDurVar /= idx;
      idx = 0;
      for (var date in dateList) {
        DateTime convert = date.toDate();
        if (DateTime.now().difference(convert).inDays > 182) {
          break;
        } else {
          idx++;
        }
      }
      for (int i = 0; i < idx; i++) {
        sixMonthDistance += double.parse(distanceList[i]);
        sixMonthAvgRate += double.parse(avgRateList[i]);
        sixMonthAvgSpeed += double.parse(avgSpeedList[i]);
        sixMonthAvgStepLength += double.parse(avgStepList[i]);
        sixMonthAvgStepLengthVar += double.parse(avgStepVarList[i]);
        sixMonthStepDur += double.parse(stepDurList[i]);
        sixMonthStepDurVar += double.parse(stepDurVarList[i]);
        sixMonthFreezes += int.parse(freezesList[i]);
      }
      sixMonthAvgRate /= idx;
      sixMonthAvgSpeed /= idx;
      sixMonthAvgStepLength /= idx;
      sixMonthAvgStepLengthVar /= idx;
      sixMonthStepDur /= idx;
      sixMonthStepDurVar /= idx;
      idx = 0;
      for (var date in dateList) {
        DateTime convert = date.toDate();
        if (DateTime.now().difference(convert).inDays > 365) {
          break;
        } else {
          idx++;
        }
      }
      for (int i = 0; i < idx; i++) {
        yearDistance += double.parse(distanceList[i]);
        yearAvgRate += double.parse(avgRateList[i]);
        yearAvgSpeed += double.parse(avgSpeedList[i]);
        yearAvgStepLength += double.parse(avgStepList[i]);
        yearAvgStepLengthVar += double.parse(avgStepVarList[i]);
        yearStepDur += double.parse(stepDurList[i]);
        yearStepDurVar += double.parse(stepDurVarList[i]);
        yearFreezes += int.parse(freezesList[i]);
      }
      yearAvgRate /= idx;
      yearAvgSpeed /= idx;
      yearAvgStepLength /= idx;
      yearAvgStepLengthVar /= idx;
      yearStepDur /= idx;
      yearStepDurVar /= idx;
      for (int i = 0; i < distanceList.length; i++) {
        allDistance += double.parse(distanceList[i]);
        allAvgRate += double.parse(avgRateList[i]);
        allAvgSpeed += double.parse(avgSpeedList[i]);
        allAvgStepLength += double.parse(avgStepList[i]);
        allAvgStepLengthVar += double.parse(avgStepVarList[i]);
        allStepDur += double.parse(stepDurList[i]);
        allStepDurVar += double.parse(stepDurVarList[i]);
        allFreezes += int.parse(freezesList[i]);
      }
      allAvgRate /= idx;
      allAvgSpeed /= idx;
      allAvgStepLength /= idx;
      allAvgStepLengthVar /= idx;
      allStepDur /= idx;
      allStepDurVar /= idx;
    });
  }


  @override
  void initState() {
    _tabController = TabController(length: 6, initialIndex: 0, vsync: this);
    if (isLoading) { getData(); }
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Refresh when scrolled up
    final width = MediaQuery.of(context).size.width;
    return isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: const Align(
                  alignment: Alignment.center,
                  child: Text("Recent Walks", style: TextStyle(fontSize:37, fontWeight: FontWeight.bold))
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Here’s data for your most recently completed\nwalks! Click on a walk to learn more.",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: timeList.isEmpty ? 0 : timeList.length < 3 ? timeList.length : 3,
              itemBuilder: (BuildContext c, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WalkData(
                      timeElapsed: timeList[index],
                      stepCount: stepsList[index],
                      distanceTravelled: double.parse(distanceList[index]),
                      freezes: int.parse(freezesList[index]),
                      avgRate: double.parse(avgRateList[index]),
                      avgSpeed: double.parse(avgSpeedList[index]),
                      avgStepLength: double.parse(avgStepList[index]),
                      avgStepLengthVar: double.parse(avgStepVarList[index]),
                      stepDur: double.parse(stepDurList[index]),
                      stepDurVar: double.parse(stepDurVarList[index]),
                      avgRates: avgRatesList[index],
                      date: format.format(dateList[index].toDate()),
                    )));
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xffD1EFFF),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.blue)
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${stepsList[index]} Steps",
                          style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                        ),
                        Text(
                          "Time Elapsed: ${timeList[index]} minutes",
                          style: const TextStyle(fontSize:14, color: Color(0xff535353))
                        ),
                        Text(
                          "Average Pace: ${double.parse(avgRateList[index]).toStringAsFixed(0)} Steps/Minute",
                          style: const TextStyle(fontSize:14, color: Color(0xff535353))
                        ),
                        Text(
                          "Completed At: ${format.format(dateList[index].toDate())}",
                          style: const TextStyle(fontSize:14, fontWeight: FontWeight.w600, color: Colors.black)
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllWalks(
                  avgRateList: avgRateList,
                  avgRatesList: avgRatesList,
                  avgSpeedList: avgSpeedList,
                  avgStepList: avgStepList,
                  avgStepVarList: avgStepVarList,
                  distanceList: distanceList,
                  freezesList: freezesList,
                  stepDurList: stepDurList,
                  stepDurVarList: stepDurVarList,
                  stepsList: stepsList,
                  timeList: timeList,
                  dateList: dateList
                )));
              },
              child: const Text("View More", style: TextStyle(fontSize: 14, color: Colors.black, decoration: TextDecoration.underline)),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15, top: 20),
              child: const Align(
                  alignment: Alignment.center,
                  child: Text("Data Trends", style: TextStyle(fontSize:37, fontWeight: FontWeight.bold))
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "View trends in your recent data! Switch\nbetween lengths of time graph data",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
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
                  Tab(text: "D"),
                  Tab(text: "W"),
                  Tab(text: "M"),
                  Tab(text: "6M"),
                  Tab(text: "Y"),
                  Tab(text: "All")
                ],
              )
            ),
            SizedBox(
              height: 900,
              child: TabBarView(
                controller: _tabController,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "Today's Summary",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const Divider(
                          thickness: 1,
                          color: Colors.black
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
                                "${todayDistance.toStringAsFixed(1)} Meters",
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
                                "${todayAvgRate.toStringAsFixed(1)} Steps/Minute",
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
                                "${todayAvgSpeed.toStringAsFixed(1)} Meters/Second",
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
                                "${todayAvgStepLength.toStringAsFixed(1)} Meters",
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
                                "${todayAvgStepLengthVar.toStringAsFixed(1)} Meters",
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
                                "${todayStepDur.toStringAsFixed(1)} Seconds",
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
                                "${todayStepDurVar.toStringAsFixed(1)} Seconds",
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
                                "$todayFreezes Freezes",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "This Week's Summary",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const Divider(
                          thickness: 1,
                          color: Colors.black
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
                                "${weekDistance.toStringAsFixed(1)} Meters",
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
                                "${weekAvgRate.toStringAsFixed(1)} Steps/Minute",
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
                                "${weekAvgSpeed.toStringAsFixed(1)} Meters/Second",
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
                                "${weekAvgStepLength.toStringAsFixed(1)} Meters",
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
                                "${weekAvgStepLengthVar.toStringAsFixed(1)} Meters",
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
                                "${weekStepDur.toStringAsFixed(1)} Seconds",
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
                                "${weekStepDurVar.toStringAsFixed(1)} Seconds",
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
                                "$weekFreezes Freezes",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "This Month's Summary",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const Divider(
                          thickness: 1,
                          color: Colors.black
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
                                "${monthDistance.toStringAsFixed(1)} Meters",
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
                                "${monthAvgRate.toStringAsFixed(1)} Steps/Minute",
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
                                "${monthAvgSpeed.toStringAsFixed(1)} Meters/Second",
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
                                "${monthAvgStepLength.toStringAsFixed(1)} Meters",
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
                                "${monthAvgStepLengthVar.toStringAsFixed(1)} Meters",
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
                                "${monthStepDur.toStringAsFixed(1)} Seconds",
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
                                "${monthStepDurVar.toStringAsFixed(1)} Seconds",
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
                                "$monthFreezes Freezes",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "6 Months' Summary",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const Divider(
                          thickness: 1,
                          color: Colors.black
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
                                "${sixMonthDistance.toStringAsFixed(1)} Meters",
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
                                "${sixMonthAvgRate.toStringAsFixed(1)} Steps/Minute",
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
                                "${sixMonthAvgSpeed.toStringAsFixed(1)} Meters/Second",
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
                                "${sixMonthAvgStepLength.toStringAsFixed(1)} Meters",
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
                                "${sixMonthAvgStepLengthVar.toStringAsFixed(1)} Meters",
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
                                "${sixMonthStepDur.toStringAsFixed(1)} Seconds",
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
                                "${sixMonthStepDurVar.toStringAsFixed(1)} Seconds",
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
                                "$sixMonthFreezes Freezes",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "This Year's Summary",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const Divider(
                          thickness: 1,
                          color: Colors.black
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
                                "${yearDistance.toStringAsFixed(1)} Meters",
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
                                "${yearAvgRate.toStringAsFixed(1)} Steps/Minute",
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
                                "${yearAvgSpeed.toStringAsFixed(1)} Meters/Second",
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
                                "${yearAvgStepLength.toStringAsFixed(1)} Meters",
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
                                "${yearAvgStepLengthVar.toStringAsFixed(1)} Meters",
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
                                "${yearStepDur.toStringAsFixed(1)} Seconds",
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
                                "${yearStepDurVar.toStringAsFixed(1)} Seconds",
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
                                "$yearFreezes Freezes",
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "All Summary",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const Divider(
                          thickness: 1,
                          color: Colors.black
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
                                "${allDistance.toStringAsFixed(1)} Meters",
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
                                "${allAvgRate.toStringAsFixed(1)} Steps/Minute",
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
                                "${allAvgSpeed.toStringAsFixed(1)} Meters/Second",
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
                                "${allAvgStepLength.toStringAsFixed(1)} Meters",
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
                                "${allAvgStepLengthVar.toStringAsFixed(1)} Meters",
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
                                "${allStepDur.toStringAsFixed(1)} Seconds",
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
                                "${allStepDurVar.toStringAsFixed(1)} Seconds",
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
                                "$allFreezes Freezes",
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}