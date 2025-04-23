// import 'package:flutter/material.dart';
// class ProductCardWidget extends StatefulWidget {
//   const ProductCardWidget({super.key
//
//   });
//
//   @override
//   State<ProductCardWidget> createState() => _ProductCardWidgetState();
// }
//
// class _ProductCardWidgetState extends State<ProductCardWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//
//       },
//       child: Card(
//         elevation: 8,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Hero(
//                 tag: product['name'],
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   child: Image.asset(
//                     product['image'],
//                     height: 120, // Smaller image height
//                     width: double.infinity,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product['name'],
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "\$${product['price']}",
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     product['desc'],
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: IconButton(
//                 icon: Icon(
//                   product['isInWishlist']
//                       ? Icons.favorite
//                       : Icons.favorite_border,
//                   color:
//                   product['isInWishlist']
//                       ? Colors.red
//                       : Colors.grey,
//                 ),
//                 onPressed: () => toggleWishlist(index),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );;
//   }
// }
