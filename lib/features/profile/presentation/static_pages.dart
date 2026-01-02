import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy & Security")),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("Privacy Policy", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text("Your data is secure with us. We use end-to-end encryption for all sensitive information...", 
                 style: TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text("How can we help?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text("Contact us at support@nearhelp.com for any queries.", 
                 style: TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
