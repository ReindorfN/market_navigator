import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 1; // Updated to match two pages
              });
            },
            children: [
              OnboardingPage(
                image: 'lib/images/pexels-olly-972804.jpg',
                title: 'No more going to the store!',
                description: 'Own the desired product in seconds by viewing it from the app!',
              ),
              OnboardingPage(
                image: 'assets/image2.png',
                title: 'The abundance of variety will make you happy!',
                description: 'We have both a lot of variety and a lot of brands!',
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Two Rows of Page Indicators
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    SizedBox(height: 8),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 2,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Colors.purple,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  ),
                  onPressed: () {
                    if (isLastPage) {
                      // Navigate to home or main app
                    } else {
                      _controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                    }
                  },
                  child: Text('Next', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  OnboardingPage({required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Image.asset(image, fit: BoxFit.cover),
        ),
        Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(description, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
