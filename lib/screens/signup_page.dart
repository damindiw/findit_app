import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // Added

  Future<void> _signUp() async {
    // 1. Basic Validation
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields")),
      );
      return;
    }

    // 2. Check if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match!")),
      );
      return;
    }

    try {
      // 3. Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 4. Save details to Firestore 'users' collection
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'fullName': _nameController.text.trim(),
        'studentID': _idController.text.trim(),
        'contactNo': _contactController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'user',
        'createdAt': DateTime.now(),
      });

      if (!mounted) return;

      // 5. Success! Navigate to Sign In page instead of app home
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully! Please Sign In.")),
      );
      Navigator.pushReplacementNamed(context, '/signin');

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "An error occurred")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Database Error: $e")),
      );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildInput("Full Name :", "Naveesha Damindi", _nameController),
            _buildInput("Student ID :", "12345", _idController),
            _buildInput("Email :", "123@gmail.com", _emailController),
            _buildInput("Contact No :", "111 222 333", _contactController),
            _buildInput("Password :", "******", _passwordController, isPassword: true),
            _buildInput("Confirm Password :", "******", _confirmPasswordController, isPassword: true),
            
            const SizedBox(height: 30),
            
            ElevatedButton(
              onPressed: _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A86B),
                minimumSize: const Size(200, 50),
                shape: const StadiumBorder(),
              ),
              child: const Text("SIGN UP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFF9E9E9E),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}