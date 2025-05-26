import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parking_management/screens/map_screen.dart';
import 'package:parking_management/screens/zone_details.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionScreen extends StatefulWidget {
  const LocationPermissionScreen({super.key});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  Future<void> requestPermission(BuildContext context) async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MapScreen()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  exit(1);
                },
                child: const Icon(
                  Icons.cancel,
                  color: Color.fromRGBO(59, 110, 143, 1),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Card(
                      elevation: 1,
                      child: Image.asset(
                        "assets/images/location.jpg",
                      )),
                )),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(59, 110, 143, 1),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      minimumSize: const Size(double.infinity, 50)),
                  onPressed: () {
                    requestPermission(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "location",
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.map_sharp,
                        color: Colors.white,
                      )
                    ],
                  )),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: const Text(
                  "VPMS WILL ACCESS YOUR LOCATION \n     ONLY WHILE USING THE APP",
                  style: TextStyle(color: Colors.grey),
                )),
          ],
        ),
      ),
    );
  }
}
