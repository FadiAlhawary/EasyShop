import 'package:flutter/material.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              // Handle delete cart action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildCartItem(
                  brand: 'Scarlett',
                  productName: 'Scarlett Whitening Brightly Serum',
                  price: 10.3,
                  quantity: 1,
                  onQuantityChanged: (newQuantity) {},
                ),
                _buildCartItem(
                  brand: 'Ponds',
                  productName: 'Ponds White Series',
                  details: '4 Products',
                  price: 21.93,
                  quantity: 1,
                  onQuantityChanged: (newQuantity) {},
                ),
                _buildCartItem(
                  brand: 'Emina',
                  productName: 'Emina Bright Stuff Face Serum',
                  price: 11.56,
                  quantity: 2,
                  onQuantityChanged: (newQuantity) {},
                ),
              ],
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildCartItem({
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
                    Text(brand, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('view brand', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Text(productName),
                if (details != null)
                  Text(details, style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
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
                  if (quantity > 1) {
                    onQuantityChanged(quantity - 1);
                  }
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
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Amount Price', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(
                '\$55.08',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              // Handle checkout
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Row(
              children: const [
                Text(
                  'Check Out',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 12,
                  child: Text(
                    '4',
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
