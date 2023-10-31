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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Steps Taken',
            style: TextStyle(fontSize: 30),
          ),
          Text(
            strStep,
            style: const TextStyle(fontSize: 60),
          ),
          const Divider(
            height: 100,
            thickness: 0,
            color: Colors.white,
          ),
          const Text(
            'Status',
            style: TextStyle(fontSize: 30),
          ),
          Icon(
            _status == 'walking'
                ? Icons.directions_walk
                : _status == 'stopped'
                ? Icons.accessibility_new
                : Icons.error,
            size: 75,
          ),
          Center(
            child: Text(
              _status,
              style: _status == 'walking' || _status == 'stopped'
                  ? const TextStyle(fontSize: 30)
                  : const TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
          FilledButton(
              onPressed: () {isPressed ? reset() : initPlatformState();},
              child: isPressed ? const Text("Stop") : const Text("Start")),
          Text("Time passed: $timePassed, Walking rate per minute: $wpm"),
        ],
      ),
    );
  }
}
