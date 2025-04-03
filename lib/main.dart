import 'package:flutter/material.dart';
import 'package:market_navigator/Screens/products_page.dart';
import 'Screens/settings.dart';
import 'screens/home_screen.dart';
import 'Screens/profile.dart';
import 'Screens/landing.dart';
import 'Screens/notifications.dart';
import 'Screens/seller_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      home: OnboardingScreen(),
    );
  }
}

@override
Widget build(BuildContext context) => MaterialApp(
      title: "Page 1",
      initialRoute: '/',
      routes: {
        '/': (context) {
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.pushReplacementNamed(context, '/home');
          });
          return OnboardingScreen();
        },
        '/home': (context) => const HomeScreen(),
      },
    );

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        )),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_outline),
              title: const Text("Favourites"),
              onTap: () {},
            ),
            const Divider(
              color: Colors.lightBlue,
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text("Admin Dashboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SellerDashboard()),
                );
              },
            )
          ],
        ),
      );
}
