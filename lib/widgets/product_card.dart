import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/products_page.dart';
import 'dart:async';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String productName;
  final String shopName;
  final String? description;
  final double price;
  final int? quantity;
  final String category;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.productName,
    required this.shopName,
    this.description,
    required this.price,
    this.quantity,
    required this.category,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  StreamSubscription<DocumentSnapshot>? _favoriteSubscription;

  @override
  void initState() {
    super.initState();
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
          SnackBar(content: Text('${widget.productName} removed from favorites')),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductPage(
              imageUrl: widget.imageUrl,
              productName: widget.productName,
              shopName: widget.shopName,
              description: widget.description ??
                  'If you want casual and comfortable ${widget.productName},\nIt is for you!',
              price: widget.price,
              quantity: widget.quantity,
              category: widget.category,
            ),
          ),
        );
      },
      child: Card(
        color: isDark ? Colors.grey[850] : Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    widget.imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: isDark ? Colors.grey[700] : Colors.grey[200],
                        child: const Icon(Icons.image, size: 40),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: isDark ? Colors.black : Colors.white,
                    radius: 16,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 16,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: toggleFavorite,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.category,
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: isDark ? Colors.blue[200] : Colors.blue[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.shopName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'GHC${widget.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}