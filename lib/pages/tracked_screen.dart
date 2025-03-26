import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_scraper_price_tracker/components/app_bar.dart';
import 'package:web_scraper_price_tracker/components/tracked_product_card.dart';
import 'package:web_scraper_price_tracker/components/tracking_fab.dart';
import 'package:web_scraper_price_tracker/providers/tracking_provider.dart';
import 'package:web_scraper_price_tracker/services/firebase/firestore_service.dart';
import '../components/search_text_field.dart';
import '../models/tracked_product.dart';

class TrackedScreen extends StatefulWidget {
  const TrackedScreen({super.key});

  @override
  State<TrackedScreen> createState() => _TrackedScreenState();
}

class _TrackedScreenState extends State<TrackedScreen> {
  final firestoreService = FirestoreService();
  String query = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Tracked Products"),
      body: RefreshIndicator(
        onRefresh: () async {
          await firestoreService.fetchLatestPrice(FirebaseAuth.instance.currentUser!.email!);
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          children: [
            const SizedBox(height: 25),
            const Text(
              "Your Tracked Products 🛒",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SearchTextField(
              onSearch: (searchQuery) {
                setState(() {
                  query = searchQuery;
                });
              },
            ),
            const SizedBox(height: 20),
            Consumer<TrackingProvider>(
              builder: (context, trackingProvider, child) {
                return StreamBuilder<QuerySnapshot>(
                  stream: trackingProvider.trackedProductsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error occurred when fetching tracked products"),
                      );
                    }

                    List<TrackedProduct>? trackedProducts = snapshot.data?.docs
                        .map((doc) => TrackedProduct.fromMap(doc.data() as Map<String, dynamic>))
                        .toList();

                    if (query.isNotEmpty) {
                      trackedProducts = trackedProducts?.where(
                            (product) => product.title.toLowerCase().contains(query.toLowerCase()),
                      ).toList();
                    }

                    if (trackedProducts == null) return const Placeholder();

                    if (trackedProducts.isEmpty) {
                      return const Center(
                        child: Text("No tracked products", style: TextStyle(fontSize: 18)),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: trackedProducts?.length,
                      itemBuilder: (context, index) {
                        return TrackedProductCard(trackedProduct: trackedProducts![index]);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: const TrackingFab(),
    );
  }

}
