import 'package:flutter/material.dart';
import 'slot.dart';

class SlotGrid extends StatefulWidget {
  final void Function(int,int) onSlotPressed;
  final String groupIndex;
  final bool groupSelected;
  final Map<String, dynamic> floor;

  const SlotGrid(
      {super.key,
      required this.onSlotPressed,
      required this.groupIndex,
      required this.groupSelected,
      required this.floor});

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
  void initState() {
    // TODO: implement initState
    super.initState();
    print(r' and groupIndex - ' + widget.groupIndex);
    print('floor received in slot grid ' +
        widget.floor.toString() +
        r' and groupIndex - ' +
        widget.groupIndex);
    print(r' and groupIndex - ' + widget.groupIndex);
  }

  @override
  Widget build(BuildContext context) {
    try {
      final parkingSlotGroups =
          widget.floor['parking_slot_groups'] as List? ?? [];
      final matchingGroup = parkingSlotGroups.firstWhere(
        (group) => group['name'] == widget.groupIndex,
        orElse: () => null,
      );

      if (matchingGroup == null) {
        return Center(
            child: Text('Parking group ${widget.groupIndex} not found'));
      }

      final parkingSlots = matchingGroup['parking_slots'] as List;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(255, 218, 227, 243),
            ),
            child: Column(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  children: List.generate(parkingSlots.length, (index) {
                    return InkWell(
                      onTap: () {
                        _handleCardClick(index);
                        widget.onSlotPressed(index,parkingSlots[index]['id']);
                      },
                      child: Slot(
                        slot:parkingSlots[index],
                        index: index,
                        isSelected: _selectedIndex.contains(index) &&
                            widget.groupSelected,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      );
    } catch (e) {
      return Center(child: Text('Error loading slots: ${e.toString()}'));
    }
  }
}