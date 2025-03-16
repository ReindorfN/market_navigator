import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        children: const [
          OnboardingPage(
            imagePath: 'assets/image1.png',
            title: "No more going to the store!",
            description:
                "Own the desired product in seconds by viewing it from the app!",
          ),
          OnboardingPage(
            imagePath: 'assets/image2.png',
            title: "The abundance of variety will make you happy!",
            description:
                "We have both a lot of variety and a lot of brands!",
          ),
          OnboardingPage(
            imagePath: 'assets/image3.png',
            title: "Fast and secure payments!",
            description:
                "Your payments are processed with top-notch security measures.",
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 300), // Ensure images are in assets folder
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (title == "Fast and secure payments!") {
                Navigator.pushReplacementNamed(context, '/home');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
