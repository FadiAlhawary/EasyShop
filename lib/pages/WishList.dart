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
  final CollectionReference wishlistRef =
      FirebaseFirestore.instance.collection('wishlist');

  // Function to remove a single item by its document ID
  Future<void> _removeFromWishlist(String docId) async {
    await wishlistRef.doc(docId).delete();
  }

  // Function to clear the entire wishlist
  Future<void> _clearWishlist() async {
    final snapshot = await wishlistRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _moveAllToCart() async {
    final snapshot = await wishlistRef.get();
    for (var doc in snapshot.docs) {
    
      await doc.reference.delete(); 
    }
  }

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

          return ListView.builder(
            itemCount: wishListDocs.length,
            itemBuilder: (context, index) {
              final wishListItem = wishListDocs[index];
              final productId = wishListItem['productId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .doc(productId)
                    .get(),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // Placeholder while loading
                  }

                  if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
                    return const SizedBox(); // Product deleted or not found
                  }

                  final productData = productSnapshot.data!;


                  return GestureDetector(
                    onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => ProductView(productUID: productData.id),)),
                    child: _buildWishlistItem(
                      context: context,
                      wishlistDocId: wishListItem.id, // important for delete
                      photoURL: productData['PhotosURL'][0],
                      productName: productData['Name'] ,
                      price: productData['Price'],
                    ),
                  );
                },
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
}
