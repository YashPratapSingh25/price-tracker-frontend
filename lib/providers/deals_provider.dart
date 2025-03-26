import 'package:flutter/cupertino.dart';
import 'package:web_scraper_price_tracker/services/api_service.dart';

class DealsProvider with ChangeNotifier{
  final ApiService _apiService = ApiService();

  Map <String, dynamic>? _fetchedDeals;

  Map<String, dynamic>? get fetchedDeals => _fetchedDeals;

  void fetchDeals() async {
    _fetchedDeals = await _apiService.fetchDeals();
    print("Deals arrived");
    notifyListeners();
  }
}