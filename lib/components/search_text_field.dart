import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_scraper_price_tracker/providers/tracking_provider.dart';

class SearchTextField extends StatefulWidget {
  final Function(String searchQuery) onSearch;
  const SearchTextField({super.key, required this.onSearch});

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value){
        widget.onSearch(value);
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: (){
            widget.onSearch(_searchController.text);
          },
          icon: const Icon(Icons.search),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(width: 2.0, color: Colors.deepPurple),
        ),
        hintText: "Search tracked products...",
      ),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: _searchController,
    );
  }
}
