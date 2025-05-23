import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

String backend_url = dotenv.env['backend_url']!.toString();

//an API for sending a password reset code containing email to the user's email
Future<Response> sendPasswordResetEmailPhone(email) {
  return http.post(Uri.parse(backend_url + r"/api/send_password_reset_email"),
      body: {'email': email});
}

//an API for verifying the reset code
Future<Response> verifyResetCode(email, code) {
  return http.post(Uri.parse(backend_url + r"/api/verify_reset_code"),
      body: {"email": email, "code": code});
}

//an API for reseting the user's password
Future<Response> resetPasswordPhone(email, code) {
  return http.post(Uri.parse(backend_url + r"/api/reset_password_phone"),
      body: {"email": email});
}

//an API for registering a user
Future<Response> signUp(email, password) {
  return http.post(Uri.parse(backend_url + r"/api/sign_up"),
      body: {"email": email, "password": password});
}

void refreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  //final token = prefs.getString("access_token");
  final refresh = prefs.getString("refresh_token");
  final response = await http.post(
      Uri.parse(backend_url + r"/api/token/refresh"),
      body: {"refresh": refresh});
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    await prefs.setString("access_token", responseData["access"]);
    await prefs.setString("refresh_token", responseData["refresh"]);
  }
}

void getValidToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("access_token");
  //final refresh = prefs.getString("refresh_token");
  if (token == null) {
    return null;
  }
  if (JwtDecoder.isExpired(token)) {
    refreshToken();
  }
}
