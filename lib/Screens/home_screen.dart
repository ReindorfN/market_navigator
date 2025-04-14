import 'package:flutter/material.dart';
import '../widgets/shop_card.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import 'search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_navigator/screens/categories_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart'
    as main_component; // Import NavigationDrawer from main.dart

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const SearchScreen(searchQuery: ''),
                      ),
                    );
                  },
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
                      childAspectRatio:
                          0.8, // Adjusted to accommodate vertical layout
                      children: [
                        CategoryCard(
                          icon: Icons.shopping_basket,
                          label: 'Groceries',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Groceries'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.devices,
                          label: 'Electronics',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Electronics'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.checkroom,
                          label: 'Fashion',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Fashion'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.sports_basketball,
                          label: 'Sports',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Sports'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.home,
                          label: 'Home & Living',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Home & Living'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.health_and_safety,
                          label: 'Health & Beauty',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Health & Beauty'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.book,
                          label: 'Books',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Books'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.toys,
                          label: 'Toys',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Toys'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.restaurant,
                          label: 'Food',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Food'),
                              ),
                            );
                          },
                        ),
                        CategoryCard(
                          icon: Icons.pets,
                          label: 'Pet Supplies',
                          isVertical: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CategoriesPage(
                                    selectedCategory: 'Pet Supplies'),
                              ),
                            );
                          },
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
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text('No products found');
                        }

                        final products = snapshot.data!.docs;

                        return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final data =
                                  product.data() as Map<String, dynamic>;

                              return ProductCard(
                                imageUrl: data['imageUrl'] ??
                                    'https://picsum.photos/200',
                                productName: data['name'] ?? 'Unnamed Product',
                                category: data['category'] ?? 'Uncategorized',
                                shopName: 'MarketMall', // temporary placeholder
                                price: (data['price'] is num)
                                    ? data['price'].toDouble()
                                    : 0.0,
                                description: data['description'],
                                quantity: data['quantity'],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
