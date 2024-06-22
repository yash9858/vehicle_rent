import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "About Us",
          style: TextStyle(fontSize: 20),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Welcome to Our Vehicle Rental App"),
            _buildParagraph(
              "Our Vehicle Rental Application is a mobile app developed using the Flutter framework, designed to provide users with a convenient and efficient platform for renting vehicles.",
            ),
            _buildParagraph(
              "We aim to offer a user-friendly experience and a diverse range of high-quality vehicles, including cars, bikes, and electric vehicles (EV).",
            ),
            _buildSectionTitle("Key Features"),
            _buildFeature(
              "Flexible Rental Options",
              "Rent vehicles by the hour or the day based on your specific needs.",
            ),
            _buildFeature(
              "Categorized Vehicles",
              "Easily find the specific type of vehicle you need with our categorized system.",
            ),
            _buildFeature(
              "Convenient Payments",
              "Pay for your rental using various methods such as credit cards and online banking.",
            ),
            _buildFeature(
              "Cancellation Flexibility",
              "Cancel your booking and get a refund with our user-friendly cancellation policy.",
            ),
            _buildSectionTitle("Why Choose Us"),
            _buildParagraph(
              "Our vehicle renting system offers a convenient and affordable way to access vehicles when needed. We prioritize user satisfaction and strive to make your renting experience enjoyable.",
            ),
            _buildParagraph(
              "With a commitment to excellence, we stand out in the market by providing top-notch customer service, reliable vehicles, and transparent transactions.",
            ),
            _buildSectionTitle("Our Mission"),
            _buildParagraph(
              "Our mission is to revolutionize the vehicle rental industry by offering a seamless, technologically advanced platform that caters to the diverse needs of our users. We strive to make transportation accessible, efficient, and eco-friendly.",
            ),
            _buildSectionTitle("Contact Us"),
            _buildParagraph(
              "If you have any questions, suggestions, or concerns, feel free to reach out to us. We value your feedback and are dedicated to continually improving our services.",
            ),
            _buildParagraph(
              "Email: contact@vehicleRental.com\nPhone: (123) 456-7890",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}


