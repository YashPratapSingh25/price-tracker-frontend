import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper_price_tracker/services/firebase/firestore_service.dart';
import '../models/tracked_product.dart';
import '../providers/price_history_provider.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  final ValueNotifier<bool> _isTracking = ValueNotifier<bool>(false);

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final PriceHistoryProvider provider = Provider.of<PriceHistoryProvider>(context, listen: false);
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.product["image"],
                  width: 120,
                  height: 120,
                ),
              ),
              const SizedBox(width: 15),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      widget.product["title"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),

                    // Price
                    Text(
                      "₹${widget.product["price"]}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Buttons
                    Row(
                      children: [
                        FutureBuilder(
                          future: firestoreService.isProductTracked(widget.product["title"], widget.product["site"]),
                          builder:(context, snapshot) {
                            _isTracking.value = snapshot.data ?? false;
                            return Expanded(
                              child: ValueListenableBuilder<bool>(
                                valueListenable: _isTracking,
                                builder: (context, isTrackingValue, child) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      _isTracking.value = !isTrackingValue;
                                      if(_isTracking.value){
                                        TrackedProduct product = TrackedProduct(
                                            imageUrl: widget.product["image"],
                                            title: widget.product["title"],
                                            currentPrice: widget.product["price"],
                                            prevPrice: widget.product["price"],
                                            productUrl: widget.product["link"],
                                            dateAdded: DateTime.now(),
                                            lastUpdated: DateTime.now(),
                                            site: widget.product["site"],
                                            currentUser: FirebaseAuth.instance.currentUser!.email!
                                        );
                                        firestoreService.addProduct(product);
                                        provider.fetchPriceHistory();
                                      }else{
                                        firestoreService.deleteProduct(widget.product["title"], widget.product["site"]);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isTrackingValue ? Colors.deepPurple : Colors.deepPurple[400],
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      minimumSize: const Size(100, 45),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.track_changes, size: 18, color: Colors.white),
                                        const SizedBox(width: 6),
                                        Text(
                                          isTrackingValue ? "Tracking" : "Track",
                                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        ),
                        const SizedBox(width: 10),

                        // Buy Now Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              launchUrl(
                                Uri.parse(widget.product["link"]),
                                mode: LaunchMode.inAppWebView,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(100, 45), // Ensures enough space for text
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Prevents extra spacing
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.shopping_cart, size: 18, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  widget.product["site"] == "Amazon" ? "Amazon" : "Flipkart",
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
