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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferred Role'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Signup As?', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),

            // Role selection options in a container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Seller'),
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
                  const Divider(height: 1),
                  RadioListTile<String>(
                    title: const Text('Customer'),
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
                    // Check if role is selected
                    if (_selectedRole == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a role to continue.'),
                        ),
                      );
                      return; // Don't navigate if role is not selected
                    }

                    // Navigate to PersonalInfoScreen with selected role
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
