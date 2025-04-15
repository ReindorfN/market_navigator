// For settings.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart' as main_component;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_navigator/screens/signup_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadNotificationPreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
    main_component.themeNotifier.value =
        isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => isDarkMode = value);
    await prefs.setBool('isDarkMode', value);
    main_component.themeNotifier.value =
        value ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => notificationsEnabled = value);
    await prefs.setBool('notificationsEnabled', value);

    if (value) {
      main_component.requestNotificationPermissions();
    } else {
      // This will only disable notifications while app is running
      AwesomeNotifications().setGlobalBadgeCounter(0);
    }
  }

  // Test notification function
  void _testNotification() {
    main_component.showLocalNotification();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Test notification sent!')),
    );
  }

  Future<void> _changePassword() async {
    final user = _auth.currentUser;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      await user?.updatePassword(_passwordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final user = _auth.currentUser;
    final userId = user?.uid;

    try {
      // Delete user data from Firestore
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .delete();
      }

      // Delete Firebase Auth account
      await user?.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );

      // Redirect to login page after sign out
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SignupScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Firestore Error: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const main_component.NavigationDrawer(),
      body: ListView(
        children: [
          _buildSectionTitle("Account & Security"),
          _buildListTile(Icons.lock, "Change Password", "", () {
            _showChangePasswordDialog();
          }),
          _buildListTile(Icons.delete, "Delete Account", "", () {
            _showDeleteAccountDialog();
          }),
          const Divider(thickness: 1.5, color: Colors.grey),
          _buildSectionTitle("App Preferences"),
          _buildToggleTile(Icons.dark_mode, "Dark Mode",
              "Light, Dark, System Default", isDarkMode, _toggleDarkMode),
          const Divider(thickness: 1.5, color: Colors.grey),
          _buildSectionTitle("Notifications & Alerts"),
          _buildToggleTile(Icons.notifications, "Push Notifications",
              "On/Off Toggle", notificationsEnabled, _toggleNotifications),
          _buildListTile(Icons.notification_add, "Test Notification",
              "Send a test notification", () {
            _testNotification();
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildListTile(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      subtitle: subtitle.isNotEmpty
          ? Text(subtitle, style: TextStyle(color: Colors.grey))
          : null,
      onTap: onTap,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  Widget _buildToggleTile(IconData icon, String title, String subtitle,
      bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.blueGrey),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey)),
      value: value,
      onChanged: onChanged,
    );
  }

  // Show Change Password Dialog
  void _showChangePasswordDialog() {
    // Key change: Move these variables inside the dialog function so they work properly in the StatefulBuilder
    bool isPasswordVisible = false;
    bool isConfirmPasswordVisible = false;

    showDialog(
      context: context,
      builder: (context) {
        // Use StatefulBuilder to manage state within the dialog
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _passwordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        // Update state within the dialog
                        setDialogState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        // Update state within the dialog
                        setDialogState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  _changePassword();
                  Navigator.pop(context);
                },
                child: const Text('Change'),
              ),
            ],
          );
        });
      },
    );
  }

  // Show Delete Account Dialog
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red background
                foregroundColor: Colors.white, // White text
              ),
              onPressed: () {
                Navigator.pop(context);
                _deleteAccount(); // Call the existing method directly
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
