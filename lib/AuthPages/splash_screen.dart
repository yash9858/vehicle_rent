import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/Admin/admin_dashboard.dart';
import 'package:rentify/AuthPages/login_screen.dart';
import 'package:rentify/User/HomePages/user_dash_board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../User/ProfilePages/complete_profile.dart';
import 'intro_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 3), () {
      checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool seen = (pref.getBool('seen') ?? false);
    if (seen) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? email = user.email;
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('Users').doc(email).get();
        if (userDoc.exists) {
          String role = userDoc.data()?['Role'] ?? 'User';
          if (role == 'Admin') {
            Get.offAll(() => AdminDashBoard());
          }
          else {
            if(userDoc["Status"] == "1"){
              Get.offAll(() => UserDashboard());
            }
            else{
              Get.offAll(() => CompleteProfile());
            }
          }
        }
        else {
          Get.offAll(() => LoginPage());
        }
      } else {
        Get.offAll(() => LoginPage());
      }
    } else {
      await pref.setBool('seen', true);
      Get.offAll(() => IntroScreen());
    }
  }
}

class SplashScreen extends StatelessWidget {
  final SplashController controller = Get.put(SplashController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/img/car.json", height: 200, width: 300),
            const SizedBox(height: 40),
            const Text("Welcome"),
          ],
        ),
      ),
    );
  }
}
