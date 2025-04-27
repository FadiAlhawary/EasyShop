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
  String? paymentMethod;
  List<String> productIds = [];
  List<Map<String, dynamic>> productsData = [];

  final firstNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final streetAddressController = TextEditingController();
  final apartmentController = TextEditingController();
  final cityController = TextEditingController();

  final Color primaryBlue = const Color(0xFF2979FF);
  final Color background = const Color(0xFFF0F4FF);

  @override
  void initState() {
    super.initState();
    _fetchCartProducts();
  }

  Future<void> _fetchCartProducts() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('userId', isEqualTo: userId)
          .get();

      List<String> ids = [];
      List<Map<String, dynamic>> tempProducts = [];

      for (var doc in cartSnapshot.docs) {
        final productId = doc['productId'];
        ids.add(productId);

        // Now fetch product details
        final productSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get();

        if (productSnapshot.exists) {
          tempProducts.add({
            'name': productSnapshot['Name'],
            'price': productSnapshot['Price'],
          });
        }
      }

      setState(() {
        productIds = ids;
        productsData = tempProducts;
      });
    } catch (e) {
      print('Error fetching cart products: $e');
    }
  }

  Future<void> _placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    final cartRef= await FirebaseFirestore.instance.collection('cart').where('userId',isEqualTo: user!.uid).get();
    if (user == null) return; // User not logged in

    if (productIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty!')),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('order').add({
      'userId': user.uid,
      'ProductId': productIds,
      'PaymentMethod': paymentMethod,
      'Date': Timestamp.now(),
      'Name': firstNameController.text.trim(),
      'streetAddress': streetAddressController.text.trim(),
      'Apartment': apartmentController.text.trim(),
      'City': cityController.text.trim(),
      'totalPrice': _calculateTotalPrice(), // Optional total price
    });
     for(var doc in cartRef.docs){
        doc.reference.delete();

     }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully')),
    );
  }

  int _calculateTotalPrice() {
    int total = 0;
    for (var product in productsData) {
      total += (product['price'] as int);
    }
    return total;
  }

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

            const SizedBox(height: 20),
            const Divider(thickness: 1.2),

            const SizedBox(height: 20),
            Text('Products:', style: KStyle.titleTextStyle.copyWith(color: primaryBlue)),
            ...productsData.map((product) => ListTile(
              title: Text(product['name']),
              trailing: Text('\$${product['price']}'),
            )),

            const SizedBox(height: 20),
            const Divider(thickness: 1.2),

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
              onPressed: () async {
                await _placeOrder();
                Navigator.pop(context);
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
}
