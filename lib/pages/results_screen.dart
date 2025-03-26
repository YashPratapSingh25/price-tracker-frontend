import 'package:flutter/material.dart';
import 'package:web_scraper_price_tracker/components/app_bar.dart';
import 'package:web_scraper_price_tracker/components/product_list.dart';

class ResultsScreen extends StatefulWidget {
  final Map<String, dynamic> json;
  const ResultsScreen({super.key, required this.json});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    List amazonList = widget.json["amazon"];
    List flipkartList = widget.json["flipkart"];
    List productList = [...amazonList, ...flipkartList];
    productList.sort((a, b) =>
        double.parse(a["price"].replaceAll(",", "")).compareTo(
            double.parse(b["price"].replaceAll(",", ""))
        )
    );
    return Scaffold(
      appBar: const CustomAppBar(title: "Results"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: ProductList(productList: productList),
      )
    );
  }
}
