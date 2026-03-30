import 'package:flutter/material.dart';
import 'report_page.dart';
import 'lost_found_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget _buildMenuButton(BuildContext context, String label, Widget targetPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00A86B), // Green from design
          minimumSize: const Size(double.infinity, 60),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22), // Dark theme
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Center Logo placeholder
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(image: AssetImage('assets/logo.png'), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 40),
            _buildMenuButton(context, "Lost", const LostFoundListPage(status: 'Lost')),
            _buildMenuButton(context, "Found", const LostFoundListPage(status: 'Found')),
            _buildMenuButton(context, "Report", const ReportPage()),
          ],
        ),
      ),
    );
  }
}