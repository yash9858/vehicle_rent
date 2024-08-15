import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:rentify/User/HomePages/available_bike.dart';
import 'package:rentify/User/HomePages/available_car.dart';
import 'package:rentify/User/HomePages/homescreen.dart';
import 'package:rentify/User/ProfilePages/profile.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class UserDashboardController extends GetxController {
  var currentIndex = 0.obs;
  PageController pageController = PageController();

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}

class UserDashboard extends StatelessWidget {
  UserDashboard({Key? key}) : super(key: key);
  final UserDashboardController controller = Get.put(UserDashboardController());

  final List<Widget> pages = [
    Homescreen(),
    const Bike(),
    const Car(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: pages,
      ),
      bottomNavigationBar: Obx(() => SalomonBottomBar(
        onTap: controller.onItemTapped,
        currentIndex: controller.currentIndex.value,
        unselectedItemColor: Colors.black,
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.home),
            title: const Text("Home",),
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
      )),
    );
  }
}
