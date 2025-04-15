import 'package:flutter/material.dart';
import '../models/shop.dart'; // Import the Shop model

class ShopDetailsScreen extends StatelessWidget {
  final Shop shop; // Accept a Shop object

  const ShopDetailsScreen({
    super.key,
    required this.shop,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Shop Image/Logo with collapsing toolbar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                shop.logoUrl, // Use the shop logo
                fit: BoxFit.cover,
              ),
              title: Text(shop.shopName), // Use the shop name
            ),
          ),

          // Shop Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Shop Address', // Replace with shop.address
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Contact Information
                  Text(
                    'Email: ${shop.email}', // Display email
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: ${shop.phoneNumber}', // Display phone number
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Working Hours
                  const Text(
                    'Working Hours',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildWorkingHours(shop.workingHours), // Pass working hours
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHours(Map<String, String> hours) {
    return Column(
      children: hours.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(entry.value),
            ],
          ),
        );
      }).toList(),
    );
  }
}
