import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'splash_screen.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade800),
      useMaterial3: false
    ),
    home: const SplashScreen(),
  ));
}
