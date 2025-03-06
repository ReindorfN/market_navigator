import 'package:flutter/material.dart';
import '../main.dart' as main_component; // Import NavigationDrawer

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          backgroundColor: Colors.blueAccent,
        ),
        drawer:
            const main_component.NavigationDrawer(), // Drawer from main.dart
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// Profile Picture
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://example.com/profile.jpg"), // Load from the web
                    backgroundColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                /// User Information
                const Text(
                  "John Doe",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "johndoe@example.com",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
}
