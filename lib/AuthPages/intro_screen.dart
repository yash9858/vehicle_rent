import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onboarding_intro_screen/onboarding_screen.dart';
import 'package:rentify/AuthPages/login_screen.dart';

class OnboardingController extends GetxController {
  void skipOnboarding() {
    Get.offAll(() => LoginPage());
  }
}

class IntroScreen extends StatelessWidget {
  IntroScreen({super.key});
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnBoardingScreen(
        onSkip: controller.skipOnboarding,
        showPrevNextButton: true,
        showIndicator: true,
        backgourndColor: Colors.white,
        activeDotColor: Colors.black,
        deactiveDotColor: Colors.grey,
        iconColor: Colors.deepPurple,
        leftIcon: Icons.arrow_back_ios_rounded,
        rightIcon: Icons.arrow_forward_ios_rounded,
        iconSize: 25,
        pages: [
          OnBoardingModel(
            image: Image.asset("assets/img/welcome.jpg"),
            title: "Welcome Aboard",
            body:
            "Welcome To Rentify All Your Vehicle Rental Needs. Whether You're Planning A Road Trip "
                "Simply Want To Experience Driving A Different Cars, Bikes And Ev.",
          ),
          OnBoardingModel(
            image: Image.asset("assets/img/ride.png"),
            title: "Discover Your Perfect Ride",
            body:
            "At Rentify We Understand That Everyone Has Different Preferences When It Comes To Vehicles."
                "Swipe Through The Options And Find The Perfect Ride For Your Next Adventure.",
          ),
          OnBoardingModel(
            image: Image.asset("assets/img/book.png"),
            title: "Book With Ease",
            body:
            "Gone Are The Days Of Complicated Booking Processes. With Rentify Renting A Vehicle Is As Easy As 1-2-3. Simply Choose "
                "Your Preferred Vehicle, Select The Rental Dates And Time. Confirm Your Vehicle.",
          ),
        ],
      ),
    );
  }
}

