import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/Admin/admin_dashboard.dart';
import 'package:rentify/login_screen.dart';
import 'package:rentify/User/user_dash_board.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      login();
    });
  }

  Future login() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    bool seen=(pref.getBool('seen')??false);
    if(seen)
    {
      if(pref.getString('id')!=null)
      {
        if(pref.getString('Role')=="0")
        {
          Get.offAll(() => const AdminDashBoard());
        }
        else
        {
          Get.offAll(() => const UserDashboard());
        }
      }
      else
      {
        Get.offAll(() => const LoginPage());
      }
    }
    else
    {
      await pref.setBool('seen', true);
      Get.offAll(() => const IntroScreen());
    }
  }
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
            const SizedBox(
              height: 40,
            ),
            const Text("Welcome")
          ],
        ),
      ),
    );
  }
}
