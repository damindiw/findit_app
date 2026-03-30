import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFF00A86B),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const Text(
            "Privacy & Policy",
            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF636970), // Grey container
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Last Updated : 18/03/2026", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Text("Your privacy is important to us.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                      "We collect basic information such as your name, personal email address, and contact number to create and manage your account.",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 15),
                    Text("Your information is used only to:", style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10),
                    Text("• Manage Lost and Found Services", style: TextStyle(color: Colors.white)),
                    Text("• Sending updates", style: TextStyle(color: Colors.white)),
                    Text("• Improve app services", style: TextStyle(color: Colors.white)),
                    SizedBox(height: 15),
                    Text(
                      "We do not sell, rent, or share your personal information with third parties.",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "By using this app, you agree to our privacy and policy practices.",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildBottomNavBar(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF00A86B), // Green nav bar
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(Icons.home, color: Colors.white, size: 30),
          Icon(Icons.phone_android, color: Colors.white, size: 30),
          Icon(Icons.settings, color: Colors.white, size: 30),
          Icon(Icons.person_outline, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}