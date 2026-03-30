import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both email and password")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      // Navigate to the app inside
      Navigator.pushReplacementNamed(context, '/main_nav');

    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Authentication failed")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An unexpected error occurred")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SingleChildScrollView( // Added scroll view to prevent overflow on mobile keyboard
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const Text(
                "Welcome Back",
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),

              _buildInput("Email", "Enter your email", _emailController),
              _buildInput("Password", "******", _passwordController, isPassword: true),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/forget_password'),
                  child: const Text("Forgot Password?", style: TextStyle(color: Color(0xFF00A86B))),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  minimumSize: const Size(double.infinity, 50),
                  shape: const StadiumBorder(),
                ),
                child: const Text("SIGN IN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: const Text("Sign Up", style: TextStyle(color: Color(0xFF00A86B))),
                  ),
                ],
              ),
            ],
          ),
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
        const SizedBox(height: 20),
      ],
    );
  }
}