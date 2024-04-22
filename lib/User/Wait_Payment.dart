import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/User/Successful_Pay.dart';

class Wait_Pay extends StatefulWidget {
  const Wait_Pay({super.key});

  @override
  State<Wait_Pay> createState() => _Wait_PayState();
}

class _Wait_PayState extends State<Wait_Pay> {

  void initState()
  {
    super.initState();
    Timer(
      Duration (seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Pay()));
    });
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
            Lottie.asset("assets/img/load_pay.json", height: 250, width: 250),
            Text('Wait For Confirmation', style: TextStyle(
              fontSize: 18,
            ),)
          ],
        ),
      ),
    );
  }
}
