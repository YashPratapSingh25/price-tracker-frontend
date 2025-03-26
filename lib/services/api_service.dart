import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:web_scraper_price_tracker/models/tracked_product.dart';

class ApiService{
  static const String _baseUrl = "http://10.0.2.2:8000";

  Future<Map<String, dynamic>> fetchData(String searchQuery) async {
    final Uri url = Uri.parse("$_baseUrl/fetch-data/$searchQuery");

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );

      // Handle non-200 responses
      if (response.statusCode != 200) {
        return {"Error": "Server Error: ${response.statusCode}"};
      }

      // Decode response safely
      try {
        return jsonDecode(utf8.decode(response.body.runes.toList()));
      } catch (e) {
        return {"Error": "Invalid JSON response"};
      }
    } on SocketException {
      return {"Error": "No Internet Connection"};
    } on TimeoutException {
      return {"Error": "Request Timed Out"};
    } on HttpException {
      return {"Error": "HTTP Error Occurred"};
    } catch (e) {
      return {"Error": "Unexpected Error: $e"};
    }
  }

  Future <Map<String, dynamic>> fetchDeals() async {
    final Uri uri = Uri.parse("$_baseUrl/fetch-deals/");

    try{
      final response = await http.get(uri);

      if(response.statusCode != 200){
        return {"Error": "Invalid JSON Response"};
      }

      try{
        return jsonDecode(utf8.decode(response.body.runes.toList()));
      }catch (e){
        return {"Error": "Invalid JSON response"};
      }
    } on SocketException {
      return {"Error": "No Internet Connection"};
    } on TimeoutException {
      return {"Error": "Request Timed Out"};
    } on HttpException {
      return {"Error": "HTTP Error Occurred"};
    } catch (e) {
      return {"Error": "Unexpected Error: $e"};
    }
  }

  Future<Map<String, String>> addProduct(String docId, TrackedProduct trackedProduct) async {
    final Uri url = Uri.parse("$_baseUrl/add-product/");

    Map<String, dynamic> trackedProductMap = trackedProduct.toMap(docId);
    
    try {
      final response = await http.post(
        url,
        body: jsonEncode(trackedProductMap),
        headers: {"Content-Type": "application/json"}
      );

      if(response.statusCode != 200){
        return {"Error": "Invalid JSON Response"};
      }

      try{
        Map<String, dynamic> decodedResponse =  jsonDecode(response.body);
        return decodedResponse.cast<String, String>();
      }catch (e) {
        return {"Error": "Invalid JSON Response"};
      }

    } on SocketException {
      return {"Error": "No Internet Connection"};
    } on TimeoutException {
      return {"Error": "Request Timed Out"};
    } on HttpException {
      return {"Error": "HTTP Error Occurred"};
    } catch (e) {
      return {"Error": "Unexpected Error: $e"};
    }
  }

  Future<Map<String, String>> deleteProduct(String docId) async {
    final Uri url = Uri.parse("$_baseUrl/delete-product/$docId/");
    try{
      final response = await http.delete(url);
      
      if(response.statusCode != 200){
        return {"Error" : "Invalid JSON Response"};
      }
      
      try{
        Map<String, dynamic> decodedResponse =  jsonDecode(response.body);
        return decodedResponse.cast<String, String>();
      }catch (e){
        return {"Error" : "Invalid JSON Response"};
      }
    } on SocketException {
      return {"Error": "No Internet Connection"};
    } on TimeoutException {
      return {"Error": "Request Timed Out"};
    } on HttpException {
      return {"Error": "HTTP Error Occurred"};
    } catch (e) {
      return {"Error": "Unexpected Error: $e"};
    }
  }
  
  Future <Map<String, dynamic>> isProductTracked(String docId) async {
    final Uri url = Uri.parse("$_baseUrl/is-product-tracked/$docId/");
    try{
      final response = await http.get(url);

      if(response.statusCode != 200){
        return {"Error": "Invalid JSON Response"};
      }

      try{
        return jsonDecode(utf8.decode(response.body.runes.toList()));
      }catch (e){
        return {"Error" : "Invalid JSON Response"};
      }
    } on SocketException {
      return {"Error": "No Internet Connection"};
    } on TimeoutException {
      return {"Error": "Request Timed Out"};
    } on HttpException {
      return {"Error": "HTTP Error Occurred"};
    } catch (e) {
      return {"Error": "Unexpected Error: $e"};
    }
  }

  Future <Map<String, dynamic>> addProductByLink(String productUrl, String currentUser) async {
    final Uri url = Uri.parse("$_baseUrl/add-product-by-link/");
    try{
      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "productUrl" : productUrl,
            "currentUser" : currentUser
          })
      );

      if(response.statusCode != 200){
        return {"Error": "Invalid JSON Response"};
      }

      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {"Error": "Invalid JSON response"};
      }
    }  on SocketException {
      return {"Error": "No Internet Connection"};
    } on TimeoutException {
      return {"Error": "Request Timed Out"};
    } on HttpException {
      return {"Error": "HTTP Error Occurred"};
    } catch (e) {
      return {"Error": "Unexpected Error: $e"};
    }
  }
  
  Future <Map<String, dynamic>> fetchLatestPrice(String userId) async {
    try {
      final Uri url = Uri.parse("$_baseUrl/fetch-latest-price-from-app/");

      final response = await http.patch(
        url,
        headers: {"Content-Type" : "application/json"},
        body: jsonEncode({
          "userId" : userId
        })
      );

      if(response.statusCode != 200){
        return {"Error" : "Invalid JSON Response"};
      }

      try{
        return jsonDecode(response.body);
      }catch (e) {
        return {"Error" : "Invalid JSON Response"};
      }
    } on SocketException {
      return {"Error": "No Internet Connection"};
    } on TimeoutException {
      return {"Error": "Request Timed Out"};
    } on HttpException {
      return {"Error": "HTTP Error Occurred"};
    } catch (e) {
      return {"Error": "Unexpected Error: $e"};
    }
  }

  Future <List<Map<String, dynamic>>> fetchPriceHistory(String userId) async{
    try{
      final Uri url = Uri.parse("$_baseUrl/fetch-price-history/$userId/");

      final response = await http.get(url, headers: {"Content-Type" : "application/json"});

      if(response.statusCode != 200){
        return [{"Error" : "Invalid JSON Response"}];
      }

      try{
        final jsonResponse = jsonDecode(response.body) as List;
        return jsonResponse.cast<Map<String, dynamic>>();
      } catch (e) {
        return [{"Error" : "Invalid JSON Response"}];
      }
    }on SocketException {
      return [
        {"Error": "No Internet Connection"}
      ];
    } on TimeoutException {
      return [
        {"Error": "Request Timed Out"}
      ];
    } on HttpException {
      return [
        {"Error": "HTTP Error Occurred"}
      ];
    } catch (e) {
      return [
        {"Error": "Unexpected Error: $e"}
      ];
    }
  }

  Future <Map<String, dynamic>> updateToken(String fcmToken) async {
    final Uri url = Uri.parse("$_baseUrl/update-token/");
    try{
      final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "token" : fcmToken,
          })
      );

      if(response.statusCode != 200){
        return {"Error": "Invalid JSON Response"};
      }

      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {"Error": "Invalid JSON response"};
      }
    }  on SocketException {
      return {"Error": "No Internet Connection"};
    } on TimeoutException {
      return {"Error": "Request Timed Out"};
    } on HttpException {
      return {"Error": "HTTP Error Occurred"};
    } catch (e) {
      return {"Error": "Unexpected Error: $e"};
    }
  }

}