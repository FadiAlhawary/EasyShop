import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> isInWishList(String userUID,String productUID)async{
  try{
    final wishListRef=await FirebaseFirestore.instance.collection('wishList').where('userId' ,isEqualTo: userUID).where('productId',isEqualTo: productUID).get();
    if(wishListRef.docs.isNotEmpty){

        return true;

    }
    else{
      return false;
    }


  }catch(e){
    return false;
    print(e);
  }
}