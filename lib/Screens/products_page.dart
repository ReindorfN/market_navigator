import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedSize = 42;
  Color selectedColor = Colors.deepPurple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Purple indicator
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Image.network(
                  'https://placehold.co/300x200/blue/white?text=Blue+Shoe',
                  height: 200,
                  fit: BoxFit.contain,
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
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Diffenente shoes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'If you want casual and comfortable shoes,\nDiffenente 14 is for you!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      const Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '50% discount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Size Selection
                  const Text(
                    'Size',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSizeOption(40),
                      _buildSizeOption(41),
                      _buildSizeOption(42),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Color Selection
                  const Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildColorOption(Colors.deepPurple),
                      _buildColorOption(Colors.grey),
                      _buildColorOption(Colors.pink),
                      _buildColorOption(Colors.orange),
                      _buildColorOption(Colors.green),
                      _buildColorOption(Colors.white),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Buy Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Buy It\n\$94.00',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
  
  Widget _buildSizeOption(int size) {
    final bool isSelected = selectedSize == size;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.deepPurple : Colors.grey,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            size.toString(),
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildColorOption(Color color) {
    final bool isSelected = selectedColor == color;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}