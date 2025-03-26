import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_scraper_price_tracker/providers/deals_provider.dart';
import 'package:web_scraper_price_tracker/providers/price_history_provider.dart';
import 'package:web_scraper_price_tracker/providers/tracking_provider.dart';
import 'package:web_scraper_price_tracker/services/authentication/auth_state_helper.dart';
import 'package:web_scraper_price_tracker/services/firebase/fcm_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initNotifications();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DealsProvider(),),
        ChangeNotifierProvider(create: (context) => TrackingProvider(),),
        ChangeNotifierProvider(create: (context) => PriceHistoryProvider(),),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void didChangeDependencies() {
    final dealsProvider = Provider.of<DealsProvider>(context, listen: false);
    final trackingProvider = Provider.of<TrackingProvider>(context, listen: false);
    final priceHistoryProvider = Provider.of<PriceHistoryProvider>(context, listen: false);
    if(dealsProvider.fetchedDeals == null){
      dealsProvider.fetchDeals();
    }
    if(FirebaseAuth.instance.currentUser != null && trackingProvider.trackedProductsStream == null){
      trackingProvider.fetchTrackedProducts();
    }
    if(FirebaseAuth.instance.currentUser != null && priceHistoryProvider.priceHistory == null){
      priceHistoryProvider.fetchPriceHistory();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthStateHelper(),
    );
  }
}
