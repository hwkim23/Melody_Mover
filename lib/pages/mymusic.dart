import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../appbar.dart';
import '../bottomnavigationbar.dart';
import '../drawer.dart';
import '../store.dart';
import 'package:spotify/spotify.dart';
import 'package:audioplayers/audioplayers.dart';
import '/pages/spotify/callingAccessToken.dart'; // Ensure this path is correct
import '/pages/spotify/musicplayer.dart';

class MyMusic extends StatefulWidget {
  const MyMusic({super.key});

  @override
  State<MyMusic> createState() => _MyMusicState();
}

class _MyMusicState extends State<MyMusic> {
  List<PlaylistSimple>? _playlists;
  SpotifyApi? spotifyApi;
  List<Track>? _tracks; // Assuming Track is the correct type
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    context.read<Store1>().inactiveIndex();
    _initializeSpotify();
  }

  Future<void> _initializeSpotify() async {
    final accessTokenResult = await SpotifyAuth.getAccessToken();
    if (accessTokenResult != null &&
        accessTokenResult['access_token'] != null) {
      spotifyApi = SpotifyApi(SpotifyApiCredentials(
          'd73794ac45a944ba8702d084ce52280c',
          'da49d565cbbf48f597dc8fd5f6984303',
          accessToken: accessTokenResult['access_token'] as String));
      _fetchUserPlaylists();
    } else {
      print("Failed to log in");
    }
  }

  Future<void> _fetchUserPlaylists() async {
    if (spotifyApi == null) return;
    //TODO Here we want to implement a way to put the user into the get user's playlists
    final playlists = await spotifyApi!.playlists
        .getUsersPlaylists('ritul123')
        .all(); // Assume this is the correct method
    setState(() {
      _playlists =
          playlists.toList(); // Adjust based on actual method return type
    });
  }

  Future<void> _fetchTracksAndPlay(String playlistId) async {
    if (spotifyApi == null) return;
    var playlistTracks =
        await spotifyApi!.playlists.getTracksByPlaylistId(playlistId).all();
    // Assuming you just want to play the first track for simplicity
    var firstTrack = playlistTracks.isNotEmpty ? playlistTracks.first : null;
    if (firstTrack != null) {
      audioPlayer.play(UrlSource(firstTrack.previewUrl ?? ""));
    }
  }

  Future<void> _fetchTracks(String playlistId) async {
    if (spotifyApi == null) return;
    var tracks =
        await spotifyApi!.playlists.getTracksByPlaylistId(playlistId).all();
    setState(() {
      _tracks = tracks.toList();
      _playlists = null; // Optionally reset playlists to hide playlist view
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: BaseAppBar(appBar: AppBar()),
      drawer: const BaseDrawer(),
      body: SizedBox(
        width: width,
        height: height,
        child:
            _playlists != null ? buildPlaylistListView() : buildTrackListView(),
      ),
      bottomNavigationBar: const BaseBottomNavigationBar(),
    );
  }

  Widget buildPlaylistListView() {
    return ListView.builder(
      itemCount: _playlists!.length,
      itemBuilder: (context, index) {
        var playlist = _playlists![index];
        return ListTile(
          title: Text(playlist.name ?? 'No Name'),
          onTap: () => _fetchTracks(playlist.id!),
        );
      },
    );
  }

  Widget buildTrackListView() {
    return ListView.builder(
      itemCount: _tracks?.length ?? 0,
      itemBuilder: (context, index) {
        var track = _tracks![index];
        return ListTile(
          title: Text(track.name ?? 'No Track Name'),
          onTap: () {
            if (track.previewUrl != null) { // Check if URL is not null
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(title: const Text("Playing Track")),
                  body: PlayerWidget(trackUrl: track.previewUrl!), // Use the bang operator to assert that the URL is not null
                ),
              ));
            } else {
              // Handle the case where there is no URL (maybe show a dialog or a toast notification)
              print("No preview URL available for this track.");
            }
          },
        );
      },
    );
  }
}





