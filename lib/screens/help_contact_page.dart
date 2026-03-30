import 'package:flutter/material.dart';

class HelpContactPage extends StatelessWidget {
  const HelpContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
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
            "Help & Contact Us",
            style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF636970),
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("01. How to use the app ?"),
                    const Text("1. Log in to your account.\n2. Report items, find lost items or found items.\n3. Choose an available lost or found items.\n4. Handover or get the item.", 
                      style: TextStyle(color: Colors.white)),
                    
                    _buildSectionTitle("02. I didn't receive a confirmation email"),
                    const Text("1. Check your spam folder.\n2. Make sure your email address is correct.", 
                      style: TextStyle(color: Colors.white)),

                    _buildSectionTitle("03. Why is the app not loading properly?"),
                    const Text("• Check your internet connection.\n• Close and reopen the app.\n• Update the app to the latest version", 
                      style: TextStyle(color: Colors.white)),

                    _buildSectionTitle("04. Why can't I log in?"),
                    const Text("Make sure your email and password are correct and check your internet connection. Reset your password if needed.", 
                      style: TextStyle(color: Colors.white)),

                    const SizedBox(height: 20),
                    const Text("Contact us", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text("If you need further help, contact us at:", style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    const Text("Email : lostandfoundsupport@gmail.com", style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
                    const Text("Contact Number : 0774801644", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    const Text("We will respond as soon as possible.", style: TextStyle(color: Colors.white)),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _buildBottomNavBar() {
    // Same navbar code as above
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 60,
      decoration: BoxDecoration(color: const Color(0xFF00A86B), borderRadius: BorderRadius.circular(30)),
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