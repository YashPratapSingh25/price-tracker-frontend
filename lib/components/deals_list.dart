import 'package:flutter/material.dart';
import 'package:web_scraper_price_tracker/components/deal_card.dart';

class DealsList extends StatefulWidget {
  final List deals;
  const DealsList({super.key, required this.deals});

  @override
  State<DealsList> createState() => _DealsListState();
}

class _DealsListState extends State<DealsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.deals.length,
      itemBuilder: (context, index) {
        return DealCard(deal: widget.deals[index]);
      },
    );
  }
}
