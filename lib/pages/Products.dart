import 'package:easyshop/widgets/Product_Card_Widget.dart';
import 'package:flutter/material.dart';
import 'ProductView.dart';
import 'Category.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final TextEditingController _searchController = TextEditingController();
  String selectedCategory = 'All';

  final List<Map<String, dynamic>> categories = [
    {'label': 'All', 'image': 'assets/images/all.png'},
    {'label': 'Shoes', 'image': 'assets/images/shoes.png'},
    {'label': 'Clothes', 'image': 'assets/images/clothes.png'},
    {'label': 'Accessories', 'image': 'assets/images/accessories.png'},
    {'label': 'Electronics', 'image': 'assets/images/phone.png'},
    {'label': 'Makeup', 'image': 'assets/images/makeup.png'},
    {'label': 'Cosmetics', 'image': 'assets/images/cosmetics.png'},
  ];

  List<Map<String, dynamic>> productList = [
    {
      'name': 'Adidas UltraBoost',
      'price': 150,
      'image': 'assets/images/adidas_ultraboost.png',
      'brand': 'Adidas',
      'sizes': ['38', '40', '44'],
      'quantities': [2, 6, 2],
      'desc': 'Stylish and light running shoes.',
      'type': 'Shoes',
      'isInWishlist': false,
    },
    {
      'name': 'Zara Jacket',
      'price': 80,
      'image': 'assets/images/zara_jacket.png',
      'brand': 'Zara',
      'sizes': ['S', 'M', 'L', 'XL'],
      'quantities': [4, 2, 1, 0],
      'desc': 'Winter jacket by Zara.',
      'type': 'Clothes',
      'isInWishlist': false,
    },
    {
      'name': 'Apple Watch',
      'price': 250,
      'image': 'assets/images/apple_watch.png',
      'brand': 'Apple',
      'sizes': [],
      'quantities': [12],
      'desc': 'Smartwatch with fitness tracking.',
      'type': 'Electronics',
      'isInWishlist': false,
    },
    {
      'name': 'Samsung Buds',
      'price': 100,
      'image': 'assets/images/samsung_buds.png',
      'brand': 'Samsung',
      'sizes': [],
      'quantities': [14],
      'desc': 'Wireless earphones with clear sound.',
      'type': 'Electronics',
      'isInWishlist': false,
    },
    {
      'name': 'Huawei P30',
      'price': 220,
      'image': 'assets/images/huawei_p30.png',
      'brand': 'Huawei',
      'sizes': [],
      'quantities': [7],
      'desc': 'Powerful phone with great camera.',
      'type': 'Electronics',
      'isInWishlist': false,
    },
    {
      'name': 'Nike Air Max',
      'price': 120,
      'image': 'assets/images/nike_air_max.png',
      'brand': 'Nike',
      'sizes': ['36', '38', '40', '42'],
      'quantities': [5, 3, 3, 4],
      'desc': 'Comfortable sports shoes by Nike.',
      'type': 'Shoes',
      'isInWishlist': false,
    },
    {
      'name': 'Karen Wazen Glasses',
      'price': 90,
      'image': 'assets/images/karen_wazen_glasses.png',
      'brand': 'Karen Wazen',
      'sizes': [],
      'quantities': [8],
      'desc': 'Trendy designer glasses.',
      'type': 'Accessories',
      'isInWishlist': false,
    },
    {
      'name': 'Aloe Lab Serum',
      'price': 60,
      'image': 'assets/images/aloe_lab_serum.png',
      'brand': 'The Aloe Lab',
      'sizes': [],
      'quantities': [20],
      'desc': 'Skincare serum with aloe vera.',
      'type': 'Cosmetics',
      'isInWishlist': false,
    },
    {
      'name': 'Khouzami Lipstick',
      'price': 45,
      'image': 'assets/images/khouzami_lipstick.png',
      'brand': 'Samer Khouzami',
      'sizes': [],
      'quantities': [9],
      'desc': 'Luxury lipstick with vibrant color.',
      'type': 'Makeup',
      'isInWishlist': false,
    },
    {
      'name': 'Nike T-shirt',
      'price': 30,
      'image': 'assets/images/nike_tshirt.png',
      'brand': 'Nike',
      'sizes': ['XS', 'M', 'XL'],
      'quantities': [3, 7, 5],
      'desc': 'Breathable cotton T-shirt by Nike.',
      'type': 'Clothes',
      'isInWishlist': false,
    },
  ];

  List<Map<String, dynamic>> get filteredProducts {
    return productList.where((product) {
      final matchesSearch = product['name'].toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final matchesCategory =
          selectedCategory == 'All' || product['type'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  void toggleWishlist(int index) {
    setState(() {
      productList[index]['isInWishlist'] = !productList[index]['isInWishlist'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Products")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: "Search Products",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategory = category['label'];
                            });
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(category['image']),
                              ),
                              SizedBox(height: 8),
                              Text(
                                category['label'],
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 9,
                childAspectRatio: 0.6, // Slightly taller
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCardWidget(
                  tag: product['name'],
                  imageURL: product['image'],
                  productName: product['name'],
                  productPrice: product['price'],
                  description: product['desc'],
                  inWishList: product['isInWishlist'], destination: ProductView(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
