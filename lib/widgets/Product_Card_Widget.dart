import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/data/Constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProductCardWidget extends StatefulWidget {
  const ProductCardWidget({
    super.key,
    required this.tag,
    required this.imageURL,
    required this.productName,
    required this.productPrice,
    required this.description,

    required this.destination,
    required this.isOwner,
    required this.productUID,
    required this.userUID,
  });
  final String userUID;
  final String productUID;
  final String tag;
  final String imageURL;
  final String productName;
  final int productPrice;
  final String description;
  final Widget destination;
  final bool isOwner;
  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  bool inWishList = false;
  bool isLoading = false;
  //----------------------------------------isInWishList----------------------------------------
  Future<void> isInWishList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final wishListRef =
          await FirebaseFirestore.instance
              .collection('wishList')
              .where('userId', isEqualTo: widget.userUID)
              .where('productId', isEqualTo: widget.productUID)
              .get();
      if (wishListRef.docs.isNotEmpty) {
        setState(() {
          inWishList = true;
        });
      } else {
        inWishList = false;
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //----------------------------------------toWishList----------------------------------------
  Future<void> toWishList() async {
    try {
      final wishListRef = await FirebaseFirestore.instance.collection(
        'wishList',
      );

      if (!inWishList) {
        await wishListRef.add({
          'userId': widget.userUID,
          'productId': widget.productUID,
        });
      } else {
        final productRef =
            await wishListRef
                .where('userId', isEqualTo: widget.userUID)
                .where('productId', isEqualTo: widget.productUID)
                .get();
        for (var doc in productRef.docs) {
          await doc.reference.delete();
        }
        setState(() {
          inWishList = false;
        });
      }
      isInWishList();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    isInWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: Lottie.asset('assets/lotties/loading.json'))
        : GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.destination),
            );
          },
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Hero(
                    tag: widget.tag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          widget.imageURL.isNotEmpty
                              ? Image.network(
                                widget.imageURL,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // If there's a problem loading the image (like no internet)
                                  return Image.asset(
                                    'assets/images/no-connection.jpg', // <-- your offline image
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                              : Image.asset(
                                'assets/images/No_Image_Available.jpg', // when imageURL itself is empty
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.productName,
                        style: KStyle.normalTextStyle
                      ),
                      SizedBox(height: 10),
                      Text(
                        "\$${widget.productPrice}",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: KStyle.normalTextStyle,
                      ),
                    ],
                  ),
                ),
                !widget.isOwner
                    ? Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          inWishList ? Icons.favorite : Icons.favorite_border,
                          color: inWishList ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          toWishList();
                        },
                      ),
                    )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        );
  }
}
