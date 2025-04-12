import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart' as main_component;

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

  bool _isPasswordVisible = false; // Toggle for password visibility
  bool _isConfirmPasswordVisible =
      false; // Toggle for confirm password visibility

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
    main_component.themeNotifier.value =
        isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => isDarkMode = value);
    await prefs.setBool('isDarkMode', value);
    main_component.themeNotifier.value =
        value ? ThemeMode.dark : ThemeMode.light;
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

    try {
      await user?.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account deleted successfully')),
      );
      // Redirect to login page or sign out
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
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
          _buildListTile(Icons.security, "Two-Factor Authentication (2FA)",
              "If supported", () {}),
          _buildListTile(Icons.delete, "Delete Account", "", () {
            _showDeleteAccountDialog();
          }),
          const Divider(thickness: 1.5, color: Colors.grey),
          _buildSectionTitle("App Preferences"),
          _buildToggleTile(Icons.dark_mode, "Dark Mode",
              "Light, Dark, System Default", isDarkMode, _toggleDarkMode),
          _buildListTile(Icons.currency_exchange, "Currency & Region",
              "USD - United States", () {}),
          const Divider(thickness: 1.5, color: Colors.grey),
          _buildSectionTitle("Notifications & Alerts"),
          _buildListTile(
              Icons.local_offer, "Deal Alerts", "Price Drops, Restocks", () {}),
          _buildListTile(Icons.store, "Store-Specific Alerts", "", () {}),
          _buildToggleTile(Icons.notifications, "Push Notifications",
              "On/Off Toggle", notificationsEnabled, (value) {
            setState(() => notificationsEnabled = value);
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible =
                            !_isPasswordVisible; // Toggle visibility
                      });
                    },
                  ),
                ),
              ),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_isConfirmPasswordVisible, // Toggle visibility
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible; // Toggle visibility
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
              onPressed: () {
                _deleteAccount();
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
