import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:web_scraper_price_tracker/services/api_service.dart';

class NotificationService{
  final _firebaseMessaging = FirebaseMessaging.instance;
  String? fcmToken;

  Future <void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    fcmToken = await _firebaseMessaging.getToken();
    ApiService().updateToken(fcmToken!);
  }
}
