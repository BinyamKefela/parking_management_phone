import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking_management/logic/end_points.dart';
import 'package:parking_management/screens/bookmarks_screen.dart';
import 'package:parking_management/screens/components/zone_card.dart';
import 'package:parking_management/screens/favorites_screen.dart';
import 'package:parking_management/screens/profile_screen.dart';
import 'package:latlong2/latlong.dart' as ll;

class AllZones extends StatefulWidget {
  const AllZones({super.key});

  @override
  State<AllZones> createState() => _AllZonesState();
}

class _AllZonesState extends State<AllZones> {
  final Location _location = Location();
  late ll.LatLng _currentPosition;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Text("Hello"),
    const FavoritesScreen(),
    const ProfileScreen(),
    const ProfileScreen(),
    const BookmarkScreen(),
  ];

  final List<dynamic> _predefinedLocations = [];
  final List<dynamic> _nearestLocations = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    //await _getLocation();
    await _getParkingZones();
    _getAllZones();
  }

  Future<void> _getParkingZones() async {
    try {
      final response = await getParkingZones();
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _predefinedLocations.addAll(responseData['data']);
        });
      }
    } catch (e) {
      debugPrint('Error fetching zones: $e');
    }
  }

  void _getAllZones() async {
    final userLocation = await _location.getLocation();
    final userLatLng =
        ll.LatLng(userLocation.latitude!, userLocation.longitude!);
    setState(() {
      _currentPosition = ll.LatLng(userLocation.latitude!, userLocation.longitude!);
    });
    final distance = ll.Distance();

    final zonesWithDistance = _predefinedLocations.map((zone) {
      final zoneLatLng = ll.LatLng(
        double.parse(zone['latitude']),
        double.parse(zone['longitude']),
      );
      return {
        ...zone,
        'distance': distance.as(ll.LengthUnit.Meter, userLatLng, zoneLatLng),
      };
    }).toList()
      ..sort((a, b) => a['distance'].compareTo(b['distance']));

    setState(() {
      _nearestLocations.clear();
      _nearestLocations.addAll(zonesWithDistance);
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    final userLatLng =
        ll.LatLng(_currentPosition.latitude, _currentPosition.longitude);
    final distance = ll.Distance();

    if (query.trim().isEmpty) {
      // Recalculate the nearest zones if search is cleared
      _getAllZones();

      return;
    }

    final filtered = _predefinedLocations.where((zone) {
      final name = zone['name']?.toString().toLowerCase() ?? '';
      final address = zone['address']?.toString().toLowerCase() ?? '';
      return name.contains(query.toLowerCase()) ||
          address.contains(query.toLowerCase());
    }).map((zone) {
      final zoneLatLng = ll.LatLng(
        double.parse(zone['latitude']),
        double.parse(zone['longitude']),
      );
      return {
        ...zone,
        'distance': distance.as(ll.LengthUnit.Meter, userLatLng, zoneLatLng),
      };
    }).toList()
      ..sort((a, b) => a['distance'].compareTo(b['distance']));

    setState(() {
      _nearestLocations.clear();
      _nearestLocations.addAll(filtered.take(5));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Contact"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: "Bookmark"),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _currentIndex == 0
                    ? Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset("assets/images/user.jpg",
                                    height: 50, width: 50),
                              ),
                              const SizedBox(width: 10),
                              const Text("HELLO BINYAM",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                            child: const Text("LETS FND A SPOT FOR YOU!",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(228, 234, 240, 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                icon: Icon(Icons.search,
                                    color: Color.fromRGBO(59, 110, 143, 1)),
                                hintText: 'Search for zone',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _nearestLocations.length,
                              itemBuilder: (context, index) => ZoneCard(
                                  address: _nearestLocations[index]['address']
                                      .toString(),
                                  timeDistance: (_nearestLocations[index]
                                                  ['distance'] /
                                              60)
                                          .toStringAsFixed(2) +
                                      r'min',
                                  distance: ((_nearestLocations[index]
                                                  ['distance'] /
                                              1000)
                                          .toStringAsFixed(2) +
                                      r" km"),
                                  name: _nearestLocations[index]['name']
                                      .toString()),
                            ),
                          ),
                        ],
                      )
                    : _pages[_currentIndex],
              ),
            ),
    );
  }
}
