import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: controller,
          children: [
            Container(
              color: Colors.amber,
              child: Center(
                child: Center(
                  child: Column(
                    children: [
                      Text('page1'),
                      SmoothPageIndicator(
                        controller: controller,
                        count: 3,
                        effect: const WormEffect(
                            spacing: 16,
                            dotColor: Colors.white,
                            activeDotColor: Colors.blue,
                            ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey,
              child: Center(
                child: Column(
                  children: [
                    Text('page2'),
                    SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                          spacing: 16,
                          dotColor: Colors.white,
                          activeDotColor: Colors.blue),
                    )
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey,
              child: Center(
                child: Column(
                  children: [
                    Text('page3'),
                    SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                          spacing: 16,
                          dotColor: Colors.white,
                          activeDotColor: Colors.blue),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
