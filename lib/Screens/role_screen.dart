import 'package:flutter/material.dart';
import 'personal_info_screen.dart';

class RoleScreen extends StatefulWidget {
  final String email;

  const RoleScreen({super.key, required this.email});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.grey[100];
    final borderColor = isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferred Role'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Signup As?',
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Role selection container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: Text(
                      'Seller',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    value: 'seller',
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  Divider(
                    height: 1,
                    color: borderColor,
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Customer',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    value: 'customer',
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 150),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    if (_selectedRole == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a role to continue.'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalInfoScreen(
                          email: widget.email,
                          role: _selectedRole,
                        ),
                      ),
                    );
                  },
                  child: const Text('Personal information >'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
