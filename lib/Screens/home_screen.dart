import 'package:flutter/material.dart';
import '../widgets/shop_card.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),

                  //Search bar
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {},
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

                // Popular Shops Section
                Container(
                  height: 250, // Adjust height as needed
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Popular Shops Nearby',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          itemCount: 5, // Replace with actual shop count
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ShopCard(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Product Categories Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.5,
                        children: const [
                          CategoryCard(
                            icon: Icons.shopping_basket,
                            label: 'Groceries',
                          ),
                          CategoryCard(
                            icon: Icons.devices,
                            label: 'Electronics',
                          ),
                          CategoryCard(
                            icon: Icons.checkroom,
                            label: 'Fashion',
                          ),
                          CategoryCard(
                            icon: Icons.sports_basketball,
                            label: 'Sports',
                          ),
                          CategoryCard(
                            icon: Icons.home,
                            label: 'Home & Living',
                          ),
                          CategoryCard(
                            icon: Icons.health_and_safety,
                            label: 'Health & Beauty',
                          ),
                          CategoryCard(
                            icon: Icons.book,
                            label: 'Books',
                          ),
                          CategoryCard(
                            icon: Icons.toys,
                            label: 'Toys',
                          ),
                          CategoryCard(
                            icon: Icons.restaurant,
                            label: 'Food',
                          ),
                          CategoryCard(
                            icon: Icons.pets,
                            label: 'Pet Supplies',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Popular Products Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Popular Products',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: 6, // Show 6 random products
                        itemBuilder: (context, index) {
                          return ProductCard(
                            imageUrl:
                                'https://picsum.photos/200', // Replace with actual product image
                            productName: 'Product ${index + 1}',
                            rating: 4.5,
                            shopName: 'Shop ${index + 1}',
                            price: 99.99,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
