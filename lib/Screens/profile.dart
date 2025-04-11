import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart' as main_component;
import 'package:market_navigator/screens/login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isPasswordVisible = false;

  Future<Map<String, dynamic>?> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data();
  }

  Future<void> _showEditDialog(
      BuildContext context, String field, String currentValue) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (field == 'dateOfBirth') {
      DateTime initialDate;
      try {
        initialDate = DateTime.parse(currentValue);
      } catch (_) {
        initialDate = DateTime(2000);
      }

      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );

      if (pickedDate != null) {
        String formattedDate = pickedDate.toIso8601String().split("T").first;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({field: formattedDate});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$field updated successfully!")),
        );
        setState(() {});
      }
    } else {
      TextEditingController controller =
          TextEditingController(text: currentValue);

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Edit $field"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "New $field",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .update({field: controller.text});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$field updated successfully!")),
                );
                setState(() {});
              },
              child: const Text("Save"),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              "Log Out",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: const main_component.NavigationDrawer(),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No user data found."));
          }

          final data = snapshot.data!;
          final email =
              FirebaseAuth.instance.currentUser?.email ?? "Not Available";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 35),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      "https://via.placeholder.com/150",
                    ),
                    backgroundColor: Colors.grey,
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text("Change Profile Picture")),
                const Divider(thickness: 1.5, color: Colors.grey),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Profile Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                infoRow(context, "First Name", data['firstName'] ?? "N/A",
                    "firstName"),
                infoRow(context, "Last Name", data['lastName'] ?? "N/A",
                    "lastName"),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text("Password:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        _isPasswordVisible ? "mySecret123" : "*********",
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 18,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ],
                ),
                const Divider(thickness: 1.5, color: Colors.grey),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Personal Information",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                infoRow(
                    context, "Email", email, "email"), // make email editable
                infoRow(context, "Role", data['role'] ?? "N/A", null,
                    showEdit: true), // show disabled icon
                infoRow(context, "Date of Birth", data['dateOfBirth'] ?? "N/A",
                    null,
                    showEdit: true), // show disabled icon

                const Divider(thickness: 1.5, color: Colors.grey),
                TextButton(
                  onPressed: () => _showLogoutConfirmation(context),
                  child: const Text("Log Out",
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget infoRow(
    BuildContext context,
    String label,
    String value,
    String? firestoreField, {
    bool showEdit = true,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            '$label:',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (showEdit)
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 18,
              color: firestoreField != null ? Colors.blue : Colors.grey,
            ),
            onPressed: firestoreField != null
                ? () => _showEditDialog(context, firestoreField, value)
                : null, // disables the button when no field is given
          ),
      ],
    );
  }
}
