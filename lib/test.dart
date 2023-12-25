import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:quiver/time.dart';

const metronomeAudioPath = 'audio/243748__unfa__metronome-2khz-strong-pulse.wav';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  StreamSubscription<DateTime>? a;

  final player = AudioPlayer();
  bool soundEnabled = true;
  double tempo = 60.0;

  void playAudio() async {
    if (soundEnabled) {
      player.play(AssetSource(metronomeAudioPath));
    }
  }

  void start() {
    if (a == null) {
      a = Metronome.epoch(aMillisecond * (60000 / tempo).round()).listen((d) => playAudio());
    } else {
      a?.cancel();
      a = Metronome.epoch(aMillisecond * (60000 / tempo).round()).listen((d) => playAudio());
    }
  }

  void modify(double tempo) {
    setState(() {
      a?.cancel();
      //num = aSecond * ang;
      a = Metronome.epoch(aMillisecond * (60000 / tempo).round()).listen((d) => playAudio());
    });
  }

  void stop() {
    a?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                start();
              },
              child: Text("test"),
            ),
            FilledButton(
              onPressed: () {
                modify(90);
              },
              child: Text("test2"),
            ),
            FilledButton(
              onPressed: () {
                stop();
              },
              child: Text("test3"),
            ),
          ],
        ),
      ),
    );
  }
}
