import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parking_management/screens/zone_details.dart';

class ZoneCard extends StatefulWidget {
  final String slotAvailable = "30";
  final String address; // = "somewhere";
  final String timeDistance; // = "30 minutes";
  final String distance; // = "2km";
  final String name; // = "some name";

  const ZoneCard(
      {super.key,
      required this.address,
      required this.timeDistance,
      required this.distance,
      required this.name});

  @override
  State<ZoneCard> createState() => _ZoneCardState();
}

class _ZoneCardState extends State<ZoneCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (builder) => const ZoneDetails()));
      },
      child: Card(
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130,
              width: 140,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/image.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: 130,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(widget.address,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 10)),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(1),
                          child: Column(
                            children: [
                              const Icon(Icons.local_taxi_outlined,
                                  color: Color.fromRGBO(59, 110, 143, 1)),
                              Text(
                                widget.slotAvailable,
                                style: const TextStyle(
                                    color: Color.fromRGBO(59, 110, 143, 1)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(1),
                          child: Column(
                            children: [
                              const Icon(Icons.timelapse_rounded,
                                  color: Color.fromRGBO(59, 110, 143, 1)),
                              Text(
                                widget.timeDistance,
                                style: const TextStyle(
                                    color: Color.fromRGBO(59, 110, 143, 1)),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(1),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.directions,
                                color: Color.fromRGBO(59, 110, 143, 1),
                              ),
                              Text(
                                widget.distance,
                                style: const TextStyle(
                                    color: Color.fromRGBO(59, 110, 143, 1)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
