import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'my_activity_page.dart'; // Ensure this matches your file name!
import 'privacy_policy_page.dart'; 
import 'help_contact_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1D272F),
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Icon(Icons.settings, size: 80, color: Color(0xFF00A86B)),
          ),
          const SizedBox(height: 20),
          
          // Opens the new management page with Delete/Found options
          _buildSettingsItem(Icons.history, "My Activity", () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const MyActivityPage()),
            );
          }),
          
          _buildSettingsItem(Icons.privacy_tip_outlined, "Privacy and policy", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PrivacyPolicyPage()));
          }),
          
          _buildSettingsItem(Icons.help_outline, "Help & Contact Us", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpContactPage()));
          }),
          
          const SizedBox(height: 40),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // Check if the screen is still active before navigating
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B),
                minimumSize: const Size(double.infinity, 50),
                shape: const StadiumBorder(),
              ),
              child: const Text("Log out", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF00A86B)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: onTap,
    );
  }
}