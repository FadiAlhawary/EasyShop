import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductView({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  String? selectedSize;
  TextEditingController commentController = TextEditingController();
  double rating = 0;
  bool isInWishlist = false;
  bool isLoggedIn = true;
  List<Map<String, dynamic>> reviews = [];

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasSizes = product['sizes'] != null && product['sizes'].isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        backgroundColor: Colors.grey[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: product['name'],
              child: Image.asset(
                product['image'],
                height: 250,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              product['name'],
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            Text(
              "\$${product['price']}",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            Text(
              product['desc'],
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
              Wrap(
                spacing: 10,
                children: List.generate(product['sizes'].length, (index) {
                  final size = product['sizes'][index];
                  final qty = product['quantities'][index];
                  return ChoiceChip(
                    label: Text(
                      '$size ($qty)',
                      style: const TextStyle(color: Colors.blue),
                    ),
                    selected: selectedSize == size,
                    onSelected: (_) {
                      setState(() {
                        selectedSize = size;
                      });
                    },
                    selectedColor: Colors.blueAccent,
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                }),
              ),
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

              ElevatedButton(
                onPressed: () {
                  if (commentController.text.isNotEmpty) {
                    setState(() {
                      reviews.add({
                        'comment': commentController.text,
                        'rating': rating,
                      });
                      commentController.clear();
                      rating = 0;
                    });
                  }
                },
                child: const Text("Submit Review"),
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

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                var review = reviews[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User ${index + 1}",
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
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
