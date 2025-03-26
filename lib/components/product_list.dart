import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_scraper_price_tracker/components/product_card.dart';

class ProductList extends StatefulWidget {
  final List productList;
  const ProductList({super.key, required this.productList});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.productList.length,
      itemBuilder: (context, index) {
        final product = widget.productList[index];
        return ProductCard(product: product);
      },
    );
  }
}
