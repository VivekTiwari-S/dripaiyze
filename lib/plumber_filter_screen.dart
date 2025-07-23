import 'package:flutter/material.dart';
import 'plumber_selection_screen.dart';

class PlumberFilterScreen extends StatefulWidget {
  final String name;
  final String address;
  final DateTime date;
  final TimeOfDay time;

  PlumberFilterScreen({
    required this.name,
    required this.address,
    required this.date,
    required this.time,
  });

  @override
  _PlumberFilterScreenState createState() => _PlumberFilterScreenState();
}

class _PlumberFilterScreenState extends State<PlumberFilterScreen> {
  String? selectedLocation;
  String? selectedPrice;
  String? selectedRating;

  final locations = ['Gandhinagar', 'Ahmedabad', 'Mehsana'];
  final prices = ['< ₹300/hr', '₹300-500/hr', '> ₹500/hr'];
  final ratings = ['3+ Stars', '4+ Stars', '5 Stars'];

  void _seeOptions() {
    if (selectedLocation != null &&
        selectedPrice != null &&
        selectedRating != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlumberSelectionScreen(
            name: widget.name,
            address: widget.address,
            date: widget.date,
            time: widget.time,
            location: selectedLocation!,
            price: selectedPrice!,
            rating: selectedRating!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all filters')),
      );
    }
  }

  Widget _buildDropdown(String label, List<String> items, String? value, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        value: value,
        onChanged: onChanged,
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filter Plumbers"), backgroundColor: Colors.blue, foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildDropdown("Location", locations, selectedLocation, (val) {
              setState(() => selectedLocation = val);
            }),
            _buildDropdown("Price per Hour", prices, selectedPrice, (val) {
              setState(() => selectedPrice = val);
            }),
            _buildDropdown("Ratings", ratings, selectedRating, (val) {
              setState(() => selectedRating = val);
            }),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _seeOptions,
              child: Text("See Options"),
            ),
          ],
        ),
      ),
    );
  }
}
