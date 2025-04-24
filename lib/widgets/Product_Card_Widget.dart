import 'package:easyshop/data/Constants.dart';
import 'package:flutter/material.dart';
class ProductCardWidget extends StatefulWidget {
  const ProductCardWidget({super.key,
    required this.tag,
    required this.imageURL,
    required this.productName,
    required this.productPrice,
    required this.description,
    required this.inWishList,
    required this.destination,
    required this.isOwner,
  });
  final String tag;
  final String imageURL;
  final String productName;
  final String productPrice;
  final String description;
  final bool inWishList;
  final Widget destination;
  final bool isOwner;
  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => widget.destination,));
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
                      child: Image.network(
                        widget.imageURL,
                        height: 120, // Smaller image height
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
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
                          style: KStyle.normalTextStyle
                          ),


                    ],
                  ),
                ),
                !widget.isOwner
                    ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      widget.inWishList ? Icons.favorite : Icons.favorite_border,
                      color: widget.inWishList ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      // Handle favorite toggle
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
