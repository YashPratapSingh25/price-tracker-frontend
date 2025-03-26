import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_scraper_price_tracker/models/tracked_product.dart';
import 'package:web_scraper_price_tracker/services/firebase/firestore_service.dart';

class TrackingProvider with ChangeNotifier{
  final FirestoreService _firestoreService = FirestoreService();

  Stream<QuerySnapshot>? _trackedProductsStream;
  Stream<QuerySnapshot>? get trackedProductsStream => _trackedProductsStream;

  List<TrackedProduct>? _trackedProducts;
  List<TrackedProduct>? get trackedProducts => _trackedProducts;

  void fetchTrackedProducts() {
    _trackedProductsStream = _firestoreService.fetchTrackedProducts();
  }

  void searchTrackedProduct(String searchQuery){
    _trackedProducts = _trackedProducts
        ?.where((product) => product.title.toLowerCase() == searchQuery.toLowerCase())
        .toList();
    notifyListeners();
  }
}