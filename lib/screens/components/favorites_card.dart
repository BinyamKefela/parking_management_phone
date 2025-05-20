import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FavoritesCard extends StatefulWidget {
  const FavoritesCard({super.key});

  @override
  State<FavoritesCard> createState() => _FavoritesCardState();
}

class _FavoritesCardState extends State<FavoritesCard> {
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
                  child: Text("Total slots",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius:
                            BorderRadius.circular(20), // Elliptical look
                      ),
                      child: Text(
                        "30 available",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius:
                            BorderRadius.circular(20), // Elliptical look
                      ),
                      child: Text(
                        "4 min",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius:
                            BorderRadius.circular(20), // Elliptical look
                      ),
                      child: Text(
                        "2.5 km",
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(170, 7, 0, 0),
                  child: Icon(
                    Icons.delete_sharp,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
