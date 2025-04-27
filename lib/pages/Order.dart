import 'package:flutter/material.dart';
import 'package:easyshop/data/constants.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderState();
}

class _OrderState extends State<OrderPage> {
  String paymentMethod = 'cash';
  TextEditingController couponController = TextEditingController();

  final Color primaryBlue = const Color(0xFF2979FF); // a nice soft blue
  final Color background = const Color(0xFFF0F4FF);  // light bluish background

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

            _inputField('First Name*'),
            _inputField('Company Name'),
            _inputField('Street Address*'),
            _inputField('Apartment (optional)'),
            _inputField('Town/City*'),

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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: couponController,
                    decoration: InputDecoration(
                      hintText: 'Coupon Code',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Coupon "${couponController.text}" applied!'),
                      ),
                    );
                  },
                  child: const Text('Apply'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
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
}
