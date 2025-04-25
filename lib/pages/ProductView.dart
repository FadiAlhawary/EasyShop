import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/data/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProductView extends StatefulWidget {


  const ProductView({super.key, required this.productUID});
  final String productUID;

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String? selectedSize;
  TextEditingController commentController = TextEditingController();
  double rating = 0;
 bool isInWishlist=false;
  bool isLoggedIn = true;
  List<Map<String, dynamic>> reviews = [];
  //----------------------------------------Adding reviews----------------------------------------
 Future<void> addReviews()async{
    try{
      final userUID = FirebaseAuth.instance.currentUser!.uid;
      final currentProduct = FirebaseFirestore.instance.collection('products').doc(widget.productUID);
        if(commentController.text.isNotEmpty) {
           currentProduct.collection('reviews').doc(userUID).set({
              'rating':rating,
              'comment':commentController.text.trim(),
           });
        }
    }catch(e){
      print(e);
    }

 }
  @override
  Widget build(BuildContext context) {
    // final product = widget.product;
    //

    return Scaffold(
      appBar: AppBar(
        title: Text("product['Name']",style: KStyle.titleTextStyle,),
        centerTitle: true,
        //backgroundColor: Colors.grey[800],
      ),
      body:StreamBuilder(stream: 
          FirebaseFirestore.instance.collection('products').doc(widget.productUID).snapshots()
          , builder: (context, snapshot) {
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child:CircularProgressIndicator(),);
                }

  if (snapshot.data == null || !snapshot.data!.exists) {
    return Center(child: Lottie.asset('assets/lotties/empty.json'));//cahnge lottie
    }
  if(snapshot.hasData){
    final product = snapshot.data!.data() as Map<String, dynamic>;
    final hasSizes = product['Size'] != null && product['Size'].isNotEmpty;

    return  SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: product['Name'],
            child: Image.network(
              product['PhotosURL'][0],
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 20),

          Text(
            product['Name'],
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            "\$${product['Price']}",
            style: const TextStyle(
              fontSize: 22,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          Text(
            product['Description'],
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          IconButton(
            icon: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              color:
              isInWishlist
                  ? Colors.red
                  : const Color.fromARGB(255, 171, 170, 170),
              size: 32,
            ),
            onPressed: () {
              setState(() {
                isInWishlist = !isInWishlist;
              });
            },
          ),
          const SizedBox(height: 20),

          if (hasSizes) ...[
            const Text(
              "Available Sizes:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Wrap(
            //   spacing: 10,
            //   children: List.generate(product['size'].length, (index) {
            //     final sizes = product['Size'] as List<dynamic>? ?? [];
            //     final size = sizes[index];
            //     final qty = product['Quantity'];
            //     return ChoiceChip(
            //       label: Text(
            //         '$size ($qty)',
            //         style: const TextStyle(color: Colors.blue),
            //       ),
            //       selected: selectedSize == size,
            //       onSelected: (_) {
            //         setState(() {
            //           selectedSize = size;
            //         });
            //       },
            //       selectedColor: Colors.blueAccent,
            //       labelStyle: const TextStyle(color: Colors.white),
            //     );
            //   }),
            // ),
            const SizedBox(height: 20),
          ],

          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart),
            label: const Text("Add to Cart"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(200, 50),
              backgroundColor: const Color.fromARGB(255, 171, 170, 170),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),

          if (isLoggedIn) ...[
            const Text(
              "Add a Comment and Rate",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: commentController,
              decoration: const InputDecoration(
                hintText: "Write your comment here",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 8),
//----------------------------------------Adding review button----------------------------------------
            ElevatedButton(
              onPressed: () {
               addReviews();
               commentController.clear();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                backgroundColor: const Color.fromARGB(255, 171, 170, 170),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Text("Submit Review"),
            ),
            const SizedBox(height: 20),
          ] else ...[
            const Text(
              "Please log in to leave a comment or rating.",
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ],
          const Divider(),

          const Text(
            "Ratings & Reviews",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
//----------------------------------------Reviews----------------------------------------
       StreamBuilder(stream: FirebaseFirestore.instance.collection('products').doc(widget.productUID).collection('reviews').snapshots(), builder: (context, snapshot) {
         if(snapshot.connectionState==ConnectionState.waiting){
           return Center(child:CircularProgressIndicator(),);
         }

         if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
           return Center(child: Lottie.asset('assets/lotties/emptyComment.json'));//cahnge lottie
         }
         if(snapshot.hasData){
           final reviewsData = snapshot.data!.docs;


           return    ListView.builder(

             shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(),
             itemCount: reviewsData.length,
             itemBuilder: (context, index) {
               var review =reviewsData[index].data();
            final userId = reviewsData[index].id;
               return Padding(
                 padding: const EdgeInsets.only(bottom: 16.0),
                 child: Card(
                   elevation: 5,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(8),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(12.0),

                     child: StreamBuilder(stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(), builder:(context, snapshot) {
                       if(snapshot.connectionState==ConnectionState.waiting){
                         return Center(child:CircularProgressIndicator(),);
                       }
                        if(snapshot.hasData){
                          final userData = snapshot.data!.data();

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: userData!['profileImageUrl'] == ''? AssetImage('assets/images/noPerson.jpg') : NetworkImage(userData!['profileImageUrl']),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${userData!['Name']}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: List.generate(5, (starIndex) {
                                        return Icon(
                                          starIndex < review['rating']
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 20,
                                        );
                                      }),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      review['comment'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }

                       if(snapshot.hasError){
                         return Center(child: Text('An error while fetching the data has occurred'),);
                       }
                       return Center(child: Text('An error data has occurred'),);
                     },

                 ),
                   ),
                 ),
               );
             },
           );
         }
         if(snapshot.hasError){
           return Center(child: Text('An error while fetching the data has occurred'),);
         }
         return Center(child: Text('An error data has occurred'),);
       },),
        ],
      ),
    );
  }
  if(snapshot.hasError){
    return Center(child: Text('An error while fetching the data has occurred'),);
  }
                return Center(child: Text('An error data has occurred'),);



          },)
    );
  }
}
