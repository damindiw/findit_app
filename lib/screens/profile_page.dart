import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load current data from Firestore
  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['fullName'] ?? '';
          _studentIdController.text = data['studentId'] ?? '';
          _emailController.text = data['email'] ?? '';
          _contactController.text = data['contactNo'] ?? '';
          _isLoading = false;
        });
      }
    }
  }

  // Save updated data back to Firestore
  Future<void> _saveProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'fullName': _nameController.text.trim(),
        'studentId': _studentIdController.text.trim(),
        'contactNo': _contactController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated successfully!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF121B22),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF00A86B))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.account_circle, size: 100, color: Color(0xFF00A86B)),
            ),
            const SizedBox(height: 20),
            
            _buildLabel("Full Name :"),
            _buildEditableField(_nameController),
            
            _buildLabel("Student ID :"),
            _buildEditableField(_studentIdController),
            
            _buildLabel("Email :"),
            _buildEditableField(_emailController, enabled: false), // Email usually stays locked
            
            _buildLabel("Contact No :"),
            _buildEditableField(_contactController),
            
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _saveProfile, // This makes the button work!
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  minimumSize: const Size(200, 50),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Save Changes", // Changed from "Edit Profile" for clarity
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 5),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEditableField(TextEditingController controller, {bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFF9E9E9E), // Your signature grey
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(color: Colors.black),
        decoration: const InputDecoration(border: InputBorder.none),
      ),
    );
  }
}