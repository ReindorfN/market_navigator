import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Widgets/product_card.dart';

class CategoriesPage extends StatefulWidget {
  final String selectedCategory;

  const CategoriesPage({
    Key? key,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Stream<QuerySnapshot> _productStream;

  @override
  void initState() {
    super.initState();
    _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.selectedCategory)
        .snapshots();
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _productStream = FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: widget.selectedCategory)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final bgColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectedCategory,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: bgColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 1,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: StreamBuilder<QuerySnapshot>(
          stream: _productStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading products.',
                  style: TextStyle(color: textColor),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final products = snapshot.data?.docs ?? [];

            if (products.isEmpty) {
              return Center(
                child: Text(
                  'No products found in this category.',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final data = products[index].data() as Map<String, dynamic>;

                return ProductCard(
                  imageUrl: data['imageUrl'] ?? 'https://picsum.photos/200',
                  productName: data['name'] ?? 'Unnamed Product',
                  category: data['category'] ?? 'Uncategorized',
                  shopName: data['shopName'] ?? 'MarketMall',
                  price: (data['price'] is num) ? data['price'].toDouble() : 0.0,
                  description: data['description'] ?? 'No description available.',
                  quantity: data['quantity'] ?? 0,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
