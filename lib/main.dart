import 'package:flutter/material.dart';
import 'Splash_Screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade800),
      useMaterial3: true,
    ),
    home: const SplashScreen(),
  ));
}
