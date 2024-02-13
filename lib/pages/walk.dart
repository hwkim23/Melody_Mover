import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:metronome/metronome.dart';

final Map<int, List<String>> cues = {
  0: ["Metronome", "Provides a beat for you to follow, with or without music."],
  1: ["Footfall", "Plays footfall noises at your selected pace."],
  2: ["Verbal Cue", "Plays selected or custom verbal cue at the selected pace."],
  3: ["Video", "Plays a video of someone walking, with or without sound."]
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
  var wpms = [0, 0];
  bool isStart = false;
  bool isPause = false;
  double tempo = 0;
  bool soundEnabled = true;
  //static AudioPlayer player = AudioPlayer();
  double distanceTravelled = 0;
  double startLatitude = 0;
  double startLongitude = 0;
  double currentLatitude = 0;
  double currentLongitude = 0;
  late StreamSubscription<Position> positionStream;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final StopWatchTimer _stopWatchTimerWalk = StopWatchTimer();
  final metronome = Metronome();
  double bpm = 120;
  double vol = 50;

  @override
  void initState() {
    metronome.init('assets/audio/243748__unfa__metronome-2khz-strong-pulse.wav', bpm: bpm, volume: vol);
    //print("hi");
    super.initState();
  }

  void start(double tempo) {
    //metronome.setBPM(tempo);
    metronome.play(tempo);
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

  void measuringDistance() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) {
          //print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
          setState(() {
            currentLatitude = position!.latitude;
            currentLongitude = position.longitude;
          });
        });

    setState(() {
      distanceTravelled = GeolocatorPlatform.instance.distanceBetween(startLatitude, startLongitude, currentLatitude, currentLongitude);
    });
  }

  @override
  void dispose() {
    positionStream.cancel();
    super.dispose();
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

                              if (_status != "walking") {
                                _stopWatchTimerWalk.onStopTimer();
                              } else {
                                _stopWatchTimerWalk.onStartTimer();
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
                              "$distanceTravelled Meters",
                              style: TextStyle(fontSize:24, fontWeight: FontWeight.w600, color: !isPause ? Colors.white : Colors.black)
                          )
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                              "Steps Walked",
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
                              //print(value);
                              if (selectedRate == "Auto" && value! >= 5 && value % 5 == 0) {
                                wpm = (((stepCount) / value) * 60).round();
                                tempo = wpm.toDouble();
                                if (isStarted == false) {
                                  isStarted = true;
                                  changeBPM(tempo);
                                  isStarted = true;
                                } else {
                                  isStarted = false;
                                }
                              } else if (value != 0) {
                                wpm = (((stepCount) / value!) * 60).round();
                              }
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
                        child: CustomDropdownMenu(item: cues, height: 325, isCue: true,),
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
                        child: CustomDropdownMenu(item: rates, height: 415, isCue: false,)
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
                      if (selectedRate != "Auto") {
                        tempo = double.parse(selectedRate.substring(0, 2));
                        startWalking();
                        start(tempo);
                        _stopWatchTimer.onStartTimer();
                        _stopWatchTimerWalk.onStartTimer();
                        initPlatformState();
                        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        setState(() {
                          startLatitude = position.latitude;
                          startLongitude = position.longitude;
                        });
                        //measuringDistance();
                      } else {
                        startWalking();
                        _stopWatchTimer.onStartTimer();
                        _stopWatchTimerWalk.onStartTimer();
                        tempo = 0;
                        initPlatformState();
                        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                        setState(() {
                          startLatitude = position.latitude;
                          startLongitude = position.longitude;
                        });
                        //measuringDistance();
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
                        metronome.stop();
                      } else {
                        resumeWalking();
                        startWalking();
                        /*_timer = _scheduleTimer(
                          _calculateTimerInterval(tempo.round()),
                        );*/
                        _stopWatchTimer.onStartTimer();
                        _stopWatchTimerWalk.onStartTimer();
                        //await _timer.start();
                        metronome.play(tempo);
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
                  //TODO: End function
                  stopWalking();
                  stop();
                  //await _timer.stop();
                  _stopWatchTimer.onResetTimer();
                  _stopWatchTimerWalk.onResetTimer();
                  positionStream.cancel();
                  reset();
                  setState(() {
                    tempo = 0;
                  });
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