import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/available_bike.dart';
import 'package:rentify/User/available_car.dart';
import 'package:rentify/User/homescreen.dart';
import 'package:rentify/User/profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  var _currentIndex=0;
  var pagelist =  [
    const Homescreen(),
    const Bike(),
    const Car(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pagelist[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        onTap: (i){
          if (kDebugMode) {
            print("onTap $i");
          }
          setState(() {
            _currentIndex=i;
          });
        },
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