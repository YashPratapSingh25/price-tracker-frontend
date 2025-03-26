import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_scraper_price_tracker/pages/authentication/login.dart';
import 'package:web_scraper_price_tracker/pages/bottom_navigation.dart';
import 'package:web_scraper_price_tracker/pages/home_screen.dart';

class AuthStateHelper extends StatefulWidget {
  const AuthStateHelper({super.key});

  @override
  State<AuthStateHelper> createState() => _AuthStateHelperState();
}

class _AuthStateHelperState extends State<AuthStateHelper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return const Login();
        }
        else{
          return const BottomNavigation();
        }
      },
    );
  }
}
