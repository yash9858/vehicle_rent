import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rentify/User/User_DashBoard.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<Pay> createState() => _PayState();
}

class _PayState extends State<Pay> {

  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      load();
    });
  }

  Future load() async{
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) =>  UserDasboard()), (Route<dynamic> route) => false);
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
