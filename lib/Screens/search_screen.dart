import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import '../widgets/shop_card.dart';

class SearchScreen extends StatefulWidget {
  final String searchQuery;

  const SearchScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // TODO: Implement actual search functionality
    _performSearch();
  }

  void _performSearch() {
    setState(() {
      isLoading = true;
    });
    // Simulate API call
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
            // TODO: Implement search functionality
          },
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
                GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 6, // Replace with actual product count
                  itemBuilder: (context, index) {
                    return ProductCard(
                      imageUrl: 'https://picsum.photos/200',
                      productName: 'Product ${index + 1}',
                      rating: 4.5,
                      shopName: 'Shop ${index + 1}',
                      price: 99.99,
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
