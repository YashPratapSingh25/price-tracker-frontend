import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:web_scraper_price_tracker/models/tracked_product.dart';
import 'package:web_scraper_price_tracker/services/api_service.dart';

class FirestoreService{

  final ApiService _apiService = ApiService();
  
  String _encode(String name, String site){
    final encodedString = "$name $site";
    return encodedString.replaceAll(" ", "_").replaceAll("/", "`");
  }

  final CollectionReference _trackedProducts = FirebaseFirestore.instance.collection("tracked_products");

  Future <void> addProduct(TrackedProduct product) async {
    try {
      final doc = _encode(product.title, product.site);
      await _apiService.addProduct(doc, product);

    } catch (e) {
      rethrow;
    }
  }

  Future <void> deleteProduct(String title, String site) async {
    try {
      final doc = _encode(title, site);
      await _apiService.deleteProduct(doc);
    } catch (e) {
      rethrow;
    }
  }

  Future <bool> isProductTracked(String title, String site) async {
    try {
      final doc = _encode(title, site);
      final jsonResponse =  await _apiService.isProductTracked(doc);
      return jsonResponse["result"] as bool;
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Object?>> fetchTrackedProducts() {
    return _trackedProducts
        .orderBy("dateAdded", descending: true)
        .where("currentUser", isEqualTo: FirebaseAuth.instance.currentUser!.email!)
        .snapshots();
  }

  Future <String> addProductByLink(String url, String currentUser) async {
    final jsonResponse = await _apiService.addProductByLink(url, currentUser);
    if(jsonResponse.containsKey("Error")){
      return jsonResponse["Error"]!;
    }
    return jsonResponse["result"]!;
  }

  Future <void> fetchLatestPrice(String userId) async {
    final jsonResponse = await _apiService.fetchLatestPrice(userId);
    if(jsonResponse.containsKey("Error")){
      print(jsonResponse["Error"]);
    }
    print(jsonResponse["result"]);
  }

  Future <List<Map<String, dynamic>>> fetchPriceHistory(String userId) async {
    final jsonResponse = await _apiService.fetchPriceHistory(userId);
    return jsonResponse;
  }

}