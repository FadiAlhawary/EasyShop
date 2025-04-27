import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/data/constants.dart';
import 'package:flutter/material.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final CollectionReference wishlistRef =
      FirebaseFirestore.instance.collection('wishlist');

 
  Future<void> _removeFromWishlist(String docId) async {
    await wishlistRef.doc(docId).delete();
  }

 
  Future<void> _clearWishlist() async {
    final snapshot = await wishlistRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

 Future<void> _moveAllToCart() async {
  final snapshot = await wishlistRef.get();

  for (var doc in snapshot.docs) {
    
    await FirebaseFirestore.instance
        .collection('cart')
        .add(doc.data() as Map<String, dynamic>);

    // Delete item from wishlist
    await doc.reference.delete();
  }


  if (mounted) {
    Navigator.pushReplacementNamed(context, '/cart');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear Wishlist', style: KStyle.titleTextStyle),
                  content: Text('Are you sure you want to clear your wishlist?', style: KStyle.normalTextStyle),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
              if (confirm == true) {
                await _clearWishlist();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: wishlistRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          final wishlistItems = snapshot.data?.docs ?? [];

          if (wishlistItems.isEmpty) {
            return const Center(
              child: Text('Your wishlist is empty.'),
            );
          }

          double totalPrice = 0;
          for (var item in wishlistItems) {
            totalPrice += (item['price'] as num?)?.toDouble() ?? 0.0;
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: wishlistItems.length,
                  itemBuilder: (context, index) {
                    final item = wishlistItems[index];
                    return _buildWishlistItem(
                      docId: item.id,
                      brand: item['brand'] ?? '',
                      productName: item['productName'] ?? '',
                      details: item['details'],
                      price: (item['price'] as num?)?.toDouble() ?? 0.0,
                    );
                  },
                ),
              ),
              _buildBottomBar(context, totalPrice),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWishlistItem({
    required String docId,
    required String brand,
    required String productName,
    String? details,
    required double price,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            color: Colors.grey[200],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(brand, style: KStyle.titleTextStyle),
                    const Text('view brand', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Text(productName, style: KStyle.normalTextStyle),
                if (details != null)
                  Text(details, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: KStyle.titleTextStyle,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _removeFromWishlist(docId),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double totalPrice) {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Price', style: KStyle.titleTextStyle),
              const SizedBox(height: 4),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: KStyle.headerTextStyle.copyWith(fontSize: 18),
              ),
            ],
          ),
          const Spacer(),
          FilledButton(
            onPressed: () async {
              if (totalPrice > 0) {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Move to Cart', style: KStyle.titleTextStyle),
                    content: Text('Move all items to your cart?', style: KStyle.normalTextStyle),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Move'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await _moveAllToCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Items moved to cart!')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wishlist is empty.')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Move All To Cart',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
