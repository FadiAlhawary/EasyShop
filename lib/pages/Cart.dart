import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/data/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  
  void _updateQuantity(String docId, int newQuantity) {
    if (newQuantity > 0) {
      FirebaseFirestore.instance
          .collection('cart')
          .doc(docId)
          .update({'quantity': newQuantity});
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
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('UserID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Your cart is empty.'));
          }

          final cartItems = snapshot.data!.docs;

          double totalPrice = 0;
          for (var item in cartItems) {
            totalPrice += (item['price'] ?? 0) * (item['quantity'] ?? 1);
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return _buildCartItem(
                      docId: item.id,
                      brand: item['brand'] ?? '',
                      productName: item['productName'] ?? '',
                      details: item['details'],
                      price: item['price']?.toDouble() ?? 0.0,
                      quantity: item['quantity'] ?? 1,
                      onQuantityChanged: (newQuantity) {
                        _updateQuantity(item.id, newQuantity);
                      },
                    );
                  },
                ),
              ),
              _buildBottomBar(totalPrice),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCartItem({
    required String docId,
    required String brand,
    required String productName,
    String? details,
    required double price,
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
              _clearCart();
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
