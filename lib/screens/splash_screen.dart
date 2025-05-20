import 'package:flutter/material.dart';
import 'package:parking_management/screens/location_permission_screen.dart';
import 'package:parking_management/screens/login_screen.dart';
import 'package:parking_management/screens/zone_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleStartupLogic();
  }

  Future<void> _handleStartupLogic() async {
    await Future.delayed(Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    bool _isLoggedIn = prefs.getBool("is_logged_in") ?? false;

    if (!_isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
      return;
    }

    PermissionStatus locationStatus = await Permission.location.status;
    if (!locationStatus.isGranted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LocationPermissionScreen()));
    }
    else{
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ZoneDetails()));

    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
