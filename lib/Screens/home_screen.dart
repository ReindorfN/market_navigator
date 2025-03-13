import 'package:flutter/material.dart';
import '../main.dart'
    as main_component; // Import NavigationDrawer from main.dart
// import 'package:market_navigator/main.dart' as mainComponent;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("HomePage"),
            backgroundColor: Colors.blueAccent,
          ),
          drawer: const main_component
              .NavigationDrawer(), // Now NavigationDrawer is accessible
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        // Add filter functionality here
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0,
                      horizontal: 20.0,
                    ),
                  ),
                ),
              ),

              VerticalDivider(
                color: Colors.amber,
              ),

              ElevatedButton(
                  onPressed: () {},
                  // {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const BarcodeScan()));
                  // },
                  child: const Icon(Icons.camera)),
              // Rest of your body content will go here
              const Expanded(child: Center(child: Text('Content goes here'))),
            ],
          ),
        ),
      );
}
