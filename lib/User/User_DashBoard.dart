// ignore_for_file: sized_box_for_whitespace
import 'package:rentify/User/Bike_Details.dart';
import 'Available_car.dart';
import 'Home_User.dart';
import 'Profile.dart';
import 'package:line_icons/line_icons.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => NavigationState();
}

class NavigationState extends State<Navigation> {
  var _currentIndex = 0;
    // ignore: non_constant_identifier_names
    List<Widget> Pagelist = const [
    Homescreen(),
    bike_detail(),
    Car(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pagelist[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        onTap: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          /// Home
           SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home"),
            selectedColor: Colors.deepPurple.shade800,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: const Icon(LineIcons.car),
            title: const Text("Car"),
            selectedColor: Colors.deepPurple.shade800,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(LineIcons.biking),
            title: const Text("Bike"),
            selectedColor: Colors.deepPurple.shade800,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.account_circle_rounded),
            title: const Text("Profile"),
            selectedColor: Colors.deepPurple.shade800,
          ),
        ],
      ),
    );


  }


}
