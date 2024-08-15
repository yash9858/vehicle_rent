import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/User/PaymentPages/successful_pay.dart';

class WaitPayController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(
      const Duration(seconds: 3), () {
        Get.off(() => Pay());
      },
    );
  }
}

class WaitPay extends StatelessWidget {
  WaitPay({super.key}) {
    Get.put(WaitPayController());
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
            const Text('Wait For Confirmation', style: TextStyle(fontSize: 18,),),
          ],
        ),
      ),
    );
  }
}

