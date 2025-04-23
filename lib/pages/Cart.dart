import 'package:easyshop/data/constants.dart';
import 'package:flutter/material.dart';
class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  _CartState createState() => _CartState(); // Add State class
}

class _CartState extends State<Cart> {
  // Sample data for cart items
  final List<Map<String, dynamic>> _cartItems = [
    {
      'brand': 'Scarlett',
      'productName': 'Scarlett Whitening Brightly Serum',
      'price': 10.3,
      'quantity': 1,
    },
    {
      'brand': 'Ponds',
      'productName': 'Ponds White Series',
      'details': '4 Products',
      'price': 21.93,
      'quantity': 1,
    },
    {
      'brand': 'Emina',
      'productName': 'Emina Bright Stuff Face Serum',
      'price': 11.56,
      'quantity': 2,
    },
  ];

  // Function to handle quantity changes
  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity > 0) {
        _cartItems[index]['quantity'] = newQuantity;
      } else {
        // Remove the item if the quantity is reduced to zero
        _cartItems.removeAt(index);
      }
    });
  }

  // Function to clear the entire cart
  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
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
              // Show a confirmation dialog before clearing the cart
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Clear Cart', style: KStyle.titleTextStyle,),
                  content: Text('Are you sure you want to clear your cart?',style: KStyle.normalTextStyle),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(), // Cancel
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _clearCart(); // Clear the cart
                        Navigator.of(context).pop(); // Close the dialog
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
      body: _cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty.'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return _buildCartItem(
                        index: index,
                        brand: item['brand'],
                        productName: item['productName'],
                        details: item['details'],
                        price: item['price'],
                        quantity: item['quantity'],
                        onQuantityChanged: (newQuantity) {
                          _updateQuantity(index, newQuantity);
                        },
                      );
                    },
                  ),
                ),
                _buildBottomBar(context),
              ],
            ),
    );
  }

  Widget _buildCartItem({
    required int index, // Add index
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
                    Text(brand, style: KStyle.titleTextStyle), // Use titleTextStyle
                    const Text('view brand', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Text(productName, style: KStyle.normalTextStyle,), // Use normalTextStyle
                if (details != null)
                  Text(details, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: KStyle.titleTextStyle, // Use titleTextStyle
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

  Widget _buildBottomBar(BuildContext context) {
    double totalPrice = 0;
    for (var item in _cartItems) {
      totalPrice += item['price'] * item['quantity']; // Calculate total
    }

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Price', style: KStyle.titleTextStyle), // Use titleTextStyle
              const SizedBox(height: 4),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: KStyle.headerTextStyle.copyWith(fontSize: 18), // Use headerTextStyle
              ),
            ],
          ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              // Handle checkout
              if (_cartItems.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Checkout', style: KStyle.titleTextStyle),
                    content: Text('Proceed to checkout?', style: KStyle.normalTextStyle),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Implement checkout logic here (e.g., send order, clear cart)
                          // For now, just show a message and clear the cart
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order placed successfully!'),
                            ),
                          );
                          _clearCart(); // Clear the cart after checkout
                          Navigator.of(context).pop();
                        },
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Your cart is empty.')),
                );
              }
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


