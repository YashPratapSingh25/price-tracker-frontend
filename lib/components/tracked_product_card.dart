import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper_price_tracker/pages/tracked_product_history.dart';
import 'package:web_scraper_price_tracker/services/firebase/firestore_service.dart';
import '../models/tracked_product.dart';

class TrackedProductCard extends StatefulWidget {
  final TrackedProduct trackedProduct;
  const TrackedProductCard({super.key, required this.trackedProduct});

  @override
  State<TrackedProductCard> createState() => _TrackedProductCardState();
}

class _TrackedProductCardState extends State<TrackedProductCard> {

  final FirestoreService firestoreService = FirestoreService();

  String formatLastUpdated(DateTime lastUpdated) {
    return DateFormat('dd MMM yy, hh:mm a').format(lastUpdated);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14, left: 14, right: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.trackedProduct.imageUrl,
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
                      Text(
                        widget.trackedProduct.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            "₹${widget.trackedProduct.currentPrice}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: widget.trackedProduct.currentPrice == widget.trackedProduct.prevPrice ?
                                  Colors.deepPurple :
                                  double.parse(widget.trackedProduct.currentPrice.replaceAll(",", "")) < double.parse(widget.trackedProduct.prevPrice.replaceAll(",", "")) ?
                                      Colors.green : Colors.red
                            ),
                          ),
                          const SizedBox(width: 6),
                          if(widget.trackedProduct.currentPrice != widget.trackedProduct.prevPrice)
                            Text(
                              "₹${widget.trackedProduct.prevPrice}",
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              setState(() {
                                firestoreService.deleteProduct(widget.trackedProduct.title, widget.trackedProduct.site);
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(90, 45),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.delete, size: 18),
                                SizedBox(width: 6,),
                                Text(
                                  "Untrack",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10,),
                          ElevatedButton(
                            onPressed: (){
                              launchUrl(
                                Uri.parse(widget.trackedProduct.productUrl),
                                mode: LaunchMode.inAppWebView
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              minimumSize: const Size(90, 45),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_cart, size: 18),
                                SizedBox(width: 6,),
                                Text(
                                  "Buy Now",
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                              ],
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
          const SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Last tracked : ",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
              ),
              Text(
                " ${formatLastUpdated(widget.trackedProduct.lastUpdated)}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.end,
              ),
            ],
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TrackedProductHistory(trackedProduct: widget.trackedProduct,),)),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: const Text(
                "See Price History",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
