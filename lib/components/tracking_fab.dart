import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_scraper_price_tracker/services/firebase/firestore_service.dart';
import '../providers/price_history_provider.dart';

class TrackingFab extends StatefulWidget {
  const TrackingFab({super.key});

  @override
  State<TrackingFab> createState() => _TrackingFabState();
}

class _TrackingFabState extends State<TrackingFab> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _controller = TextEditingController();
  late BuildContext rootContext;

  @override
  Widget build(BuildContext context) {
    final PriceHistoryProvider provider = Provider.of<PriceHistoryProvider>(context, listen: false);
    rootContext = context;
    return FloatingActionButton(
      onPressed: (){
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Paste link to track", style: TextStyle(fontWeight: FontWeight.bold),),
              content: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2.0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(width: 2.0, color: Colors.deepPurple),
                  ),
                  hintText: "Enter link...",
                ),
                onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                controller: _controller,
              ),
              actions: [
                TextButton(
                onPressed: () async {
                  if (_controller.text.trim().isEmpty) return;
                  Navigator.pop(context);
                  showDialog(
                    context: rootContext,
                    builder: (context) => const Center(child: CircularProgressIndicator(),),
                  );
                  final result = await firestoreService.addProductByLink(
                    _controller.text,
                    FirebaseAuth.instance.currentUser!.email!,
                  );
                  provider.fetchPriceHistory();
                  Navigator.pop(rootContext);
                  ScaffoldMessenger.of(rootContext).showSnackBar(
                    SnackBar(content: Text(result))
                  );
                  _controller.clear();
                },

                child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 18),
                  ),
                ),

                TextButton(
                  onPressed: (){
                    _controller.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel", style: TextStyle(fontSize: 18),)
                )
              ],
            );
          },
        );
      },
      backgroundColor: Colors.deepPurple[200],
      child: const Icon(Icons.add_shopping_cart),
    );
  }
}
