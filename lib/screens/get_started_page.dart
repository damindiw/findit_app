import 'package:flutter/material.dart';
import 'welcome_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22), // Dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 150), // Your logo
            const SizedBox(height: 20),
            const Text("Findit", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
            const Text("Lost & Found App", style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomePage())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B), // Green button
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Get Started", style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}