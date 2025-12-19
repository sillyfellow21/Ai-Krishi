import 'package:flutter/material.dart';
import 'package:aikrishi/features/land/my_lands_screen.dart';
import 'package:aikrishi/features/crop/all_crops_screen.dart'; // Import the new screen
import 'package:aikrishi/features/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const MyLandsScreen(),
    const AllCropsScreen(), // Add the new screen to the list
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape),
            label: 'My Lands',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grass), // New icon for crops
            label: 'My Crops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
