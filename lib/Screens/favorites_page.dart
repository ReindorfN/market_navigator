// // lib/screens/favorites_page.dart
// import 'package:flutter/material.dart';
// import '../widgets/product_card.dart';

// class FavoritesPage extends StatelessWidget {
//   const FavoritesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Favorites')),
//       body: favoriteProducts.isEmpty
//           ? const Center(child: Text('No favorite products yet'))
//           : ListView.builder(
//               itemCount: favoriteProducts.length,
//               itemBuilder: (context, index) {
//                 final product = favoriteProducts[index];
//                 return ProductCard(
//                   imageUrl: product.imageUrl,
//                   productName: product.productName,
//                   shopName: product.shopName,
//                   description: product.description,
//                   price: product.price,
//                   quantity: product.quantity,
//                   category: product.category,
//                 );
//               },
//             ),
//     );
//   }
// }