import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_scraper_price_tracker/components/app_bar.dart';
import 'package:web_scraper_price_tracker/components/deals_list.dart';
import 'package:web_scraper_price_tracker/components/scrap_text_field.dart';
import 'package:web_scraper_price_tracker/pages/results_screen.dart';
import 'package:web_scraper_price_tracker/providers/deals_provider.dart';
import 'package:web_scraper_price_tracker/providers/price_history_provider.dart';
import 'package:web_scraper_price_tracker/services/api_service.dart';
import 'package:web_scraper_price_tracker/services/authentication/auth_service.dart';
import '../providers/tracking_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final apiService = ApiService();
  Map<String, dynamic>? json;

  @override
  void initState() {
    final trackingProvider = Provider.of<TrackingProvider>(context, listen: false);
    final priceHistoryProvider = Provider.of<PriceHistoryProvider>(context, listen: false);
    if(trackingProvider.trackedProductsStream == null){
      trackingProvider.fetchTrackedProducts();
    }
    if(priceHistoryProvider.priceHistory == null){
      priceHistoryProvider.fetchPriceHistory();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Price Tracker"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              ScrapTextField(
                onScrap: (result) => {
                  setState(() {
                    json = result;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResultsScreen(json: json!,),));
                  })
                },
              ),
              const SizedBox(height: 30,),
              const Text(
                "Today's Hot Deals 🔥",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                ),
              ),
              Consumer<DealsProvider>(
                builder: (context, dealsProvider, child) {
                  if(dealsProvider.fetchedDeals == null){
                    return const SizedBox(
                      height: 500,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            Text("Fetching hot deals for you", style: TextStyle(fontSize: 18),)
                          ],
                        ),
                      ),
                    );
                  }else if(dealsProvider.fetchedDeals!["deals"] == null){
                    return SizedBox(
                      height: 500,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Error fetching deals!", style: TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold),),
                            TextButton(
                              onPressed: dealsProvider.fetchDeals,
                              child: const Text(
                                "Retry",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return DealsList(deals: dealsProvider.fetchedDeals!["deals"]);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}