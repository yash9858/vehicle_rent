import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentify/firebase_options.dart';
import 'AuthPages/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple.shade800),
        useMaterial3: false
      ),
      home: SplashScreen(),
    )
  );
}
