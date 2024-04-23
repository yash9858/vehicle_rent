import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle('Information We Collect'),
            PolicyItem(
              'Personal Information',
              'When you use the App, we may collect personal information such as your name, email address, phone number, and payment information. This information is necessary for providing the rental services.',
            ),
            PolicyItem(
              'Vehicle Information',
              'We may collect information about the vehicles you rent, including make, model, license plate number, and usage history.',
            ),
            PolicyItem(
              'Location Information',
              'With your consent, we may collect your device\'s precise location to provide location-based services such as finding rental locations or tracking vehicle usage.',
            ),
            PolicyItem(
              'Usage Information',
              'We collect information about how you use the App, such as the pages you visit, the features you use, and interactions with advertisements.',
            ),
            PolicyItem(
              'Device Information',
              'We may collect device information such as device type, operating system, and unique device identifiers for analytics and troubleshooting purposes.',
            ),

            SectionTitle('How We Use Your Information'),
            PolicyItem(
              'Providing Services',
              'We use your information to provide the rental services you request, including processing reservations, managing rentals, and facilitating payments.',
            ),
            PolicyItem(
              'Improving the App',
              'We use collected data to analyze user trends, enhance user experience, and improve the functionality of the App.',
            ),
            PolicyItem(
              'Communication',
              'We may use your contact information to send you transactional emails, updates about your rentals, and marketing communications with your consent.',
            ),
            PolicyItem(
              'Security',
              'We use collected information to protect the security and integrity of the App, prevent fraud, and ensure compliance with legal obligations.',
            ),

            // Add more sections as needed...

            SectionTitle('Information Sharing'),
            PolicyItem(
              'Service Providers',
              'We may share your information with third-party service providers who assist us in providing the rental services, processing payments, or analyzing user data.',
            ),
            PolicyItem(
              'Legal Compliance',
              'We may disclose your information when required by law or in response to valid legal requests, such as court orders or subpoenas.',
            ),
            PolicyItem(
              'Business Transfers',
              'In the event of a merger, acquisition, or sale of assets, your information may be transferred to a new owner or entity as part of the transaction.',
            ),

            // Add more sections as needed...

         //   SectionTitle('Data Retention'),
            PolicyItem(
              'Data Retention',
              'We retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy, unless a longer retention period is required or permitted by law.',
            ),

            // Add more sections as needed...

          //  SectionTitle('Your Choices'),
            PolicyItem(
              'Your Choices',
              'You have the right to access, update, or delete your personal information. You can also opt-out of receiving marketing communications by following the unsubscribe instructions included in the emails or contacting us directly.',
            ),

            // Add more sections as needed...

          //  SectionTitle('Children\'s Privacy'),
            PolicyItem(
              'Children\'s Privacy',
              'The App is not intended for children under the age of 16. We do not knowingly collect personal information from children under 16 years of age. If you believe we have inadvertently collected information from a child under 16, please contact us to request deletion.',
            ),

            // Add more sections as needed...

            //SectionTitle('Changes to this Privacy Policy'),
            PolicyItem(
              'Changes to this Privacy Policy',
              'We may update this Privacy Policy from time to time to reflect changes in our practices or legal requirements. We will notify you of any material changes by posting the updated policy on our website or through other communication channels.',
            ),

            // Add more sections as needed...

           // SectionTitle('Contact Us'),
            PolicyItem(
              'Contact Us',
              'If you have any questions, concerns, or requests regarding this Privacy Policy or our data practices, please contact us at [contact abc@gmail.com or 123456789].',
            ),

            // Add more sections as needed...
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PolicyItem extends StatelessWidget {
  final String title;
  final String content;

  PolicyItem(this.title, this.content);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(content),
        ],
      ),
    );
  }
}

