import 'package:flutter/material.dart';
import 'package:parking_management/screens/components/cancelled_card.dart';
import 'package:parking_management/screens/components/completed_card.dart';
import 'package:parking_management/screens/components/favorites_card.dart';
import 'package:parking_management/screens/components/ongoing_card.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  int selectedTab = 0;

  final List<String> tabTitles = ['Ongoing', 'Completed', 'Cancelled'];
  final List<Widget> tabContents = [
    Center(
        child: ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const OngoingCard(),
    )),
    Center(
        child: ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const CompletedCard(),
    )),
    Center(
        child: ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const CancelledCard(),
    )),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Elliptical tab bar
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 235, 240, 247),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(tabTitles.length, (index) {
                  bool isSelected = selectedTab == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color.fromRGBO(59, 110, 143, 1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        tabTitles[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Content area
            Expanded(child: tabContents[selectedTab])
          ],
        ),
      ),
    );
  }
}
