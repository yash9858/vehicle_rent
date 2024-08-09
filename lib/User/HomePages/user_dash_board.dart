import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/HomePages/available_bike.dart';
import 'package:rentify/User/HomePages/available_car.dart';
import 'package:rentify/User/HomePages/homescreen.dart';
import 'package:rentify/User/ProfilePages/profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    Homescreen(),
    const Bike(),
    const Car(),
    Profile(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages.map((page) => page).toList(),
      ),
      bottomNavigationBar: SalomonBottomBar(
        onTap: _onItemTapped,
        currentIndex: _currentIndex,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.deepPurple.shade300,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.directions_bike_outlined),
            title: const Text("Bike"),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: const Icon(LineIcons.car),
            title: const Text("Car"),
            selectedColor: Colors.blueAccent,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
