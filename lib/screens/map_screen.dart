import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking_management/screens/bookmarks_screen.dart';
import 'package:parking_management/screens/components/zone_card.dart';
import 'package:parking_management/screens/favorites_screen.dart';
import 'package:parking_management/screens/profile_screen.dart';
import 'package:latlong2/latlong.dart' as ll;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Future<String> calculateDistance(double destLat, double destLng) async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return '';
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return '';
    }

    LocationData userLocation = await location.getLocation();

    double userLat = userLocation.latitude!;
    double userLng = userLocation.longitude!;

    final ll.Distance distance = ll.Distance();

    final double km = distance.as(
      ll.LengthUnit.Kilometer,
      ll.LatLng(userLat, userLng),
      ll.LatLng(destLat, destLng),
    );
    return ('Distance: ${km.toStringAsFixed(2)} km');

    //print('Distance: ${km.toStringAsFixed(2)} km');
  }

  late GoogleMapController _controller;
  Location location = Location();
  late LatLng _currentPosition;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  int _currentIndex = 0;
  List<Widget> _pages = [];

  final List<Map<String, dynamic>> _predefinedLocations = [
    {
      'name': 'Central Park',
      'location': const LatLng(40.7829, -73.9654),
    },
    {
      'name': 'Eiffel Tower',
      'location': const LatLng(48.8584, 2.2945),
    },
    {
      'name': 'Statue of Liberty',
      'location': const LatLng(40.6892, -74.0445),
    },
    // Add more predefined locations as needed
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
    _pages.add(const Text("Hello"));
    _pages.add(const FavoritesScreen());
    _pages.add(const ProfileScreen());
    _pages.add(const ProfileScreen());
    _pages.add(const BookmarkScreen());
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await location.getLocation();
    setState(() {
      _currentPosition =
          LatLng(locationData.latitude!, locationData.longitude!);
      _isLoading = false;
    });
  }

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: "favorites"),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: "history"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "contact"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark), label: "bookmark")
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _currentIndex == 0
                        ? Stack(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/user.jpg"))),
                                            height: 50,
                                            width: 50,
                                            //color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          "HELLO BINYAM",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          228, 234, 240, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.search,
                                            color: Color.fromRGBO(
                                                59, 110, 143, 1)),
                                        hintText: 'Search for zone',
                                        hintStyle: TextStyle(
                                            color: Color.fromRGBO(
                                                59, 110, 143, 1)),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      //margin: const EdgeInsets.fromLTRB(10, 50, 10, 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90)),
                                      height: 350,
                                      child: GoogleMap(
                                        initialCameraPosition: CameraPosition(
                                            target: _currentPosition, zoom: 15),
                                        myLocationEnabled: true,
                                        myLocationButtonEnabled: true,
                                        markers: {
                                          Marker(
                                              markerId: const MarkerId(
                                                  "currentLocation"),
                                              position: _currentPosition,
                                              icon: BitmapDescriptor
                                                  .defaultMarkerWithHue(
                                                      BitmapDescriptor
                                                          .hueAzure),
                                              onTap: () async {
                                                String? distance =
                                                    await calculateDistance(
                                                        _currentPosition
                                                            .latitude,
                                                        _currentPosition
                                                            .longitude);
                                                AwesomeDialog(
                                                        context: context,
                                                        dialogType:
                                                            DialogType.noHeader,
                                                        title: "Zone",
                                                        desc: distance)
                                                    .show();
                                              })
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.topLeft,
                                      padding: const EdgeInsets.all(5),
                                      child: const Text(
                                        "Parking near you",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  Expanded(
                                      child: ListView.builder(
                                    itemCount: 5,
                                    itemBuilder: (context, index) =>
                                        const ZoneCard(),
                                  )),
                                ],
                              ),
                              //Positioned(child: child)
                            ],
                          )
                        : _pages[_currentIndex]),
              ));
  }
}
