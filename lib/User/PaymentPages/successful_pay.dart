import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/User/HomePages/user_dash_board.dart';

class PayController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => UserDashboard());
      Fluttertoast.showToast(
        msg: "Payment Successful.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    });
  }
}

class Pay extends StatelessWidget {
  Pay({super.key}) {
    Get.put(PayController());
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
            Lottie.asset("assets/img/pay.json", height: 300, width: 300),
          ],
        ),
      ),
    );
  }
}
