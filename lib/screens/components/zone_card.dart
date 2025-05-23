import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ZoneCard extends StatefulWidget {
  const ZoneCard({super.key});

  @override
  State<ZoneCard> createState() => _ZoneCardState();
}

class _ZoneCardState extends State<ZoneCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                const Text("Megenagna",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text("city mall infront of zefmesh",
                      style: TextStyle(color: Colors.grey, fontSize: 10)),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(1),
                        child: Column(
                          children: [
                            Icon(Icons.car_rental_outlined,
                                color: Color.fromRGBO(59, 110, 143, 1)),
                            Text(
                              "30 available",
                              style: const TextStyle(
                                  color: Color.fromRGBO(59, 110, 143, 1)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(1),
                        child: Column(
                          children: [
                            Icon(Icons.lock_clock_outlined,
                                color: Color.fromRGBO(59, 110, 143, 1)),
                            Text(
                              "4 min",
                              style: const TextStyle(
                                  color: Color.fromRGBO(59, 110, 143, 1)),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(1),
                        child: Column(
                          children: [
                            Icon(
                              Icons.directions,
                              color: Color.fromRGBO(59, 110, 143, 1),
                            ),
                            Text(
                              "2 km",
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
    );
  }
}
