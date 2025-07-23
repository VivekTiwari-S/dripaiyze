import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // DripAIyze Mission Section
            Column(
              children: [
                Image.asset(
                  'lib/assets/logo.png',
                  height: 250,
                ),
                const SizedBox(height: 16),
                const Text(
                  "At DripAIyze, our mission is to revolutionize the way we manage and conserve water through smart technology. In a world facing increasing water scarcity and infrastructure challenges, we strive to empower individuals, families, and communities with real-time insights and proactive tools to minimize water wastage.\n\nThrough the seamless integration of IoT-based leak detection, intelligent alerts, and user-friendly mobile interfaces, DripAIyze helps identify plumbing issues early, enabling timely intervention and reducing unnecessary water loss. Our platform also connects users to verified plumbing services, streamlining repair and maintenance efforts efficiently.\n\nWe are committed to contributing to a sustainable future by encouraging mindful water usage and fostering environmental responsibility. DripAIyze isn’t just a utility app — it’s a step toward smarter living, greener choices, and a more water-secure tomorrow.\n\nPreserve. Protect. Prevent. That’s the DripAIyze way.",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Developers Section
            Column(
              children: [
                const Text(
                  "Developers",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16), // Adjust the value as needed
                  child: Image.asset(
                    'lib/assets/we3.jpg',
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // const SizedBox(height: 12),
                const Text("Vivek Tiwari\nRam Navlani\nKrupesh Desai",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, height: 1.5, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  "vivekst94@gmail.com\nnavlaniram300@gmail.com\nkrupeshdesai4626@gmail.com",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
