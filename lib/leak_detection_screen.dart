import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'leak_history_screen.dart';

class DetectLeakScreen extends StatefulWidget {
  @override
  _DetectLeakScreenState createState() => _DetectLeakScreenState();
}

class _DetectLeakScreenState extends State<DetectLeakScreen> {
  final databaseRef = FirebaseDatabase.instance.ref("leakDetection");

  double flowRate = 0.0;
  bool leakDetected = false;
  double totalVolume = 0.0;
  StreamSubscription<DatabaseEvent>? _subscription;

  @override
  void initState() {
    super.initState();

    // Listen to realtime changes
    _subscription = databaseRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          flowRate = (data['flowRate'] ?? 0).toDouble();
          leakDetected = data['leakDetected'] ?? false;
          totalVolume = (data['totalVolume'] ?? 0).toDouble();
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leak Detection"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.water_drop, size: 80, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text("Flow Rate: ${flowRate.toStringAsFixed(2)} L/min",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            Text(leakDetected ? "Leak Detected!" : "No Leak Detected",
                style: TextStyle(
                  fontSize: 22,
                  color: leakDetected ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 20),
            Text("Total Volume: ${totalVolume.toStringAsFixed(2)} L",
                style: TextStyle(fontSize: 22)),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LeakHistoryScreen()),
              ),
              icon: Icon(Icons.history),
              label: Text("Show Leak History"),
            ),
          ],
        ),
      ),
    );
  }
}
