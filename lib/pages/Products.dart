import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/widgets/Product_Card_Widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    {'label': 'Shoes', 'image': 'assets/images/shoes1.png'},
    {'label': 'Clothes', 'image': 'assets/images/clothes.png'},
    {'label': 'Accessories', 'image': 'assets/images/accessories.png'},
    {'label': 'Electronics', 'image': 'assets/images/phone.png'},
    {'label': 'Makeup', 'image': 'assets/images/makeup.png'},
    {'label': 'Cosmetics', 'image': 'assets/images/cosmetics.png'},
  ];

  // List<Map<String, dynamic>> get filteredProducts {
  //   return productList.where((product) {
  //     final matchesSearch = product['name'].toLowerCase().contains(
  //       _searchController.text.toLowerCase(),
  //     );
  //     final matchesCategory =
  //         selectedCategory == 'All' || product['type'] == selectedCategory;
  //     return matchesSearch && matchesCategory;
  //   }).toList();
  // }
  //
  // void toggleWishlist(int index) {
  //   setState(() {
  //     productList[index]['isInWishlist'] = !productList[index]['isInWishlist'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Lottie.asset('assets/lotties/empty.json'));
          }

          if (snapshot.hasData) {
            final data = snapshot.data!.docs;

            final filteredData =
                data.where((doc) {
                  var product = doc.data();

                  bool matchesSearch = product['Name']
                      .toString()
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());

                  bool matchesCategory =
                      selectedCategory == 'All' ||
                      product['Category'].toString().toLowerCase() ==
                          selectedCategory.toLowerCase();

                  return matchesSearch && matchesCategory;
                }).toList();

            return Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(20.0),
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

                // Categories filter bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          categories.map((category) {
                            bool isSelected =
                                category['label'] == selectedCategory;

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
                                      radius: isSelected ? 34 : 30,
                                      backgroundColor:
                                          isSelected
                                              ? Colors.grey.shade300
                                              : Colors.transparent,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                          category['image'],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      category['label'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? Colors.black
                                                : Colors.grey.shade700,
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

                // Product grid
                Expanded(
                  child:
                      filteredData.isEmpty
                          ? Center(
                            child: Lottie.asset('assets/lotties/empty.json'),
                          )
                          : GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.5,
                                ),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              var product = filteredData[index].data();

                              return ProductCardWidget(
                                tag: product['Name'],
                                imageURL: product['PhotosURL'][0],
                                productName: product['Name'],
                                productPrice: product['Price'],
                                description: product['Description'],
                                destination: ProductView(
                                  productUID: filteredData[index].id,
                                ),
                                productUID: filteredData[index].id,
                                userUID: FirebaseAuth.instance.currentUser!.uid,
                                isOwner: false,
                              );
                            },
                          ),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('An error has occurred. Please try again later.'),
            );
          }

          return Center(child: Text('UNCAUGHT ERROR'));
        },
      ),
    );
  }
}
