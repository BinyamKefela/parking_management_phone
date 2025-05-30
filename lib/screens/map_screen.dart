import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking_management/logic/end_points.dart';
import 'package:parking_management/screens/all_zones_screen.dart';
import 'package:parking_management/screens/bookmarks_screen.dart';
import 'package:parking_management/screens/components/zone_card.dart';
import 'package:parking_management/screens/favorites_screen.dart';
import 'package:parking_management/screens/profile_screen.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:parking_management/screens/zone_details.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _parkingNearYou = "Parking near you";
  late GoogleMapController _controller;
  final Location _location = Location();
  late LatLng _currentPosition;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Text("Hello"),
    const FavoritesScreen(),
    const ProfileScreen(),
    const ProfileScreen(),
    const BookmarkScreen(
      bookmarks: [],
    ),
  ];
  String? _distance;
  Timer? _timer;

  final List<dynamic> _predefinedLocations = [];
  final List<dynamic> _nearestLocations = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getLocation();
    await _getParkingZones();
    await _getTopThreeNearestZones();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      print('Polling for data...');
      await _getLocation();
      await _getParkingZones();
      await _getTopThreeNearestZones();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getLocation() async {
    if (!(await _location.serviceEnabled()) &&
        !(await _location.requestService())) return;

    final locationData = await _location.getLocation();
    setState(() {
      _currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  Future<void> _getParkingZones() async {
    try {
      final response = await getParkingZones();
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _predefinedLocations.clear();
          _predefinedLocations.addAll(responseData['data']);
        });
      }
    } catch (e) {
      debugPrint('Error fetching zones: $e');
    }
  }

  Future<String> _calculateDistance(double destLat, double destLng) async {
    final userLocation = await _location.getLocation();
    final distance = ll.Distance().as(
      ll.LengthUnit.Meter,
      ll.LatLng(userLocation.latitude!, userLocation.longitude!),
      ll.LatLng(destLat, destLng),
    );

    return distance < 1000
        ? 'Distance: ${distance.toStringAsFixed(0)} meters'
        : 'Distance: ${(distance / 1000).toStringAsFixed(2)} km';
  }

  Future<void> _getTopThreeNearestZones() async {
    final userLocation = await _location.getLocation();
    final userLatLng =
        ll.LatLng(userLocation.latitude!, userLocation.longitude!);
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
      _nearestLocations.addAll(zonesWithDistance.take(5));
      _predefinedLocations.clear();
      _predefinedLocations.addAll(zonesWithDistance);
      _isLoading = false;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onSearchChanged(String query) {
    final userLatLng =
        ll.LatLng(_currentPosition.latitude, _currentPosition.longitude);
    final distance = ll.Distance();

    if (query.trim().isEmpty) {
      // Recalculate the nearest zones if search is cleared
      _getTopThreeNearestZones();
      setState(() {
        _parkingNearYou = "Parking near you";
      });
      return;
    }

    setState(() {
      _parkingNearYou = "search results";
    });
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
                          Expanded(
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                  target: _currentPosition, zoom: 10),
                              onMapCreated: _onMapCreated,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              markers: _predefinedLocations.map((zone) {
                                final lat = double.parse(zone['latitude']);
                                final lng = double.parse(zone['longitude']);
                                return Marker(
                                  markerId: MarkerId(zone['id'].toString()),
                                  position: LatLng(lat, lng),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueAzure),
                                  onTap: () async {
                                    print(r"yeah man" + zone.toString());
                                    AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.noHeader,
                                        title: "Zone",
                                        desc: _distance,
                                        body: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: Column(
                                              children: [
                                                ZoneCard(
                                                    zone: zone,
                                                    address: zone['address']
                                                        .toString(),
                                                    timeDistance:
                                                        (zone['distance'] / 60)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            r'min',
                                                    distance:
                                                        ((zone['distance'] /
                                                                    1000)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            r" km"),
                                                    name: zone['name']
                                                        .toString()),
                                                Container(
                                                  width: 350,
                                                  child: Card(
                                                    elevation: 5,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                "zone name:    ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue),
                                                              ),
                                                              Text(zone['name'])
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                  "address:     ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue)),
                                                              Text(zone[
                                                                  'address'])
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              const Text(
                                                                  "distance:     ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue)),
                                                              Text((zone['distance'] /
                                                                          60)
                                                                      .toStringAsFixed(
                                                                          2) +
                                                                  r'min')
                                                            ],
                                                          ),
                                                          Container(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor: const Color
                                                                            .fromRGBO(
                                                                            59,
                                                                            110,
                                                                            143,
                                                                            1),
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context).push(MaterialPageRoute(
                                                                            builder: (builder) => ZoneDetails(
                                                                                zone: zone,
                                                                                address: zone['address'].toString(),
                                                                                timeDistance: (zone['distance'] / 60).toStringAsFixed(2) + r'min',
                                                                                distance: ((zone['distance'] / 1000).toStringAsFixed(2) + r" km"),
                                                                                name: zone['name'].toString())));
                                                                      },
                                                                      child: const Text(
                                                                          "book",
                                                                          style:
                                                                              TextStyle(color: Colors.white))))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )).show();
                                  },
                                );
                              }).toSet(),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_parkingNearYou,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (builder) => const AllZones()));
                                },
                                child: const Text("View all",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue)),
                              ),
                            ],
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _nearestLocations.length,
                              itemBuilder: (context, index) => ZoneCard(
                                  zone: _nearestLocations[index],
                                  address: _nearestLocations[index]['address']
                                      .toString(),
                                  timeDistance: (_nearestLocations[index]
                                                  ['distance'] /
                                              (40 * 60))
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
