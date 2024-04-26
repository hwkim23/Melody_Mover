import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:melody_mover/pages/endwalk.dart';
import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:metronome/metronome.dart';
import 'package:flutter/services.dart';

final Map<int, List<String>> cues = {
  0: ["Metronome", "Provides a beat for you to follow, with or without music."],
  1: ["Footfall", "Plays footfall noises at your selected pace."],
  2: ["Verbal Cue", "Plays selected or custom verbal cue at the selected pace."],
  3: ["Haptic Feedback", "Plays a haptic feedback at your selected pace."]
};
final Map<int, List<String>> rates = {
  0: ["Auto", "Auto detects your pace"],
  1: ["10 Steps/Minute", ""],
  2: ["20 Steps/Minute", ""],
  3: ["30 Steps/Minute", ""],
  4: ["40 Steps/Minute", ""],
  5: ["50 Steps/Minute", ""],
  6: ["60 Steps/Minute", ""],
  7: ["70 Steps/Minute", ""],
  8: ["80 Steps/Minute", ""]
};
String selectedCue = "";
String selectedRate = "";

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
  int wpm = 0;
  bool isStart = false;
  bool isPause = false;
  double tempo = 0;
  bool soundEnabled = true;
  double distanceTravelled = 0;
  double startLatitude = 0;
  double startLongitude = 0;
  double currentLatitude = 0;
  double currentLongitude = 0;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final StopWatchTimer _stopWatchTimerWalk = StopWatchTimer();
  final metronome = Metronome();
  double bpm = 120;
  double vol = 50;
  String finalTime = "";
  String finalStepCount = "";
  double finalDistance = 0;
  int freezes = 0;
  List<int> stepCounts = [];
  List<double> distances = [];
  bool isFroze = false;
  bool isStartedWalking = false;
  bool isAddedSteps = false;
  Timer? _timerHaptic;

  @override
  void initState() {
    distanceTravelled = 0;
    stepCount = 0;
    metronome.init('assets/audio/metronome.wav', bpm: bpm, volume: vol);
    super.initState();
  }

  void start(double tempo) {
    metronome.play(tempo);
  }

  void _startHapticFeedbackLoop(double tempo) {
    final int interval = 60000 ~/ tempo; // Convert BPM to interval in milliseconds
    _timerHaptic?.cancel();
    _timerHaptic = Timer.periodic(Duration(milliseconds: interval), (timer) {
      if (!isPause) {
        HapticFeedback.heavyImpact(); // Trigger haptic feedback
      }
    });
  }

  void _stopHapticFeedbackLoop() {
    _timerHaptic?.cancel();
    _timerHaptic = null;
  }

  bool isPlaying = false;

  void changeBPM(double tempo) {
    if (!isPlaying) {
      metronome.play(tempo);
      isPlaying = true;
    } else {
      metronome.setBPM(tempo);
    }
  }

  void stop() {
    metronome.stop();
    isPlaying = false;
  }

  void listenLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;

      if (_status == "walking") {
        distanceTravelled += GeolocatorPlatform.instance.distanceBetween(startLatitude, startLongitude, currentLatitude, currentLongitude);
      }

      startLatitude = currentLatitude;
      startLongitude = currentLongitude;
    });
  }

  @override
  void dispose() {
    _stopHapticFeedbackLoop();
    super.dispose();
  }

  void onStepCount(StepCount event) {
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
      wpm = 0;
      strStep = "$stepCount";
    });
  }

  void startWalking() {
    setState(() {
      isStart = true;
      isPause = false;
    });
  }

  void stopWalking() {
    setState(() {
      isStart = false;
    });
  }

  void pauseWalking() {
    setState(() {
      isPause = true;
    });
  }

  void resumeWalking() {
    setState(() {
      isPause = false;
    });
  }

  void saveTime(String time) {
    setState(() {
      finalTime = time;
    });
  }

  void incrementFreeze() {
    freezes++;
  }

  void addSteps() {
    stepCounts.add(stepCount);
  }

  bool isStarted = false;
  int startTime = 0;
  bool startChecking = true;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: 30),
      child: Column(
        children: <Widget>[
          Visibility(
            visible: isStart,
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
                child: const Text("I Need Assistance", style: TextStyle(color: Color(0xff0496FF), fontSize: 18)),
              ),
            )
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Align(
              alignment: Alignment.center,
              child: Text(!isStart ? "Ready to move?" : !isPause ? "Walk In Session!" : "Walk Paused", style: const TextStyle(fontSize:32, fontWeight: FontWeight.bold))
            ),
          ),
          Visibility(
            visible: !isStart,
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: const Align(
                alignment: Alignment.center,
                child: Text(
                  "Let’s get going! Before we start, we’ll set up\n your settings for this session.",
                  style: TextStyle(fontSize:14, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center
                )
              ),
            ),
          ),
          Visibility(
            visible: isStart,
            child: Container(
              width: double.infinity,
              height: 410,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: !isPause ? const Color(0xff0496FF) : const Color(0xffD1EFFF),
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
                          child: Text(
                              "Time Elapsed",
                              style: TextStyle(fontSize:14, fontWeight: FontWeight.w600, color: !isPause ? const Color(0xffD1EFFF) : const Color(0xff0496FF))
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: StreamBuilder<int>(
                            stream: _stopWatchTimer.secondTime,
                            initialData: _stopWatchTimer.secondTime.value,
                            builder: (context, snap) {
                              final time = snap.data;
                              if (time! % 5 == 0) {
                                listenLocation();
                              }
                              finalTime = time.toString();
                              if (_status != "walking") {
                                _stopWatchTimerWalk.onStopTimer();
                                if (isFroze == false && time != 0 && isStartedWalking == true) {
                                  incrementFreeze();
                                  isFroze = true;
                                }
                              } else {
                                isFroze = false;
                                isStartedWalking = true;
                                _stopWatchTimerWalk.onStartTimer();
                              }
                              if (time != 0 && time % 60 != 0) {
                                isAddedSteps = false;
                              }
                              if (time != 0 && time % 60 == 0 && isAddedSteps == false) {
                                addSteps();
                                isAddedSteps = true;
                                distances.add(distanceTravelled);
                              }
                              return Text(
                                  time.toString(),
                                  style: TextStyle(fontSize:40, fontWeight: FontWeight.w600, color: !isPause ? Colors.white : Colors.black)
                              );
                            },
                          ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              "You're Moving To",
                              style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: !isPause ? const Color(0xffD1EFFF) : const Color(0xff0496FF))
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Hotel California",
                                  style: TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: !isPause ? Colors.white : Colors.black)
                              ),
                              Text(
                                  "Playing from Playlist - Oldies Bops",
                                  style: TextStyle(fontSize:15, fontWeight: FontWeight.w600, color:!isPause ? Colors.white : Colors.black)
                              ),
                            ],
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              "Current Rate",
                              style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: !isPause ? const Color(0xffD1EFFF) : const Color(0xff0496FF))
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              selectedRate == "Auto" ? "$selectedRate - Tempo: $tempo" : selectedRate,
                              style: TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: !isPause ? Colors.white : Colors.black)
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              "Distance Walked",
                              style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: !isPause ? const Color(0xffD1EFFF) : const Color(0xff0496FF))
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              "${distanceTravelled.toStringAsFixed(1)} Meters",
                              style: TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: !isPause ? Colors.white : Colors.black)
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              "Steps Taken",
                              style: TextStyle(fontSize:13, fontWeight: FontWeight.w600, color: !isPause ? const Color(0xffD1EFFF) : const Color(0xff0496FF))
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: StreamBuilder<int>(
                            stream: _stopWatchTimerWalk.secondTime,
                            initialData: _stopWatchTimerWalk.secondTime.value,
                            builder: (context, snap) {
                              final value = snap.data;
                              if (selectedRate == "Auto" && value! >= 5 && value % 5 == 0) {
                                wpm = (((stepCount-1.5) / value) * 60).round();
                                tempo = wpm.toDouble();
                                if (isStarted == false) {
                                  isStarted = true;
                                  if (selectedCue != "Haptic Feedback") {
                                    changeBPM(tempo);
                                  } else {
                                    _startHapticFeedbackLoop(tempo);
                                  }
                                  isStarted = true;
                                } else {
                                  isStarted = false;
                                }
                              } else if (value != 0) {
                                wpm = (((stepCount) / value!) * 60).round();
                              }
                              finalStepCount = stepCount.toString();
                              return Text(
                                  "$strStep Steps",
                                  style: TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: !isPause ? Colors.white : Colors.black)
                              );
                            }
                          )
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
          Visibility(
            visible: !isStart,
            child: Container(
              height: 320,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  color: const Color(0xff0496FF),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 7),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Cue",
                          style: TextStyle(fontSize:15, fontWeight: FontWeight.w600, color: Colors.white)
                        )
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: CustomDropdownMenu(item: cues, height: 332, isCue: true,),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Rate",
                          style: TextStyle(fontSize:15, fontWeight: FontWeight.w600, color: Colors.white)
                        )
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: CustomDropdownMenu(item: rates, height: 424, isCue: false,)
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Music",
                          style: TextStyle(fontSize:15, fontWeight: FontWeight.w600, color: Colors.white)
                        )
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Container()
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isStart,
            child: SizedBox(
                width: double.infinity,
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
                      if (selectedCue == "Metronome") {
                        await metronome.setAudioAssets('assets/audio/metronome.wav');
                      } else if (selectedCue == "Footfall") {
                        await metronome.setAudioAssets('assets/audio/footfall.wav');
                      } else if (selectedCue == "Verbal Cue") {
                        await metronome.setAudioAssets('assets/audio/verbalcue.wav');
                      }

                      if (selectedRate != "Auto") {
                        stepCount = 0;
                        distanceTravelled = 0;
                        tempo = double.parse(selectedRate.substring(0, 2));
                        startWalking();
                        if (selectedCue != "Haptic Feedback") {
                          start(tempo);
                        } else {
                          _startHapticFeedbackLoop(tempo);
                        }
                        _stopWatchTimer.onStartTimer();
                        _stopWatchTimerWalk.onStartTimer();
                        initPlatformState();
                        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
                        setState(() {
                          startLatitude = position.latitude;
                          startLongitude = position.longitude;
                          currentLatitude = position.latitude;
                          currentLongitude = position.longitude;
                        });
                      } else {
                        stepCount = 0;
                        distanceTravelled = 0;
                        startWalking();
                        _stopWatchTimer.onStartTimer();
                        _stopWatchTimerWalk.onStartTimer();
                        tempo = 0;
                        initPlatformState();
                        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
                        setState(() {
                          startLatitude = position.latitude;
                          startLongitude = position.longitude;
                          currentLatitude = position.latitude;
                          currentLongitude = position.longitude;
                        });
                      }
                    },
                    child: const Text("Start Session", style: TextStyle(color: Colors.white, fontSize: 18))
                )
            ),
          ),
          Visibility(
            visible: isStart,
            child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.only(bottom: 20),
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
                      if (isPause == false) {
                        pauseWalking();
                        _stopWatchTimer.onStopTimer();
                        _stopWatchTimerWalk.onStopTimer();
                        if (selectedCue != "Haptic Feedback") {
                          metronome.stop();
                        }
                      } else {
                        resumeWalking();
                        startWalking();
                        _stopWatchTimer.onStartTimer();
                        _stopWatchTimerWalk.onStartTimer();
                        if (selectedCue != "Haptic Feedback") {
                          metronome.play(tempo);
                        }
                      }
                    },
                    child: Text(!isPause ? "Pause Walk" : "Resume", style: const TextStyle(color: Colors.white, fontSize: 18))
                )
            ),
          ),
          Visibility(
            visible: isStart,
            child: SizedBox(
              width: double.infinity,
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
                  if (selectedCue == "Haptic Feedback") {
                    _stopHapticFeedbackLoop();
                  } else {
                    stop();
                  }
                  stopWalking();
                  _stopWatchTimer.onStopTimer();
                  _stopWatchTimerWalk.onStopTimer();
                  reset();
                  setState(() {
                    tempo = 0;
                    finalDistance = distanceTravelled;
                  });
                  _stopWatchTimer.onResetTimer();
                  _stopWatchTimerWalk.onResetTimer();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EndWalk(
                              timeElapsed: finalTime,
                              stepCount: finalStepCount,
                              distanceTravelled: finalDistance,
                              stepCounts: stepCounts,
                              freezes: freezes,
                              distances: distances,
                          )));
                },
                child: const Text("End Walk", style: TextStyle(color: Colors.white, fontSize: 18))
              ),
            ),
          )
        ],
      ),
    );
  }
}

//TODO: Make separate widgets
class CustomDropdownMenu extends StatefulWidget {
  final Map<int, List<String>> item;
  final double height;
  final bool isCue;

  const CustomDropdownMenu({super.key, required this.item, required this.height, required this.isCue});

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  bool _isClicked = false;
  final ScrollController _controllerOne = ScrollController();
  OverlayEntry? overlayEntry;

  void create(Map<int, List<String>> item) {
    overlayEntry = OverlayEntry(builder: (context) {
      final width = MediaQuery.of(context).size.width;
      return Positioned(
        left: width * 0.05 + 15,
        right: width * 0.05 + 15,
        top: widget.height,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xffD1EFFF),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Scrollbar(
            thumbVisibility: true,
            controller: _controllerOne,
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: item.length,
              controller: _controllerOne,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.isCue) {
                          selectedCue = item[index]![0];
                        } else {
                          selectedRate = item[index]![0];
                        }
                        _isClicked = false;
                      });
                      removeOverlay();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle(
                            style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                            child: Text(item[index]![0]),
                          ),
                          DefaultTextStyle(
                            style: const TextStyle(fontSize: 12, color: Colors.black),
                            child: Text(item[index]![1]),
                          ),
                        ],
                      ),
                    )
                );
              },
            ),
          ),
        ),
      );
    });
  }

  void insertOverlay(BuildContext context, Map<int, List<String>> item) {
    create(item);

    return Overlay.of(context).insert(overlayEntry!);
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry?.dispose();
    overlayEntry = null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.isCue) {
      selectedCue = widget.item[0]![0];
    } else {
      selectedRate = widget.item[0]![0];
    }
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isClicked = !_isClicked;
          if (_isClicked) {
            insertOverlay(context, widget.item);
          } else {
            removeOverlay();
          }
        });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: Colors.white),
          color: const Color(0xff0496FF)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.isCue
                ? Text(selectedCue, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),)
                : Text(selectedRate, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
              !_isClicked ? const Icon(Icons.keyboard_arrow_down, color: Colors.white,) : const Icon(Icons.keyboard_arrow_up, color: Colors.white,)
            ],
          ),
        ),
      ),
    );
  }
}