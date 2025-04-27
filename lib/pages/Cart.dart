import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/data/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Order.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
   double totalPrice=0;
   Future<double> _calculateTotalPrice(List<QueryDocumentSnapshot> cartItems) async {
     double total = 0.0;

     for (var cartItem in cartItems) {
       final productId = cartItem['productId'];
       final quantity = cartItem['Quantity'] ?? 1;

       final productSnapshot = await FirebaseFirestore.instance.collection('products').doc(productId).get();
       if (productSnapshot.exists) {
         final price = productSnapshot.data()!['Price'] ?? 0;
         total += (price * quantity);
       }
     }

     return total;
   }

  // void _updateQuantity(String docId, int newQuantity) {
  //   if (newQuantity > 0) {
  //     FirebaseFirestore.instance
  //         .collection('cart')
  //         .doc(docId)
  //         .update({'Quantity': newQuantity});
  //   } else {
  //     // If quantity <= 0, remove the item
  //     FirebaseFirestore.instance
  //         .collection('cart')
  //         .doc(docId)
  //         .delete();
  //   }
  // }

  void updateQuantity(String docId, int newQuantity) {
    if (newQuantity > 0) {
      FirebaseFirestore.instance
          .collection('cart')
          .doc(docId)
          .update({'Quantity': newQuantity});
    } else {
      // If quantity <= 0, remove the item
      FirebaseFirestore.instance
          .collection('cart')
          .doc(docId)
          .delete();
    }
  }

  void _clearCart() async {
    var cartItems = await FirebaseFirestore.instance
        .collection('cart')
        .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (var doc in cartItems.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final cartStream = FirebaseFirestore.instance
        .collection('cart')
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
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear Cart', style: KStyle.titleTextStyle),
                  content: Text('Are you sure you want to clear your cart?', style: KStyle.normalTextStyle),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _clearCart();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final cartItems = snapshot.data!.docs;

          return FutureBuilder(
            future: _calculateTotalPrice(cartItems),
            builder: (context, totalSnapshot) {
              if (totalSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              double totalPrice = totalSnapshot.data ?? 0.0;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final cartItem = cartItems[index];
                        final productId = cartItem['productId'];
                        return FutureBuilder(
                          future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
                          builder: (context, productSnapshot) {
                            if (productSnapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox();
                            }
                            if (!productSnapshot.hasData || !productSnapshot.data!.exists) {
                              return const SizedBox();
                            }

                            final productData = productSnapshot.data!;
                            return _buildCartItem(
                              docId: productData.id,
                              photoURL: productData['PhotosURL'][0],
                              productName: productData['Name'] ?? '',
                              price: productData['Price'],
                              quantity: cartItem['Quantity'],
                              onQuantityChanged: (newQuantity) {
                                updateQuantity(cartItem.id, newQuantity);
                              },
                            );
                          },
                        );
                      },
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

  Widget _buildCartItem({
    required String docId,
    required String photoURL,
    required String productName,
    String? details,
    required int price,
    required int quantity,
    required ValueChanged<int> onQuantityChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                if (details != null)
                  Text(details, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '\$${price}',
                  style: KStyle.titleTextStyle,
                ),
              ],
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                  onQuantityChanged(quantity + 1);
                },
                child: const Icon(Icons.add, size: 16),
              ),
              const SizedBox(height: 4),
              Text('$quantity'),
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  onQuantityChanged(quantity - 1);
                },
                child: const Icon(Icons.remove, size: 16),
              ),
            ],
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
              // Checkout functionality (You can expand this)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order placed successfully!'),
                ),
              );
              Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage(),));
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              'Check Out',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
