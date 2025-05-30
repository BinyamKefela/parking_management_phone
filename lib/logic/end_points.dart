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
  }).timeout(const Duration(seconds: 20));
}


Future<Response> getBookings() async {
  final sp = await SharedPreferences.getInstance();

  String access = sp.getString("access_token") ?? "";

  return http.get(Uri.parse(backend_url + r"/api/get_bookings"), headers: {
    'Authorization': 'Bearer $access',
  }).timeout(const Duration(seconds: 20));
}


Future<Response> postBooking(int parking_slot,int vehicle,DateTime start_time,DateTime? end_time) async {
  final sp = await SharedPreferences.getInstance();
  String access = sp.getString("access_token") ?? "";

  return http.post(Uri.parse(backend_url + r"/api/post_booking"), headers: {
    "Authorization": 'Bearer $access'
  }, body: {
    'parking_slot': parking_slot,
    'vehicle':vehicle,
    'start_time':start_time,
    'end_time':end_time
  }).timeout(const Duration(seconds: 20));
}

Future<Response> calculatePrice(int zone_id,int vehicle_type_id,DateTime start_time,DateTime end_time)async{
  final sp = await SharedPreferences.getInstance();
  String access = sp.getString("access_token") ?? "";

  return http.post(Uri.parse(backend_url + r"/api/calculate_price"), headers: {
    "Authorization": 'Bearer $access'
  }, body: {
    'zone_id': zone_id,
    'vehicle_type_id':vehicle_type_id,
    'start':start_time,
    'end':end_time
  }).timeout(const Duration(seconds: 20));
}
