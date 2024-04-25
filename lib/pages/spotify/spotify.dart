// import 'package:flutter/material.dart';
// import 'package:spotify/spotify.dart';
// import '/pages/spotify/callingAccessToken.dart';
// import '/pages/spotify/musicplayer.dart';
// import 'package:audioplayers/audioplayers.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: SpotifyLogin(),
//     );
//   }
// }

// class SpotifyLogin extends StatefulWidget {
//   @override
//   _SpotifyLoginState createState() => _SpotifyLoginState();
// }

// class _SpotifyLoginState extends State<SpotifyLogin> {
//   List<PlaylistSimple>? _playlists;
//   SpotifyApi? spotifyApi;
//   AudioPlayer audioPlayer = AudioPlayer();

//   @override
//   void initState() {
//     super.initState();
//     _initializeSpotify();
//   }

//   Future<void> _initializeSpotify() async {
//     final accessTokenResult = await SpotifyAuth.getAccessToken();
//     if (accessTokenResult != null && accessTokenResult['access_token'] != null) {
//       spotifyApi = SpotifyApi(SpotifyApiCredentials('', '', accessToken: accessTokenResult['access_token'] as String));
//       _fetchFeaturedPlaylists();
//     } else {
//       print("Failed to log in");
//     }
//   }

//   Future<void> _fetchFeaturedPlaylists() async {
//     if (spotifyApi == null) return;
//     final playlists = await spotifyApi!.playlists.featured.all();  // Assume this is the correct method
//     setState(() {
//       _playlists = playlists.toList();  // Adjust based on actual method return type
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Spotify Playlist Fetcher'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 if (spotifyApi != null) _fetchFeaturedPlaylists();
//               },
//               child: Text('Fetch Featured Playlists'),
//             ),
//             Expanded(
//               child: _playlists == null
//                   ? CircularProgressIndicator()
//                   : ListView.builder(
//                       itemCount: _playlists!.length,
//                       itemBuilder: (context, index) {
//                         var playlist = _playlists![index];
//                         return ListTile(
//                           title: Text(playlist.name ?? 'No Name'),
//                           onTap: () async {
//                             // Ensure you fetch detailed playlist info if needed here
//                           },
//                         );
//                       },
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }






















// // import 'package:flutter/material.dart';
// // import 'package:spotify/spotify.dart';
// // import '/pages/spotify/callingAccessToken.dart';
// // import '/pages/spotify/musicplayer.dart';

// // void main() => runApp(MyApp());

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: SpotifyLogin(),
// //     );
// //   }
// // }

// // class SpotifyLogin extends StatefulWidget {
// //   @override
// //   _SpotifyLoginState createState() => _SpotifyLoginState();
// // }

// // class _SpotifyLoginState extends State<SpotifyLogin> {
// //   List<PlaylistSimple>? _playlists;

// // Future<void> _loginAndFetchPlaylists() async {
// //   final accessTokenResult = await SpotifyAuth.getAccessToken();
// //   if (accessTokenResult != null && accessTokenResult['access_token'] != null) {
// //     final spotifyApi = SpotifyApi(SpotifyApiCredentials('', '',
// //         accessToken: accessTokenResult['access_token'] as String));

// //     // Here, playlistsFuture is a Future that resolves to an Iterable<PlaylistSimple>
// //     final Iterable<PlaylistSimple> playlists = await spotifyApi.playlists.me.all();

// //     // If you specifically need a List<PlaylistSimple> instead of any Iterable, convert it here
// //     final List<PlaylistSimple> playlistsList = playlists.toList();

// //     setState(() {
// //       _playlists = playlistsList;
// //     });
// //   } else {
// //     // Handle login error
// //     print("Failed to log in");
// //   }
// // }


// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Spotify Playlist Fetcher'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             ElevatedButton(
// //               onPressed: _loginAndFetchPlaylists,
// //               child: Text('Login to Spotify and Fetch Playlists'),
// //             ),
// //             Expanded(
// //               child: _playlists == null
// //                   ? CircularProgressIndicator()
// //                   : ListView.builder(
// //                       itemCount: _playlists!.length,
// //                       itemBuilder: (context, index) => ListTile(
// //                         title: Text(_playlists![index].name ?? ''),
// //                       ),
// //                     ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
