import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper_price_tracker/models/tracked_product.dart';
import 'package:web_scraper_price_tracker/providers/price_history_provider.dart';
import 'package:web_scraper_price_tracker/services/firebase/firestore_service.dart';

class DealCard extends StatefulWidget {
  final Map<String, dynamic> deal;
  const DealCard({super.key, required this.deal});

  @override
  State<DealCard> createState() => _DealCardState();
}

class _DealCardState extends State<DealCard> {
  final FirestoreService firestoreService = FirestoreService();


  // Using ValueNotifier to manage the tracking state
  final ValueNotifier<bool> _isTracking = ValueNotifier<bool>(false);

  int calculateDiscount(String prevPrice, String currPrice) {
    int previous = int.parse(prevPrice.replaceAll(',', ''));
    int current = int.parse(currPrice.replaceAll(',', ''));
    return ((previous - current) * 100 ~/ previous);
  }

  @override
  Widget build(BuildContext context) {
    final PriceHistoryProvider provider = Provider.of<PriceHistoryProvider>(context, listen: false);
    int discount = calculateDiscount(widget.deal["previous_price"], widget.deal["current_price"]);
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.deal["image"],
                    width: 120,
                    height: 120,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                if (discount > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "-$discount%",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 15),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    widget.deal["title"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),

                  // Price and Discount
                  Row(
                    children: [
                      Text(
                        "₹${widget.deal["current_price"]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "₹${widget.deal["previous_price"]}",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Buttons
                  Row(
                    children: [
                      FutureBuilder(
                        future: firestoreService.isProductTracked(widget.deal["title"], "Amazon"),
                        builder: (context, snapshot) {
                          _isTracking.value = snapshot.data ?? false;
                          return ValueListenableBuilder(
                            valueListenable: _isTracking,
                            builder: (context, isTrackingValue, child) {
                              return ElevatedButton(
                                onPressed: () {
                                  if(!isTrackingValue){
                                    TrackedProduct trackedProduct = TrackedProduct(
                                      imageUrl: widget.deal["image"],
                                      title: widget.deal["title"],
                                      currentPrice: widget.deal["current_price"],
                                      prevPrice: widget.deal["current_price"],
                                      productUrl: widget.deal["link"],
                                      dateAdded: DateTime.now(),
                                      lastUpdated: DateTime.now(),
                                      site: "Amazon",
                                      currentUser: FirebaseAuth.instance.currentUser!.email!,
                                    );
                                    firestoreService.addProduct(trackedProduct);
                                    provider.fetchPriceHistory();
                                  }else{
                                    firestoreService.deleteProduct(widget.deal["title"], "Amazon");
                                  }
                                  _isTracking.value = !isTrackingValue;
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
                          );
                        },
                      ),


                      const SizedBox(width: 10),

                      // Buy Now Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            launchUrl(
                              Uri.parse(widget.deal["link"]),
                              mode: LaunchMode.inAppWebView,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minimumSize: const Size(100, 45),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_cart, size: 18, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                "Buy Now",
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

