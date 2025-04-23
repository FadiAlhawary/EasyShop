import 'package:easyshop/data/constants.dart';
import 'package:flutter/material.dart';



class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  // List to store wishlist items.  Each item is a map with product details.
  final List<Map<String, dynamic>> _wishlistItems = [
    {
      'brand': 'Scarlett',
      'productName': 'Scarlett Whitening Brightly Serum',
      'price': 10.3,
    },
    {
      'brand': 'Ponds',
      'productName': 'Ponds White Series',
      'details': '4 Products',
      'price': 21.93,
    },
    {
      'brand': 'Emina',
      'productName': 'Emina Bright Stuff Face Serum',
      'price': 11.56,
    },
  ];

  // Function to remove an item from the wishlist.
  // The 'index' parameter tells us which item to remove.
  void _removeFromWishlist(int index) {
    setState(() {
      _wishlistItems.removeAt(index); // Remove the item at the given index.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen.
          },
        ),
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _wishlistItems.clear(); // Remove all items from the wishlist.
              });
            },
          ),
        ],
      ),
      // Display a message if the wishlist is empty.
      body: _wishlistItems.isEmpty
          ? const Center(
              child: Text('Your wishlist is empty.'),
            )
          // Otherwise, display the list of wishlist items.
          : Column(
              children: [
                // Use Expanded to make the ListView take up the available space.
                Expanded(
                  child: ListView.builder(
                    itemCount: _wishlistItems.length, // Number of items in the list.
                    itemBuilder: (context, index) {
                      // Get the item at the current index.
                      final item = _wishlistItems[index];
                      // Build and return a widget to display the wishlist item.
                      return _buildWishlistItem(
                        index: index, // Pass the index to the item builder.
                        brand: item['brand'],
                        productName: item['productName'],
                        details: item['details'],
                        price: item['price'],
                        onRemove: () {
                          _removeFromWishlist(index); // Call remove function.
                        },
                      );
                    },
                  ),
                ),
                // Display the bottom bar with the total price and "Move All to Cart" button.
                _buildBottomBar(context),
              ],
            ),
    );
  }

  // Function to build a single wishlist item widget.
  Widget _buildWishlistItem({
    required int index, // The index of the item in the list.
    required String brand,
    required String productName,
    String? details, // Optional details.
    required double price,
    required VoidCallback onRemove, // Callback when the remove button is pressed.
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display a placeholder image.
          Container(
            width: 80,
            height: 80,
            color: Colors.grey[200],
          ),
          const SizedBox(width: 16),
          // Display the product information.
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
          // Button to remove the item.
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onRemove, // Call the provided onRemove callback.
          ),
        ],
      ),
    );
  }

  // Function to build the bottom bar.
  Widget _buildBottomBar(BuildContext context) {
    // Calculate the total price of all items in the wishlist.
    double totalPrice = 0;
    for (var item in _wishlistItems) {
      totalPrice += item['price'];
    }

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Display the total price.
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Price', style: KStyle.titleTextStyle), // Use titleTextStyle
              const SizedBox(height: 4),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: KStyle.headerTextStyle.copyWith(fontSize: 18), // Use headerTextStyle and adjust fontSize
              ),
            ],
          ),
          const Spacer(),
          // Button to move all items to the cart.
          FilledButton(
            onPressed: () {
              // Check if the wishlist is empty
              if (_wishlistItems.isNotEmpty) {
                // Show a confirmation dialog.
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title:  Text('Move to Cart', style: KStyle.titleTextStyle,), // Use titleTextStyle
                    content:  Text('Move all items to your cart?',style: KStyle.normalTextStyle), // Use normalTextStyle
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.of(context).pop(), // Close the dialog.
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // 1. Move items to cart (implementation needed).
                          //    This is where you would add the items to your cart data.
                          //    For example:
                          //    CartManager.addItems(_wishlistItems);

                          // 2. Clear the wishlist.
                          setState(() {
                            _wishlistItems.clear();
                          });

                          // 3. Show a confirmation message.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Items moved to cart!'),
                            ),
                          );
                          Navigator.of(context).pop(); // Close the dialog.
                        },
                        child: const Text('Move'),
                      ),
                    ],
                  ),
                );
              } else {
                // Show a message if the wishlist is empty.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wishlist is empty.')),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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

