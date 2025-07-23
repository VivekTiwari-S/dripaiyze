import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Effective Date: April 10, 2025",
              style: TextStyle(fontSize: 14, color: Colors.grey, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 24),
            Text(
              "1. Introduction",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "At DripAIyze, we are committed to protecting your privacy. "
                  "This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 24),
            Text(
              "2. Data Collection and Usage",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "We collect personal information such as your name, email address, and user preferences "
                  "for the purpose of providing secure authentication and personalized experiences. "
                  "Additionally, we collect IoT data from your connected devices to detect water flow, leakage, and usage patterns.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 24),
            Text(
              "3. Purpose of Water Monitoring",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "Our IoT-based water monitoring system helps detect and alert you of potential leaks, "
                  "supporting efficient water management and conservation efforts. "
                  "The goal is to minimize water waste and empower users to take proactive action towards a sustainable future.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 24),
            Text(
              "4. Data Sharing",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "We do not sell or trade your personal information. We may share limited data with third-party service providers "
                  "only to the extent necessary to operate and improve our services, and always in compliance with applicable laws.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 24),
            Text(
              "5. Data Security",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "We use strong encryption and secure authentication protocols to protect your data. "
                  "Access to your information is restricted to authorized personnel only.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 24),
            Text(
              "6. User Control",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "You may view, edit, or delete your account information at any time via the settings screen. "
                  "For data deletion requests or other privacy concerns, please contact our support team.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 24),
            Text(
              "7. Changes to This Policy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "We may update this Privacy Policy from time to time. We will notify you of any significant changes through the app or by email.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            SizedBox(height: 24),
            Text(
              "8. Contact Us",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              "If you have any questions about this Privacy Policy, please contact us at support@dripaiyze.com.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}

