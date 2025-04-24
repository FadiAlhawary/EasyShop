import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/widgets/Product_Card_Widget.dart';
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
    {'label': 'Shoes', 'image': 'assets/images/shoes.png'},
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

      body:StreamBuilder(stream: FirebaseFirestore.instance.collection('products').snapshots() , builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Lottie.asset('assets/lotties/empty.json'));
          }
          if(snapshot.hasData){
            final data = snapshot.data!.docs;
            return  Column(

              children: [
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                Expanded(child:  GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 9,
                    childAspectRatio: 0.6, // Slightly taller
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    // var product = filteredProducts[index];
                    var product = data[index].data();
                    return ProductCardWidget(
                      tag: product['Name'],
                      imageURL: product['PhotosURL'][0],
                      productName: product['Name'],
                      productPrice: product['Price'],
                      description: product['Description'],
                      inWishList: false,
                      destination: ProductView(productUID: data[index].id,),
                      isOwner: false,
                    );
                    // return Center(child: Text(product['Name']),);
                  },
                ),
                ),
              ],
            );
          }
          if(snapshot.hasError){
            return Center(child: Text('An error Has Occurred Please try again later'),);
          }
          return Center(child: Text('UNCAUGHT ERROR'),);
      },)
    );
  }
}
