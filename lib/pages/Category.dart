import 'package:flutter/material.dart';

class Category extends StatelessWidget {
  const Category({
    super.key,
    required List<Map<String, dynamic>> Categories,
    required String selectedCategory,
    required void Function(String category) onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Center(child: Text('Category')));
  }
}
