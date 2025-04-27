import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/pages/ProductView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easyshop/data/constants.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final wishListStream = FirebaseFirestore.instance
        .collection('wishList')
        .where('userId', isEqualTo: userId)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Wishlist'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: wishListStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }

          final wishListDocs = snapshot.data?.docs ?? [];

          if (wishListDocs.isEmpty) {
            return const Center(child: Text('Your wishlist is empty.'));
          }

          return FutureBuilder<List<Widget>>(
            future: _buildWishlistItem(wishlistDoc),
            builder: (context, itemSnapshot) {
              if (itemSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!itemSnapshot.hasData) {
                return const Center(child: Text('Something went wrong.'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: itemSnapshot.data!,
                    ),
                  ),
                  _buildBottomBar(totalPrice),
                ],
              );
            },
          );
        },
      ),

    );
  }

  Widget _buildWishlistItem({
    required BuildContext context,
    required String wishlistDocId,
    required String photoURL,
    required String productName,
    required int price,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image.network(photoURL),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(productName, style: KStyle.normalTextStyle),
                const SizedBox(height: 8),
                Text(
                  '\$$price',
                  style: KStyle.titleTextStyle,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('wishList')
                  .doc(wishlistDocId)
                  .delete();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(double totalPrice) {
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
            onPressed: () {


         toCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Switched to cart  successfully!'),
                ),
              );

            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Add to Cart',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}


