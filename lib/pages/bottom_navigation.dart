import 'package:flutter/material.dart';
import 'package:web_scraper_price_tracker/pages/home_screen.dart';
import 'package:web_scraper_price_tracker/pages/profile_screen.dart';
import 'package:web_scraper_price_tracker/pages/tracked_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int selectedIndex = 0;

  List <Widget> screens = [
    const HomeScreen(),
    const TrackedScreen(),
    const ProfileScreen()
  ];

  void onTap(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple[200],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
        currentIndex: selectedIndex,
        onTap: onTap,
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes),
            label: "Track"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile"
          )
        ]
      ),
    );
  }
}
