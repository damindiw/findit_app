import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LostFoundListPage extends StatefulWidget {
  final String status; // Expects 'Lost' or 'Found'
  const LostFoundListPage({super.key, required this.status});

  @override
  State<LostFoundListPage> createState() => _LostFoundListPageState();
}

class _LostFoundListPageState extends State<LostFoundListPage> {
  String _selectedType = 'Smart device';
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  late Query _currentQuery;

  @override
  void initState() {
    super.initState();
    // Initialize with status filter
    _currentQuery = FirebaseFirestore.instance
        .collection('reports')
        .where('status', isEqualTo: widget.status);
  }

  void _applySearch() {
    setState(() {
      Query newQuery = FirebaseFirestore.instance
          .collection('reports')
          .where('status', isEqualTo: widget.status);

      // Apply specific filters
      newQuery = newQuery.where('itemType', isEqualTo: _selectedType);

      if (_dateController.text.trim().isNotEmpty) {
        newQuery = newQuery.where('date', isEqualTo: _dateController.text.trim());
      }

      if (_locationController.text.trim().isNotEmpty) {
        newQuery = newQuery.where('location', isEqualTo: _locationController.text.trim());
      }

      _currentQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121B22),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF00A86B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("${widget.status} Item", 
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel("Item Type :"),
                _buildDropdown(['Smart device', 'Bag', 'Wallet', 'Books', 'Other'], _selectedType, (val) {
                  setState(() => _selectedType = val!);
                }),
                _buildLabel("Date :"),
                _buildTextField(_dateController, "e.g. 30/03/2026"),
                _buildLabel("Location :"),
                _buildTextField(_locationController, "e.g. FOC Canteen"),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _applySearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A86B),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text("Search", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _currentQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF00A86B)));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No matching items found.", style: TextStyle(color: Colors.white)));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    return _buildItemCard(data);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(padding: const EdgeInsets.only(bottom: 5, top: 10), 
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFF9E9E9E), borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: controller, 
        style: const TextStyle(color: Colors.black), // Black text
        decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.black54), border: InputBorder.none),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String currentVal, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: const Color(0xFF9E9E9E), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(currentVal) ? currentVal : items[0],
          isExpanded: true,
          dropdownColor: const Color(0xFF9E9E9E),
          style: const TextStyle(color: Colors.black, fontSize: 16), // Black text
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.black)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFFB0B0B0), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['itemName'] ?? 'Unknown', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
          Text(data['date'] ?? 'N/A', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          const Text("more...", style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 5),
          Text(data['description'] ?? '', style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 10),
          Text("Contact: ${data['contact'] ?? 'N/A'}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}