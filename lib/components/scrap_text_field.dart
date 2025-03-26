import 'package:flutter/material.dart';
import 'package:web_scraper_price_tracker/pages/results_screen.dart';
import 'package:web_scraper_price_tracker/services/api_service.dart';

class ScrapTextField extends StatefulWidget {
  final Function(Map<String, dynamic> result) onScrap;
  const ScrapTextField({super.key, required this.onScrap});

  @override
  State<ScrapTextField> createState() => _ScrapTextFieldState();
}

class _ScrapTextFieldState extends State<ScrapTextField> {
  final service = ApiService();
  final TextEditingController _scrapController = TextEditingController();

  Future<void> _handleSearch() async {
    if (_scrapController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product name is empty")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      Map<String, dynamic> result = await service.fetchData(_scrapController.text);

      Navigator.pop(context);

      _scrapController.clear();

      if (result.containsKey("Error")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["Error"])),
        );
        return;
      }

      print("Result: $result");
      widget.onScrap(result);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: _handleSearch,
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
        hintText: "Search for products...",
      ),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      controller: _scrapController,
    );
  }
}