import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/Admin/Admin_DashBoard.dart';
import 'package:rentify/Login_Screen.dart';
import 'package:rentify/User/User_DashBoard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Intro_Screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () {
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => IntroScreen()));
      login();
    });
  }

  Future login() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    bool _seen=(pref.getBool('seen')??false);
    if(_seen)
    {
      if(pref.getString('id')!=null)
      {
        if(pref.getString('Role')=="0")
        {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Admin_DashBoard()), (Route<dynamic> route) => false);
        }
        else
        {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => UserDasboard()), (Route<dynamic> route) => false);
        }
      }
      else
      {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
      }
    }
    else
    {
      await pref.setBool('seen', true);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);

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
