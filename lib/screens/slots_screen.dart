import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:parking_management/screens/components/payment_dialog.dart';
import 'package:parking_management/screens/components/slot.dart';
import 'package:parking_management/screens/components/slot_grid.dart';

// Ensure this import matches your file structure
class SlotScreen extends StatefulWidget {
  final Map<dynamic, dynamic> zone;
  const SlotScreen({super.key, required this.zone});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  int _currentIndex = 0;
  int _selectedIndex = -1;
  String? _dropdownValue;
  int _floorIndex = 0;
  String _selectedGroup = "";
  final List<String> _selectedSlots = [];

  @override
  void initState() {
    super.initState();
    print(
        "SlotScreen loaded with: ${widget.zone['parking_floors'].length} floors");
    if (widget.zone['parking_floors'] != null &&
        widget.zone['parking_floors'].isNotEmpty &&
        widget.zone['parking_floors'][_floorIndex] != null &&
        widget.zone['parking_floors'][_floorIndex]['parking_slot_groups'] !=
            null &&
        widget.zone['parking_floors'][_floorIndex]['parking_slot_groups']
            .isNotEmpty) {
      setState(() {
        _dropdownValue = widget.zone['parking_floors'][_floorIndex]
                ['parking_slot_groups'][0]['id']
            .toString();
      });
    } else {
      // Fallback if no groups exist
      setState(() {
        _dropdownValue = null;
      });
    }
  }

  void _cancelPayment(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _handleSlotClicked(String index, int slot_index) {
    setState(() {
      _selectedIndex = slot_index;
      _selectedGroup = index.toString();
      String slot = r'floor-' +
          _floorIndex.toString() +
          r'-group' +
          _selectedGroup +
          r'-index-' +
          slot_index.toString();
      if (_selectedSlots.contains(slot)) {
        _selectedSlots.remove(slot);
      } else {
        _selectedSlots.clear();
        _selectedSlots.add(slot);
      }
      print(_selectedSlots.toString());
    });
  }

  void _handleFloorClicked(int index) {
    setState(() {
      _selectedSlots.clear();
      _floorIndex = index;
      _selectedGroup = "";
      _selectedIndex = -1;
      print(_selectedSlots.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "slot selection",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "history"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "contact"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "settings")
        ],
      ),*/
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Stack(
            children: [
              Positioned.fill(
                  child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Changed to start
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                height: 60,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 218, 227, 243),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                width: 240,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        GridView.count(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          crossAxisCount: 1,
                                          children: List.generate(
                                              widget.zone['parking_floors']
                                                  .length, (index) {
                                            return InkWell(
                                                onTap: () {
                                                  _handleFloorClicked(index);
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color:
                                                            _floorIndex == index
                                                                ? const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    252,
                                                                    252,
                                                                    253)
                                                                : null),
                                                    child: Text(
                                                      r'floor ' +
                                                          widget.zone[
                                                                  'parking_floors']
                                                                  [index][
                                                                  'floor_number']
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 10),
                                                    )));
                                          }),
                                        )
                                      ],
                                    ))),
                            SizedBox(
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: const Color.fromARGB(
                                          255, 218, 227, 243)),
                                  child: DropdownButton<String>(
                                    underline: Container(
                                      height: 1,
                                      width: 0.1,
                                      color: Colors.transparent,
                                    ),
                                    items: (widget.zone['parking_floors'] !=
                                                null &&
                                            widget.zone['parking_floors']
                                                .isNotEmpty &&
                                            widget.zone['parking_floors']
                                                    [_floorIndex] !=
                                                null &&
                                            widget.zone['parking_floors']
                                                        [_floorIndex]
                                                    ['parking_slot_groups'] !=
                                                null &&
                                            widget
                                                .zone['parking_floors']
                                                    [_floorIndex]
                                                    ['parking_slot_groups']
                                                .isNotEmpty)
                                        ? widget.zone['parking_floors']
                                                [_floorIndex]
                                                ['parking_slot_groups']
                                            .map<DropdownMenuItem<String>>(
                                                (group) {
                                            return DropdownMenuItem<String>(
                                              value: group['id']
                                                  .toString(), // Convert id to String since your dropdown is String-based
                                              child: Text(group['name']),
                                            );
                                          }).toList()
                                        : [],
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _dropdownValue = newValue;
                                      });
                                    },
                                    value: _dropdownValue,
                                  )),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GridView.count(
                      crossAxisCount: 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                          widget.zone['parking_floors'].length, (index) {
                        return Column(
                          children: [
                            SlotGrid(
                                key: ValueKey(index),
                                groupIndex: index.toString(),
                                groupSelected:
                                    index.toString() == _selectedGroup,
                                onSlotPressed: (slot_index) =>
                                    _handleSlotClicked(
                                        index.toString(), slot_index)),
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                              height: 2,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              )),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedSlots.isNotEmpty
                        ? const Color.fromRGBO(66, 122, 154, 1)
                        : Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_selectedSlots.isNotEmpty) {
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.noHeader,
                          body: MediaQuery.removePadding(
                            context: context,
                            removeTop: true,
                            removeBottom: true,
                            removeLeft: true,
                            removeRight: true,
                            child: SingleChildScrollView(
                                child: PaymentDialog(
                              onCancel: () => _cancelPayment(context),
                            )),
                          )).show();
                    }
                  },
                  child: const Text("book"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
