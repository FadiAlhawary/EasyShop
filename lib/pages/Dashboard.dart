import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/data/Constants.dart';
import 'package:easyshop/pages/ProductView.dart';
import 'package:easyshop/widgets/Product_Card_Widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


 class Dashboard extends StatefulWidget {
   const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //----------------------------------------Controllers----------------------------------------
 bool isLoading=false;
 List<Map<String, dynamic>> products = [];

  //----------------------------------------Fetching user Products----------------------------------------
     Future<void> getData()async{
       setState(() {
         isLoading=true;
       });
       try{
         final userUID = await FirebaseAuth.instance.currentUser!.uid;
         final productsCollection=await FirebaseFirestore.instance.collection('products').where("UserID",isEqualTo: userUID).get();
  setState(() {
    products = productsCollection.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  });
  print(products.toString());
            }catch(e){
              print(e);
            }finally{
         setState(() {
           isLoading=false;
         });
       }
     }
     @override
  void initState() {
    // TODO: implement initState
    getData();
       super.initState();
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(),
       body: StreamBuilder(stream:
         FirebaseFirestore.instance.collection('products').where('UserID',isEqualTo:FirebaseAuth.instance.currentUser!.uid ).snapshots()
         , builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child:  CircularProgressIndicator());
              }
              if(snapshot.hasData){
                final data = snapshot.data!.docs;
                print('Snapchot data -----------------------------------------------------');

                print(data);
                print('end=================================================================');
                return GridView.builder(  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 9,
                  childAspectRatio: 0.6, // Slightly taller
                ),
              itemCount: data.length,
                    itemBuilder: (context, index) {
                      var product = data[index].data() as Map<String, dynamic>;
                      if (product != null &&
                          product['PhotosURL'] != null &&
                          product['PhotosURL'] is List &&
                          product['PhotosURL'].isNotEmpty) {
                        print(product['PhotosURL'][0]);
                      } else {
                        print("No image available.");
                      }
      return ProductCardWidget(tag: product['Name'] , imageURL: product['PhotosURL'][0] , productName: product['Name'], productPrice: product['Price'], description: product['Description'], inWishList: false, destination: ProductView(product: product));
                   // return Center(child: Text(product['Name']),);
                    },);
              }
              if(snapshot.hasError){
                return Center(child: Text('ERROR OCCURRED' ,style: KStyle.errorMessageTextStyle,),);
              }
              return Center(child: Text('ERROR Fetching the data' ,style: KStyle.errorMessageTextStyle,),);

         },)

     );
   }
}
