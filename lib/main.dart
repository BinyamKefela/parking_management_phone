import 'package:flutter/material.dart';
import 'package:parking_management/screens/components/slot.dart';
import 'package:parking_management/screens/location_permission_screen.dart';
import 'package:parking_management/screens/login_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parking_management/screens/map_screen.dart';
import 'package:parking_management/screens/profile_screen.dart';
import 'package:parking_management/screens/slots_screen.dart';
import 'package:parking_management/screens/splash_screen.dart';
import 'package:parking_management/screens/zone_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Parking management system',
        theme: ThemeData(
          primaryColor: const Color.fromRGBO(66, 122, 154, 1),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(66, 122, 154, 1),
              brightness: Brightness.light),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromRGBO(66, 122, 154, 1),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            iconTheme: IconThemeData(
              color: Colors.white, // White back arrow and icons
            ), // Force AppBar color
          ),
        ),
        home://MapScreen() 
        //const ProfileScreen()
            const SplashScreen()
        //const LocationPermissionScreen()
        //const ZoneDetails(),
        );
  }
}
