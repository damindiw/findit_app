import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();
  // Added missing controllers to fix "Undefined name" errors
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Future<void> _resetPassword() async {
    // Basic validation to check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reset link sent to your email!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        leading: const BackButton(color: Color(0xFF00A86B)),
      ),
      body: SingleChildScrollView( // Added scroll view to prevent overflow errors
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const Text("Forget password?", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            const Icon(Icons.lock_reset, size: 100, color: Color(0xFF00A86B)),
            const SizedBox(height: 40),
            
            _buildInput("Email :", "Enter your email", _emailController),
            const SizedBox(height: 15),
            
            // New fields now work because controllers are declared above
            _buildInput("New Password :", "************", _passwordController, isPassword: true),
            const SizedBox(height: 15),
            
            _buildInput("Confirm Password :", "************", _confirmPasswordController, isPassword: true),
            
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B), 
                minimumSize: const Size(200, 50), 
                shape: const StadiumBorder(),
              ),
              child: const Text("UPDATE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Updated to accept 'isPassword' parameter
  Widget _buildInput(String label, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(color: const Color(0xFF9E9E9E), borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: controller,
            obscureText: isPassword, // This hides the characters for passwords
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: hint, 
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}