import 'package:flutter/material.dart';
import '../main.dart' as main_component;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;

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
          _buildListTile(Icons.lock, "Change Password", "", () {}),
          _buildListTile(Icons.security, "Two-Factor Authentication (2FA)",
              "If supported", () {}),
          _buildListTile(Icons.link, "Manage Linked Accounts",
              "Google, Apple, Facebook", () {}),
          _buildListTile(Icons.delete, "Delete Account", "", () {}),
          const Divider(
            thickness: 1.5, // Thickness of the line
            color: Colors.grey, // Color of the divider
          ),
          _buildSectionTitle("App Preferences"),
          _buildToggleTile(Icons.dark_mode, "Dark Mode",
              "Light, Dark, System Default", isDarkMode, (value) {
            setState(() => isDarkMode = value);
          }),
          _buildListTile(Icons.currency_exchange, "Currency & Region",
              "USD - United States", () {}),
          _buildListTile(
              Icons.straighten, "Unit Preferences", "Metric/Imperial", () {}),
          _buildListTile(
              Icons.language, "Language Selection", "English", () {}),
          const Divider(
            thickness: 1.5, // Thickness of the line
            color: Colors.grey, // Color of the divider
          ),
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
}
