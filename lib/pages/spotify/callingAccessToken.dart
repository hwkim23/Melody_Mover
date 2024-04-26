import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;

// Assuming CLIENT_ID and CLIENT_SECRET are defined
// Ensure CLIENT_SECRET is handled securely and consider moving it to a backend in production

class SpotifyAuth {
  static const String clientId = 'd73794ac45a944ba8702d084ce52280c';
  static const String clientSecret = 'da49d565cbbf48f597dc8fd5f6984303'; // Handle securely
  static const String redirectUri = 'my.music.app://callback';
  static const List<String> scopes = [
    'user-read-private',
    'user-read-playback-state',
    'user-modify-playback-state',
    'user-read-currently-playing',
    'user-read-email'
  ];

  static Future<Map<String, dynamic>?> getAccessToken() async {
    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'scope': scopes.join(' '),
      'redirect_uri': redirectUri,
      'show_dialog': 'true',
    });

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: "my.music.app"
    );

    final code = Uri.parse(result).queryParameters['code'];

    if (code != null) {
      final response = await http.post(
        Uri.parse('https://accounts.spotify.com/api/token'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': redirectUri,
          'client_id': clientId,
          'client_secret': clientSecret, // Move to backend in production
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to retrieve access token');
      }
    }
    return null;
  }
}
