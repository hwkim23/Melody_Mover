import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatefulWidget {
  final String trackUrl;
  final String? artworkUrl; // Optional artwork URL for the track

  const PlayerWidget({
    required this.trackUrl,
    this.artworkUrl,
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

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    initializePlayer();
  }

  void initializePlayer() async {
    await player.setSourceUrl(widget.trackUrl); // Initial source setup for the player
    _initStreams();
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen((position) {
      setState(() => _position = position);
    });

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() => _position = Duration.zero);
    });

    _playerStateSubscription = player.onPlayerStateChanged.listen((state) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateSubscription?.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.artworkUrl != null)
          Image.network(widget.artworkUrl!),
        Slider(
          min: 0.0,
          max: _duration.inSeconds.toDouble(),
          value: _position.inSeconds.toDouble(),
          onChanged: (value) => player.seek(Duration(seconds: value.toInt())),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: player.state == PlayerState.playing ? () => player.pause() : () => player.resume(),
              icon: Icon(player.state == PlayerState.playing ? Icons.pause : Icons.play_arrow),
              color: color,
            ),
            IconButton(
              onPressed: () => player.stop(),
              icon: const Icon(Icons.stop),
              color: color,
            ),
          ],
        ),
        Text(
          '${_position.toString().split('.').first} / ${_duration.toString().split('.').first}',
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
