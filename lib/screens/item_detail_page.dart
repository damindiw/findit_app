import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot item;

  const ItemDetailPage({super.key, required this.item});

  // Function to open the phone dialer
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (e) {
      debugPrint("Could not launch dialer: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = item.data() as Map<String, dynamic>;
    
    // Updated keys to match your Firebase exactly
    final String itemName = data['itemName'] ?? 'No Name Provided';
    final String category = data['itemType'] ?? 'Not Specified'; 
    final String location = data['location'] ?? 'Unknown';
    final String date = data['date'] ?? 'N/A';
    final String description = data['description'] ?? 'No description provided.';
    final String phoneNumber = data['contact'] ?? ''; 

    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      appBar: AppBar(
        title: Text(itemName, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1D272F),
        iconTheme: const IconThemeData(color: Color(0xFF00A86B)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.inventory_2, size: 100, color: Color(0xFF00A86B)),
            ),
            const SizedBox(height: 30),
            _buildDetailRow("Category", category),
            _buildDetailRow("Location", location),
            _buildDetailRow("Date", date),
            const Divider(color: Colors.grey, height: 40),
            const Text(
              "Description", 
              style: TextStyle(color: Color(0xFF00A86B), fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            Text(description, style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 40),
            
            // The "Call Finder" Button
            if (phoneNumber.isNotEmpty)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _makePhoneCall(phoneNumber),
                  icon: const Icon(Icons.phone, color: Colors.white),
                  label: const Text("Call Finder", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A86B),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}