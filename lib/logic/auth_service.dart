import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId:
        '545598523712-h4tkb95csbh4cms0vf4cs7biqnopp67r.apps.googleusercontent.com',
  );

  Future<void> handleGoogleAuth({required bool isLogin}) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      final url = 'http://localhost:8000/api/v1/auth/social/login/';
      final response = await http.post(Uri.parse(url),
          headers: {'Content-type': 'application/json'},
          body: json.encode({
            'provider': 'google',
            'id_token': idToken,
          }));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final jwt = data['access_token'];
        print("✅ Auth successful. JWT stored.${jwt}");
      } else {
        print("Auth failed: ${response.body}");
      }
    } catch (e) {
      print("Google Auth error new: $e");
    }
  }
}
