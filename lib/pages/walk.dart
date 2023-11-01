import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';

class Walking extends StatefulWidget {
  const Walking({super.key});

  @override
  State<Walking> createState() => _WalkingState();
}

class _WalkingState extends State<Walking> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  int stepCount = 0;
  bool isOne = true;
  String strStep = "0";
  bool isPressed = false;
  Timer? timer;
  int timePassed = 0;
  int wpm = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void walkingRate() {
    setState(() {
      if (stepCount != 0) {
        timePassed += 1;
        wpm = ((stepCount / timePassed) * 60).round();
      }
    });
  }

  void onStepCount(StepCount event) {
    if (kDebugMode) {
      print(event);
    }
    setState(() {
      if (isOne == true) {
        stepCount = 0;
        isOne = false;
      } else {
        stepCount += 1;
      }
      strStep = "$stepCount";
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (kDebugMode) {
      print(event);
    }
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    if (kDebugMode) {
      print('onPedestrianStatusError: $error');
    }
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    if (kDebugMode) {
      print(_status);
    }
  }

  void onStepCountError(error) {
    if (kDebugMode) {
      print('onStepCountError: $error');
    }
    setState(() {
      strStep = 'Step Count not available';
    });
  }

  void initPlatformState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => walkingRate());

    setState(() {
      isPressed = true;
      isOne = true;
    });

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void reset() {
    setState(() {
      isPressed = false;
      stepCount = 0;
      timePassed = 0;
      wpm = 0;
      strStep = "$stepCount";
    });

    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text("Ready to move?", style: TextStyle(fontSize:35, fontWeight: FontWeight.bold))
            ),
          ),
          Container(
            height: 400,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
            ),
          ),
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
                  child: const Text("Start Session", style: TextStyle(color: Colors.blue)))),
        ],
      ),
    );
  }
}
