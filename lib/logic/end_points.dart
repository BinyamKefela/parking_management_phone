import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String backend_url = dotenv.env['backend_url']!.toString();

Future<Response> getParkingZones() async {
  final sp = await SharedPreferences.getInstance();

  String access = sp.getString("access_token") ?? "";

  return http.get(Uri.parse(backend_url + r"/api/get_parking_zones"), headers: {
    'Authorization': 'Bearer $access',
  }).timeout(const Duration(seconds: 10));
}
