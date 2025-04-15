import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../widgets/shop_card.dart';
import '../models/shop.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;

  const SearchScreen({
    super.key,
    required this.searchQuery, // Use 'searchQuery' here
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;
  String searchQuery = ''; // Local variable to handle search query

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    searchQuery =
        widget.searchQuery; // Initialize searchQuery with the passed value
    _performSearch();
  }

  void _performSearch() {
    setState(() {
      isLoading = true;
    });

    // Simulate API call (Firestore query in this case)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search products or shops...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          onSubmitted: (value) {
            // Update the local searchQuery when the user submits
            setState(() {
              searchQuery = value;
            });
            _performSearch();
          },
          controller: TextEditingController(
              text: searchQuery), // Display the search query in the text field
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'Shops'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Products Tab
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .where('name', isGreaterThanOrEqualTo: searchQuery)
                      .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }

                    final products = snapshot.data!.docs;

                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
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
                        final data = product.data() as Map<String, dynamic>;

                        return ProductCard(
                          imageUrl:
                              data['imageUrl'] ?? 'https://picsum.photos/200',
                          productName: data['name'] ?? 'Unnamed Product',
                          category: data['category'] ?? 'Uncategorized',
                          shopName: 'MarketMall', // Placeholder shop name
                          price: (data['price'] is num)
                              ? data['price'].toDouble()
                              : 0.0,
                          description: data['description'] ?? '',
                        );
                      },
                    );
                  },
                ),
                // Shops Tab
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('shop_info')
                      .where('shopName', isGreaterThanOrEqualTo: searchQuery)
                      .where('shopName',
                          isLessThanOrEqualTo: '$searchQuery\uf8ff')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No shops found'));
                    }

                    final shops = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: shops.length,
                      itemBuilder: (context, index) {
                        final shopData =
                            shops[index].data() as Map<String, dynamic>;
                        return ShopCard(
                          shop: Shop(
                            shopName: shopData['shopName'] ?? 'Shop Name',
                            address: shopData['address'] ?? 'Shop Address',
                            email: shopData['email'] ?? 'shop@example.com',
                            logoUrl: shopData['logoUrl'] ??
                                'https://example.com/logo.png',
                            phoneNumber:
                                shopData['phoneNumber'] ?? '123-456-7890',
                            workingHours: shopData['workingHours'] is String
                                ? {'Mon-Fri': shopData['workingHours']}
                                : Map<String, String>.from(
                                    shopData['workingHours'] ?? {}),
                            latitude: shopData['latitude']?.toDouble() ?? 0.0,
                            longitude: shopData['longitude']?.toDouble() ?? 0.0,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
