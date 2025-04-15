import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../widgets/shop_card.dart';
import '../models/shop.dart';

class ProductPage extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String shopName;
  final String? description;
  final double price;
  final int? quantity;
  final String category;

  const ProductPage({
    Key? key,
    required this.imageUrl,
    required this.productName,
    required this.shopName,
    this.description,
    required this.price,
    this.quantity,
    required this.category,
  }) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedQuantity = 1;
  bool isFavorite = false;
  StreamSubscription<DocumentSnapshot>? _favoriteSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize quantity if provided
    if (widget.quantity != null) {
      selectedQuantity = widget.quantity!;
    }
    // Listen for changes to favorite status
    _listenToFavoriteChanges();
  }

  @override
  void dispose() {
    _favoriteSubscription?.cancel();
    super.dispose();
  }

  // Listen for changes to favorite status
  void _listenToFavoriteChanges() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.productName);

    _favoriteSubscription = favRef.snapshots().listen((docSnapshot) {
      if (mounted) {
        setState(() {
          isFavorite = docSnapshot.exists;
        });
      }
    });
  }

  // Toggle the favorite status and save/remove the product from Firestore
  void toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to save favorites')),
      );
      return;
    }

    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(widget.productName);

    try {
      if (isFavorite) {
        // Remove from favorites
        await favRef.delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${widget.productName} removed from favorites')),
        );
      } else {
        // Add to favorites
        await favRef.set({
          'imageUrl': widget.imageUrl,
          'productName': widget.productName,
          'shopName': widget.shopName,
          'description': widget.description ?? '',
          'price': widget.price,
          'quantity': widget.quantity ?? 0,
          'category': widget.category,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.productName} added to favorites')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if dark mode is enabled
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      // Use theme-based background color for the scaffold
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: isDark ? Colors.white70 : Colors.grey),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : (isDark ? Colors.white70 : Colors.grey)),
                      onPressed: toggleFavorite,
                    ),
                  ],
                ),
              ),

              // Rest of the UI remains the same...
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                height: 4,
                width: 20,
                color: Colors.deepPurple,
              ),

              // Product Image
              Container(
                width: double.infinity,
                height: 250,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[800] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black26
                          : Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.network(
                    widget.imageUrl,
                    height: 200,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image,
                          size: 100,
                          color: isDark ? Colors.white54 : Colors.black54);
                    },
                  ),
                ),
              ),

              // Small purple indicator
              Center(
                child: Container(
                  height: 4,
                  width: 32,
                  color: Colors.deepPurple,
                ),
              ),

              // Product Title and Info
              Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black26
                          : Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description ?? 'No description available',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Shop name
                    Text(
                      'Shop: ${widget.shopName}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Price, Quantity, and Category
                    Row(
                      children: [
                        Text(
                          'GHC${widget.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.greenAccent : Colors.green[700],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.amber[700] : Colors.amber,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.black87 : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Divider for visual separation
                    Divider(
                        color: isDark ? Colors.grey[700] : Colors.grey[300]),
                    const SizedBox(height: 8),

                    // Quantity
                    Row(
                      children: [
                        Text(
                          'Quantity Available',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$selectedQuantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Add to cart button
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.deepPurple,
                    //       foregroundColor: Colors.white,
                    //       padding: const EdgeInsets.symmetric(vertical: 12),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(8),
                    //       ),
                    //       elevation: isDark ? 8 : 4,
                    //     ),
                    //     onPressed: () {
                    //       // Add to cart functionality
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //           content: Text(
                    //               'Added $selectedQuantity ${widget.productName} to cart'),
                    //           duration: const Duration(seconds: 2),
                    //           backgroundColor: isDark ? Colors.grey[800] : null,
                    //         ),
                    //       );
                    //     },
                    //     child: const Text(
                    //       'Add to Cart',
                    //       style: TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Other shops section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black26
                          : Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Other Shops selling same product',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('shop_info')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
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
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ShopCard(
                                shop: Shop(
                                  shopName: shopData['name'] ?? 'Shop Name',
                                  address:
                                      shopData['address'] ?? 'Shop Address',
                                  email:
                                      shopData['email'] ?? 'shop@example.com',
                                  logoUrl: shopData['logoUrl'] ??
                                      'https://example.com/logo.png',
                                  phoneNumber:
                                      shopData['phoneNumber'] ?? '123-456-7890',
                                  workingHours: shopData['workingHours']
                                          is String
                                      ? {'Mon-Fri': shopData['workingHours']}
                                      : Map<String, String>.from(
                                          shopData['workingHours'] ?? {}),
                                  latitude:
                                      shopData['latitude']?.toDouble() ?? 0.0,
                                  longitude:
                                      shopData['longitude']?.toDouble() ?? 0.0,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
