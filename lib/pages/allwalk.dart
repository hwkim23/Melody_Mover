import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:melody_mover/pages/walkdata.dart';
import 'package:provider/provider.dart';
import '../appbar.dart';
import '../bottomnavigationbar.dart';
import '../drawer.dart';
import '../store.dart';

class AllWalks extends StatefulWidget {
  final List<String> avgRateList;
  final List<List<dynamic>> avgRatesList;
  final List<String> avgSpeedList;
  final List<String> avgStepList;
  final List<String> avgStepVarList;
  final List<String> distanceList;
  final List<String> freezesList;
  final List<String> stepDurList;
  final List<String> stepDurVarList;
  final List<String> stepsList;
  final List<String> timeList;
  final List<Timestamp> dateList;
  const AllWalks({
    super.key,
    required this.avgRateList,
    required this.avgRatesList,
    required this.avgSpeedList,
    required this.avgStepList,
    required this.avgStepVarList,
    required this.distanceList,
    required this.freezesList,
    required this.stepDurList,
    required this.stepDurVarList,
    required this.stepsList,
    required this.timeList,
    required this.dateList
  });

  @override
  State<AllWalks> createState() => _AllWalksState();
}

class _AllWalksState extends State<AllWalks> {
  var format = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    context.read<Store1>().inactiveIndex();
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
                        child: Text("All Walks", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.avgRateList.length,
                itemBuilder: (BuildContext c, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => WalkData(
                        timeElapsed: widget.timeList[index],
                        stepCount: widget.stepsList[index],
                        distanceTravelled: double.parse(widget.distanceList[index]),
                        freezes: int.parse(widget.freezesList[index]),
                        avgRate: double.parse(widget.avgRateList[index]),
                        avgSpeed: double.parse(widget.avgSpeedList[index]),
                        avgStepLength: double.parse(widget.avgStepList[index]),
                        avgStepLengthVar: double.parse(widget.avgStepVarList[index]),
                        stepDur: double.parse(widget.stepDurList[index]),
                        stepDurVar: double.parse(widget.stepDurVarList[index]),
                        avgRates: widget.avgRatesList[index],
                        date: format.format(widget.dateList[index].toDate()),
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
                              "${widget.stepsList[index]} Steps",
                              style: const TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: Colors.black)
                          ),
                          Text(
                              "Time Elapsed: ${widget.timeList[index]} minutes",
                              style: const TextStyle(fontSize:14, color: Color(0xff535353))
                          ),
                          Text(
                              "Average Pace: ${double.parse(widget.avgRateList[index]).toStringAsFixed(0)} Steps/Minute",
                              style: const TextStyle(fontSize:14, color: Color(0xff535353))
                          ),
                          Text(
                              "Completed At: ${format.format(widget.dateList[index].toDate())}",
                              style: const TextStyle(fontSize:14, fontWeight: FontWeight.w600, color: Colors.black)
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ) : context.watch<Store1>().pages.elementAt(context.watch<Store1>().selectedIndex),
      bottomNavigationBar: const BaseBottomNavigationBar(),
    );
  }
}