import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CancelledCard extends StatefulWidget {
  const CancelledCard({super.key});

  @override
  State<CancelledCard> createState() => _CancelledCardState();
}

class _CancelledCardState extends State<CancelledCard> {
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.pin_drop,
                        color: Color.fromRGBO(59, 110, 143, 1),
                      ),
                      Text("Megenangna")
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
