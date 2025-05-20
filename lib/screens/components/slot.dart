import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Ensure this import matches your file structure
class Slot extends StatefulWidget {
  const Slot({super.key, this.index = 0, this.isSelected = false});
  final int index;
  final bool isSelected;

  @override
  State<Slot> createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200, // Removed fixed height, let the card define it
      //width: 100,
      padding: EdgeInsets.zero,
      child: Card(
        color: widget.isSelected ? const Color.fromRGBO(66, 122, 154, 1) : null,
        elevation: 2.0,
        child: Padding(
          //Added padding
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, //Added mainAxisAlignment
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.topRight,
                margin: const EdgeInsets.fromLTRB(0, 7, 5, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.green),
                height: 10,
                width: 10,
                // margin: EdgeInsets.fromLTRB(  //Removed this margin
                //     MediaQuery.of(context).size.width * 0.15, 10, 0, 0), //Reduced margin so icon is more centered
              ),
              Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  alignment: Alignment.topCenter,
                  child: Text("A-01",
                      style: TextStyle(
                          fontSize: 10,
                          color: widget.isSelected
                              ? Colors.white
                              : Colors.black))),
              const SizedBox(
                height: 5,
              ),
              Center(
                child: Container(
                    height: 15,
                    width: 15,
                    child: Image.asset(
                        "assets/images/image.jpg")), //SvgPicture.asset(
                //"assets/images/booked_slot.svg",
              ),
              Container(
                // margin: const EdgeInsets.fromLTRB(0, 5, 0, 0), //removed left margin
                child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 7, 10, 0),
                    alignment: Alignment.bottomRight,
                    child: Text("6x2",
                        style: TextStyle(
                            fontSize: 10,
                            color: widget.isSelected
                                ? Colors.white
                                : Colors.black))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
