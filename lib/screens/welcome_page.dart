import 'package:flutter/material.dart';
import 'signin_page.dart';
import 'signup_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const BackButton(color: Color(0xFF00A86B))),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 30),
            const Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _buildButton(context, "SIGN IN", const SignInPage()),
            const SizedBox(height: 20),
            _buildButton(context, "SIGN UP", const SignUpPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Widget page) {
    return ElevatedButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => page)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00A86B),
        minimumSize: const Size(double.infinity, 50),
        shape: const StadiumBorder(),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}