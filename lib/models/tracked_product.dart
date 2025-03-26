import 'package:cloud_firestore/cloud_firestore.dart';

class TrackedProduct{
  String imageUrl;
  String title;
  String currentPrice;
  String prevPrice;
  DateTime dateAdded;
  DateTime lastUpdated;
  String productUrl;
  String currentUser;
  String site;

  TrackedProduct({
    required this.imageUrl,
    required this.title,
    required this.currentPrice,
    required this.prevPrice,
    required this.dateAdded,
    required this.lastUpdated,
    required this.productUrl,
    required this.currentUser,
    required this.site,
  });


  Map <String, dynamic> toMap(String docId){
    return {
      "docId" : docId,
      "imageUrl" : imageUrl,
      "title" : title,
      "currentPrice" : currentPrice,
      "prevPrice" : prevPrice,
      "dateAdded" : dateAdded.toIso8601String(),
      "lastUpdated" : lastUpdated.toIso8601String(),
      "productUrl" : productUrl,
      "currentUser" : currentUser,
      "site" : site
    };
  }

  factory TrackedProduct.fromMap(Map<String, dynamic> map) {
    return TrackedProduct(
        imageUrl: map['imageUrl'],
        title: map['title'],
        currentPrice: map['currentPrice'],
        prevPrice: map['prevPrice'],
        productUrl: map['productUrl'],
        dateAdded: (map['dateAdded'] as Timestamp).toDate(),
        lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
        site: map['site'],
        currentUser: map['currentUser']
    );
  }
}