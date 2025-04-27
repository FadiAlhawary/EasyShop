import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/data/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderState();
}

class _OrderState extends State<OrderPage> {
  String paymentMethod = 'cash';

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController streetAddressController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final Color primaryBlue = const Color(0xFF2979FF);
  final Color background = const Color(0xFFF0F4FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        title: const Text('Order'),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Billing Details', style: KStyle.headerTextStyle.copyWith(color: primaryBlue)),
            const SizedBox(height: 20),

            _inputField('First Name*', firstNameController),
            _inputField('Company Name', companyNameController),
            _inputField('Street Address*', streetAddressController),
            _inputField('Apartment (optional)', apartmentController),
            _inputField('Town/City*', cityController),

            const SizedBox(height: 30),
            _itemRow('LCD Monitor', 650),
            _itemRow('H1 Gamepad', 1100),
            const Divider(thickness: 1.2),
            _priceRow('Subtotal', 1750),
            _priceRow('Shipping', 0, isFree: true),
            _priceRow('Total', 1750),

            const SizedBox(height: 20),
            Text('Payment Method', style: KStyle.titleTextStyle.copyWith(color: primaryBlue)),
            RadioListTile(
              activeColor: primaryBlue,
              title: const Text('Bank'),
              value: 'bank',
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value!),
            ),
            RadioListTile(
              activeColor: primaryBlue,
              title: const Text('Cash on delivery'),
              value: 'cash',
              groupValue: paymentMethod,
              onChanged: (value) => setState(() => paymentMethod = value!),
            ),

            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                _placeOrder(['product1', 'product2']);
              },
              child: const Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _itemRow(String name, int price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: KStyle.normalTextStyle),
          Text('\$$price', style: KStyle.normalTextStyle),
        ],
      ),
    );
  }

  Widget _priceRow(String label, int amount, {bool isFree = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: KStyle.titleTextStyle.copyWith(color: primaryBlue)),
          Text(
            isFree ? 'Free' : '\$$amount',
            style: KStyle.titleTextStyle.copyWith(
              color: primaryBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(List<String> productId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return; // User not logged in

    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user.uid,
      'ProductId': productId,
      'paymentMethod': paymentMethod,
      'Date': Timestamp.now(),
      'Name': firstNameController.text.trim(),
      'streetAddress': streetAddressController.text.trim(),
      'Apartment': apartmentController.text.trim(),
      'city': cityController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('order placed successfully')),
    );
  }
}
