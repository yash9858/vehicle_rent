import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/Available_bike.dart';
import 'package:rentify/User/Available_car.dart';
import 'package:rentify/User/Homescreen.dart';
import 'package:rentify/User/Profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserDasboard extends StatefulWidget {
  const UserDasboard({super.key});

  @override
  State<UserDasboard> createState() => _UserDasboardState();
}

class _UserDasboardState extends State<UserDasboard> {
  var _currentIndex=0;

  var pagelist=[
    Homescreen(),
    Bike(),
    Car(),
    Profile(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(



      body: pagelist[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(


        onTap: (i){
          print("ontap $i");
          setState(() {
            _currentIndex=i;
          });
        },
        currentIndex: _currentIndex,



        items: [
          /// Home
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("H"),
            selectedColor: Colors.deepPurple.shade300,
          ),

          /// Likes
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text("Likes"),
            selectedColor: Colors.pink,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: Icon(LineIcons.car),
            title: Text("Search"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
