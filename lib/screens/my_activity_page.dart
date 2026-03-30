import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyActivityPage extends StatelessWidget {
  const MyActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("My Activity", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00A86B)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reports')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No activities found.", style: TextStyle(color: Colors.grey)));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;

              return _buildActivityCard(context, doc.id, data);
            },
          );
        },
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, String docId, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1D272F),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Item Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['itemName'] ?? 'Unknown', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(data['location'] ?? 'N/A', style: const TextStyle(color: Colors.grey)),
              Text(data['date'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          
          // Action Buttons
          Column(
            children: [
              ElevatedButton(
                onPressed: () => _markAsFound(context, docId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Found Item", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => _deleteReport(context, docId),
                child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _markAsFound(BuildContext context, String docId) async {
    await FirebaseFirestore.instance.collection('reports').doc(docId).update({'status': 'Found'});
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Item marked as Found!")));
  }

  void _deleteReport(BuildContext context, String docId) async {
    await FirebaseFirestore.instance.collection('reports').doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Report deleted.")));
  }
}