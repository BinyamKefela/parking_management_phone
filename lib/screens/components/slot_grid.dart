import 'package:flutter/material.dart';
import 'slot.dart';

class SlotGrid extends StatefulWidget {
  final void Function(int) onSlotPressed;
  final String groupIndex;
  final bool groupSelected;

  const SlotGrid(
      {super.key,
      required this.onSlotPressed,
      required this.groupIndex,
      required this.groupSelected});

  @override
  State<SlotGrid> createState() => _SlotGridState();
}

class _SlotGridState extends State<SlotGrid> {
  final List<int> _selectedIndex = [];

  void _handleCardClick(int index) {
    setState(() {
      if (_selectedIndex.contains(index)) {
        _selectedIndex.remove(index);
      } else {
        _selectedIndex.clear();
        _selectedIndex.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 218, 227, 243),
          ),
          child: Column(children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 1.0, //Added Aspect Ratio
              mainAxisSpacing: 1, //Add spacing if you want
              crossAxisSpacing: 1,
              children: List.generate(6, (index) {
                return InkWell(
                    onTap: () {
                      //print('Card clicked at index: $index');
                      _handleCardClick(index);
                      widget.onSlotPressed(index); // Call a function
                    },
                    child: Slot(
                      index: index,
                      isSelected: _selectedIndex.contains(index) &&
                          widget.groupSelected,
                    ));
              }),
            ),
          ]),
        ),
      ],
    );
  }
}
