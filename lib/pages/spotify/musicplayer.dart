import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  final String trackUrl;

  const PlayerWidget({
    required this.trackUrl,
    Key? key,
  }) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late AudioPlayer player;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateSubscription;

  bool get _isPlaying => player.state == PlayerState.playing;
  bool get _isPaused => player.state == PlayerState.paused;

  String get _durationText => _duration.toString().split('.').first;
  String get _positionText => _position.toString().split('.').first;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    initializePlayer();
  }

  void initializePlayer() async {
    await player.setSourceUrl(widget.trackUrl);
    _initStreams();
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _positionSubscription = player.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _position = Duration.zero;
      });
    });

    _playerStateSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {}); // Just update the state to reflect UI changes
    });
  }

  @override
  void dispose() {
    player.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Slider(
          min: 0.0,
          max: (_duration.inSeconds > 0) ? _duration.inSeconds.toDouble() : 1.0,
          value:
              (_position.inSeconds > 0) ? _position.inSeconds.toDouble() : 0.0,
          onChanged: (value) {
            player.seek(Duration(seconds: value.toInt()));
          },
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: _isPlaying ? null : () => player.resume(),
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              color: color,
            ),
            IconButton(
              onPressed: (_isPlaying || _isPaused) ? () => player.stop() : null,
              icon: const Icon(Icons.stop),
              color: color,
            ),
          ],
        ),
        Text(
          '${_positionText} / ${_durationText}',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
