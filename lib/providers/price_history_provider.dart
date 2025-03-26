import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper_price_tracker/services/firebase/firestore_service.dart';

class PriceHistoryProvider with ChangeNotifier{

  final FirestoreService _firestoreService = FirestoreService();

  List<Map<String, dynamic>>? _priceHistory;
  List<Map<String, dynamic>>? get priceHistory => _priceHistory;

  Future <void> fetchPriceHistory() async {
    _priceHistory = await _firestoreService.fetchPriceHistory(FirebaseAuth.instance.currentUser!.email!);
    notifyListeners();
  }
}