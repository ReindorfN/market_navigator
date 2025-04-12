import 'package:flutter/material.dart';
// import 'package:market_navigator/Screens/home_screen.dart';
// import 'package:market_navigator/Screens/login.dart';
import 'package:market_navigator/Screens/signup_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    // Using explicit brightness and colors to prevent dark mode influence
    return Theme(
      // Force light theme regardless of system settings
      data: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      child: Scaffold(
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
                  image: 'assets/images/image1.png',
                  title: 'No more going to the store!',
                  description:
                      'Own the desired product in seconds by viewing it from the app!',
                ),
                OnboardingPage(
                  image: 'assets/images/image2.png',
                  title: 'The abundance of variety will make you happy!',
                  description:
                      'We have both a lot of variety and a lot of brands!',
                )
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
                          dotColor: Colors
                              .grey.shade300, // Explicitly setting dot color
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
                      foregroundColor:
                          Colors.white, // Explicitly setting text color
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                      );
                    },
                    child: Text('Signup',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Widget? buttons;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    this.buttons,
  });

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
              color: Colors.white, // Explicitly white background
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Explicitly black text
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600], // Explicitly grey text
                  ),
                ),
                if (buttons != null) ...[
                  SizedBox(height: 20),
                  buttons!,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
