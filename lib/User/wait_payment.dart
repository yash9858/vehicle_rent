import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/User/successful_pay.dart';

class WaitPay extends StatefulWidget {
  const WaitPay({super.key});

  @override
  State<WaitPay> createState() => _WaitPayState();
}

class _WaitPayState extends State<WaitPay> {

  @override
  void initState()
  {
    super.initState();
    Timer(
      const Duration (seconds: 3), () {
        Get.off(()=> const Pay());
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
            const Text('Wait For Confirmation', style: TextStyle(
              fontSize: 18,
            ),)
          ],
        ),
      ),
    );
  }
}
