import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../widgets/shop_card.dart';
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
    searchQuery = widget
        .searchQuery; // Initialize searchQuery with the passed value
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
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 5, // Replace with actual shop count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ShopCard(),
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
