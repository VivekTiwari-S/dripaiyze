import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'plumber_booking_form.dart';
import 'dashboard_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final String userName;
  final String address;
  final DateTime date;
  final TimeOfDay time;
  final Map<String, dynamic> plumber;

  BookingConfirmationScreen({
    required this.userName,
    required this.address,
    required this.date,
    required this.time,
    required this.plumber,
  });

  @override
  _BookingConfirmationScreenState createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final _feedbackController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _confirmBooking() async {
    setState(() => _isSubmitting = true);

    await FirebaseFirestore.instance.collection('bookings').add({
      'user_name': widget.userName,
      'user_address': widget.address,
      'date': widget.date.toIso8601String(),
      'time': widget.time.format(context),
      'plumber_name': widget.plumber['name'],
      'plumber_location': widget.plumber['location'],
      'plumber_price': widget.plumber['price_per_hour'],
      'plumber_rating': widget.plumber['rating'],
      'feedback': _feedbackController.text.trim(),
      'created_at': Timestamp.now(),
    });

    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Booking Confirmed!"),
        content: Text("Your plumber has been successfully booked."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => DashboardScreen()),
                    (route) => false,
              );
            },
          )
        ],
      ),
    );
  }

  void _cancelBooking() {
    Navigator.pop(context);
  }

  void _modifyBooking() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PlumberBookingForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plumber = widget.plumber;
    final dateStr = "${widget.date.toLocal().toString().split(' ')[0]}";
    final timeStr = widget.time.format(context);

    return Scaffold(
      appBar: AppBar(title: Text("Confirm Booking"), backgroundColor: Colors.blue, foregroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text("👤 User Details", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Name: ${widget.userName}"),
            Text("Address: ${widget.address}"),
            Text("Date & Time: $dateStr at $timeStr"),
            SizedBox(height: 20),
            Text("🔧 Plumber Details", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Name: ${plumber['name']}"),
            Text("Location: ${plumber['location']}"),
            Text("Price: ₹${plumber['price_per_hour']} per hour"),
            Text("Rating: ⭐ ${plumber['rating']}"),
            SizedBox(height: 20),
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: "Feedback (optional)",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 30),
            if (_isSubmitting)
              Center(child: CircularProgressIndicator())
            else ...[
              ElevatedButton(
                onPressed: _confirmBooking,
                child: Text("Confirm Booking"),
              ),
              TextButton(
                onPressed: _modifyBooking,
                child: Text("Modify Booking"),
              ),
              TextButton(
                onPressed: _cancelBooking,
                child: Text("Cancel"),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
