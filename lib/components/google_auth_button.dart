import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_scraper_price_tracker/providers/tracking_provider.dart';
import 'package:web_scraper_price_tracker/services/authentication/auth_service.dart';

class GoogleAuthButton extends StatelessWidget {
  const GoogleAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: GestureDetector(
        onTap: () async {
          showDialog(
            context: context,
            builder: (context) => const Center(child: CircularProgressIndicator(),),
          );
          try{
            authService.authWithGoogle();
            Navigator.pop(context);
          }
          catch (e){
            Navigator.pop(context);
            final snackBar = SnackBar(content: Text("Error: ${e}"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue
          ),
          child: const Text(
            "Continue with Google",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
