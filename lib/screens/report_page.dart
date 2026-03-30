import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Required for User ID

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String _status = 'Lost';
  String _selectedType = 'Smart device';
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        title: const Text("Report", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A86B), 
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [_buildToggleBtn("Lost"), _buildToggleBtn("Found")],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabel("Item Type :"),
            _buildFieldContainer(DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                isExpanded: true,
                dropdownColor: const Color(0xFF9E9E9E),
                style: const TextStyle(color: Colors.black, fontSize: 16),
                items: ['Smart device', 'Bag', 'Wallet', 'Books', 'Other']
                    .map((e) => DropdownMenuItem(
                          value: e, 
                          child: Text(e, style: const TextStyle(color: Colors.black)),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _selectedType = v!),
              ),
            )),
            _buildLabel("Item Name :"),
            _buildFieldContainer(TextField(
              controller: _nameController, 
              style: const TextStyle(color: Colors.black), 
              decoration: const InputDecoration(border: InputBorder.none, hintText: "e.g. iPhone 16 Pro"),
            )),
            _buildLabel("Description :"),
            _buildFieldContainer(TextField(
              controller: _descController, 
              maxLines: 3, 
              style: const TextStyle(color: Colors.black), 
              decoration: const InputDecoration(border: InputBorder.none),
            )),
            _buildLabel("Date :"),
            _buildFieldContainer(TextField(
              controller: _dateController, 
              style: const TextStyle(color: Colors.black), 
              decoration: const InputDecoration(border: InputBorder.none, hintText: "30/03/2026"),
            )),
            _buildLabel("Location :"),
            _buildFieldContainer(TextField(
              controller: _locationController, 
              style: const TextStyle(color: Colors.black), 
              decoration: const InputDecoration(border: InputBorder.none, hintText: "e.g. FOC Canteen"),
            )),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B), 
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15), 
                  shape: const StadiumBorder(),
                ),
                child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleBtn(String label) {
    bool isSelected = _status == label;
    return GestureDetector(
      onTap: () => setState(() => _status = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF121B22) : Colors.transparent, 
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label, 
          style: TextStyle(
            color: Colors.white, 
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
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

  Widget _buildFieldContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15), 
      decoration: BoxDecoration(
        color: const Color(0xFF9E9E9E), 
        borderRadius: BorderRadius.circular(10),
      ), 
      child: child,
    );
  }

  // --- UPDATED SUBMIT LOGIC ---
  void _submitReport() async {
    // 1. Basic check
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide an item name")),
      );
      return;
    }

    try {
      // 2. Get current User ID
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must be logged in to report")),
        );
        return;
      }

      // 3. Save to Firestore
      await FirebaseFirestore.instance.collection('reports').add({
        'userId': userId, // CRITICAL: This connects the report to you
        'status': _status,
        'itemType': _selectedType,
        'itemName': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'date': _dateController.text.trim(),
        'location': _locationController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(), // Useful for sorting
      });

      if (!mounted) return;

      // 4. Show success and go back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted successfully!")),
      );
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error submitting: $e")),
      );
    }
  }
}