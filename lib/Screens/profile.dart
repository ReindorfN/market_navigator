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
                const SizedBox(height: 35),

                /// Profile Picture
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(""), // Load from the web
                    backgroundColor: Colors.grey,
                  ),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text("Change Profile Picture")),

                /// Divider to separate profile picture and details
                const Divider(
                  thickness: 1.5, // Thickness of the line
                  color: Colors.grey, // Color of the divider
                ),
                SizedBox(height: 20),

                /// Right-aligned "Profile Information" text
                Align(
                  alignment: Alignment.centerLeft, // Moves text to the right
                  child: const Text(
                    "Profile Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

                /// Row with Username and Password
                /// Username Row
                Row(
                  children: [
                    /// Username Label (Takes 3 parts of space)
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Username:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    /// Username Value (Takes 5 parts of space)
                    Expanded(
                      flex: 5,
                      child: Text(
                        'johndoe123',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// Edit Icon (Pencil)
                    IconButton(
                      icon:
                          const Icon(Icons.edit, size: 18, color: Colors.blue),
                      onPressed: () {
                        // Handle editing action here
                        // print('Edit user Clicked');
                      },
                    ),
                  ],
                ),

                /// Password Row
                Row(
                  children: [
                    /// Password Label
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Password:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    /// Password Value
                    Expanded(
                      flex: 5,
                      child: Text(
                        '*********', // Masked password
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.visibility,
                          size: 18, color: Colors.blue),
                      onPressed: () {
                        // Handle editing action here
                        // print('Edit Password Clicked');
                      },
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1.5, // Thickness of the line
                  color: Colors.grey, // Color of the divider
                ),
                SizedBox(height: 20),

                /// Right-aligned "Profile Information" text
                Align(
                  alignment: Alignment.centerLeft, // Moves text to the right
                  child: const Text(
                    "Personal Information",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    /// Username Label (Takes 3 parts of space)
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Email:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    /// Username Value (Takes 5 parts of space)
                    Expanded(
                      flex: 5,
                      child: Text(
                        'johndoe@123.com',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// Edit Icon (Pencil)
                    IconButton(
                      icon:
                          const Icon(Icons.edit, size: 18, color: Colors.blue),
                      onPressed: () {
                        // Handle editing action here
                        // print('Edit Password Clicked');
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    /// Username Label (Takes 3 parts of space)
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Gender:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    /// Username Value (Takes 5 parts of space)
                    Expanded(
                      flex: 5,
                      child: Text(
                        'Male',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// Edit Icon (Pencil)
                    IconButton(
                      icon:
                          const Icon(Icons.edit, size: 18, color: Colors.blue),
                      onPressed: () {
                        // Handle editing action here
                        // print('Edit Password Clicked');
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    /// Username Label (Takes 3 parts of space)
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Date of Birth:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    /// Username Value (Takes 5 parts of space)
                    Expanded(
                      flex: 5,
                      child: Text(
                        '10th October 19194',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    /// Edit Icon (Pencil)
                    IconButton(
                      icon:
                          const Icon(Icons.edit, size: 18, color: Colors.blue),
                      onPressed: () {
                        // Handle editing action here
                        // print('Edit Password Clicked');
                      },
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1.5, // Thickness of the line
                  color: Colors.grey, // Color of the divider
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ),
          ),
        ),
      );
}
