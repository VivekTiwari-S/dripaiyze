import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeakHistoryScreen extends StatelessWidget {
  final DateFormat formatter = DateFormat('dd MMM yyyy, hh:mm a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leak History"), backgroundColor: Colors.blue, foregroundColor: Colors.white,),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('leak_logs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(child: Text("No leak history found."));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final flowRate = data['flow_rate']?.toDouble() ?? 0.0;
              final leak = data['leak'] == true;
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    leak ? Icons.warning : Icons.check_circle,
                    color: leak ? Colors.red : Colors.green,
                  ),
                  title: Text("Flow Rate: ${flowRate.toStringAsFixed(2)} L/min"),
                  subtitle: Text(
                    "Leak: ${leak ? '⚠️ Leak Detected' : '✅ No Leak'}\n"
                        "Time: ${timestamp != null ? formatter.format(timestamp) : 'Unknown'}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
