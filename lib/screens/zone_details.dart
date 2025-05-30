import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:http/http.dart' as http;
import 'package:parking_management/logic/end_points.dart';
import 'package:parking_management/screens/bookmarks_screen.dart';
import 'package:parking_management/screens/components/favorites_card.dart';
import 'package:parking_management/screens/favorites_screen.dart';
import 'package:parking_management/screens/forgot_password.dart';
import 'package:parking_management/screens/profile_screen.dart';
import 'package:parking_management/screens/slots_screen.dart';
import 'dart:convert';
import 'register_screen.dart';
import 'package:infinite_carousel/infinite_carousel.dart';

class ZoneDetails extends StatefulWidget {
  final String slotAvailable = "30";
  final String address; // = "somewhere";
  final String timeDistance; // = "30 minutes";
  final String distance; // = "2km";
  final String name; // = "some name";
  final Map<dynamic, dynamic> zone;

  ZoneDetails(
      {super.key,
      required this.address,
      required this.timeDistance,
      required this.distance,
      required this.name,
      required this.zone});

  //const ZoneDetails({super.key});

  @override
  State<ZoneDetails> createState() => _ZoneDetailsState();
}

class _ZoneDetailsState extends State<ZoneDetails> {
  List<Widget> _pages = [];
  final List<dynamic> _parkingZones = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = "";

  int _currentIndex = 0;
  final _carouselController = InfiniteScrollController(initialItem: 0);

  final List<String> images = [
    'https://images.pexels.com/photos/34950/pexels-photo.jpg',
    'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg',
  ];
  @override
  void initState() {
    super.initState();
    print(r"zone at zone details " + widget.zone.toString());
    _pages.add(const Text("Hello"));
    _pages.add(const FavoritesScreen());
    _pages.add(const ProfileScreen());
    _pages.add(const ProfileScreen());
    _pages.add(const BookmarkScreen(bookmarks: [],));

    /*setState(() {
      images.clear();
    for (var item in widget.zone["parking_zone_pictures"]) {
      images.add(item["image"]);
    }
    });*/
    
    //images.addAll(widget.zone['parking_zone_pctures'].toList());
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
            : _hasError
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_errorMessage, textAlign: TextAlign.center),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _hasError = false;
                              });
                            },
                            child: const Text('Retry'),
                          )
                        ],
                      ),
                    ),
                  )
                : _currentIndex == 0
                    ? Stack(children: [
                        SafeArea(
                            child: SingleChildScrollView(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Slightly curved borders
                                ),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: SizedBox(
                                    width: double.infinity,
                                    height: 200,
                                    child: InfiniteCarousel.builder(
                                      itemCount: images.length,
                                      itemExtent:
                                          MediaQuery.of(context).size.width *
                                              0.9,
                                      loop: true,
                                      center: true,
                                      controller: _carouselController,
                                      itemBuilder: (context, index, realIndex) {
                                        return ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                20), // Set your desired roundness
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  2, 0, 2, 0),
                                              child: Image.network(
                                                  images[index],
                                                  fit: BoxFit.cover),
                                            ));
                                      },
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromARGB(
                                        255, 230, 238, 247),
                                  ),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(children: [
                                    Card(
                                        elevation: 2,
                                        child: Container(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(widget.zone['name']),
                                              Text(widget.zone['address']),
                                              Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        250, 0, 0, 0),
                                                child: const Text("20 Br."),
                                              )
                                            ],
                                          ),
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Card(
                                            elevation: 2,
                                            child: Container(
                                                width: 100.0,
                                                height: 80.0,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.time_to_leave),
                                                      Text(
                                                        "30 available slot",
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      )
                                                    ]))),
                                        Card(
                                            elevation: 2,
                                            child: Container(
                                                height: 80.0,
                                                width: 100.0,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(Icons
                                                          .timelapse_rounded),
                                                      Text(
                                                        (widget.zone['distance'] /
                                                                    60)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            r'min',
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      )
                                                    ]))),
                                        Card(
                                            elevation: 2,
                                            child: Container(
                                                height: 80.0,
                                                width: 100.0,
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 0, 0),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Icon(
                                                          Icons.timelapse),
                                                      Text(
                                                        ((widget.zone['distance'] /
                                                                    1000)
                                                                .toStringAsFixed(
                                                                    2) +
                                                            r" km"),
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      )
                                                    ])))
                                      ],
                                    )
                                  ])),
                              const Text('Facilities'),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                      elevation: 2,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 3, 30, 3),
                                          child: Text("wifi"))),
                                  Card(
                                      elevation: 2,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 3, 30, 3),
                                          child: Text("cctv"))),
                                  Card(
                                      elevation: 2,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 3, 30, 3),
                                          child: Text("charger"))),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                      elevation: 2,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 3, 30, 3),
                                          child: Text("wifi"))),
                                  Card(
                                      elevation: 2,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 3, 30, 3),
                                          child: Text("cctv"))),
                                  Card(
                                      elevation: 2,
                                      child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 3, 30, 3),
                                          child: Text("charger"))),
                                ],
                              ),
                              const SizedBox(height: 50),
                            ],
                          ),
                        )),
                        Positioned(
                          bottom: 5.0,
                          right: MediaQuery.of(context).size.width * 0.15,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(66, 122, 154, 1),
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                print(_parkingZones.toString());
                                if (widget.zone.isEmpty) {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    title: "No Parking Zones",
                                    desc:
                                        "No parking zones found. Try again later.",
                                    btnOkOnPress: () {},
                                  ).show();
                                  return;
                                }
                                print(r"data sent to slotscreen " +
                                    widget.zone.toString());
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return SlotScreen(zone: widget.zone);
                                }));
                              },
                              child: const Text("select slot")),
                        )
                      ])
                    : _pages[_currentIndex]);
  }
}
