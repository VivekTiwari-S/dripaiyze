import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'booking_confirmation_screen.dart';

class PlumberSelectionScreen extends StatefulWidget {
  final String name;
  final String address;
  final DateTime date;
  final TimeOfDay time;
  final String location;
  final String price;
  final String rating;

  PlumberSelectionScreen({
    required this.name,
    required this.address,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.rating,
  });

  @override
  _PlumberSelectionScreenState createState() => _PlumberSelectionScreenState();
}

class _PlumberSelectionScreenState extends State<PlumberSelectionScreen> {
  List<Map<String, dynamic>> plumbers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlumbers();
  }

  void _fetchPlumbers() async {
    final snapshot = await FirebaseFirestore.instance.collection('plumbers').get();

    List<Map<String, dynamic>> allPlumbers = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    double minRating = double.parse(widget.rating[0]); // e.g., "4+" => 4
    double? minPrice, maxPrice;

    if (widget.price.contains('<')) {
      maxPrice = 300;
    } else if (widget.price.contains('>')) {
      minPrice = 500;
    } else {
      minPrice = 300;
      maxPrice = 500;
    }

    final filtered = allPlumbers.where((p) {
      final matchesLocation = p['location'] == widget.location;
      final price = (p['price_per_hour'] as num).toDouble();
      final rating = (p['rating'] as num).toDouble();
      final matchesPrice = (minPrice == null || price >= minPrice) &&
          (maxPrice == null || price <= maxPrice);
      final matchesRating = rating >= minRating;

      return matchesLocation && matchesPrice && matchesRating;
    }).toList();

    setState(() {
      plumbers = filtered;
      isLoading = false;
    });
  }

  void _selectPlumber(Map<String, dynamic> plumber) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(
          userName: widget.name,
          address: widget.address,
          date: widget.date,
          time: widget.time,
          plumber: plumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Plumbers"), backgroundColor: Colors.blue, foregroundColor: Colors.white,),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : plumbers.isEmpty
          ? Center(child: Text("No plumbers match your criteria."))
          : ListView.builder(
        itemCount: plumbers.length,
        itemBuilder: (_, index) {
          final plumber = plumbers[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(plumber['name']),
              subtitle: Text(
                  "${plumber['location']} • ₹${plumber['price_per_hour']}/hr • ⭐ ${plumber['rating']}"),
              trailing: ElevatedButton(
                child: Text("Book"),
                onPressed: () => _selectPlumber(plumber),
              ),
            ),
          );
        },
      ),
    );
  }
}
