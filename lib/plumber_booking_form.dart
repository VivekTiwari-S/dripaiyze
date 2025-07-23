import 'package:flutter/material.dart';
import 'plumber_filter_screen.dart';

class PlumberBookingForm extends StatefulWidget {
  @override
  _PlumberBookingFormState createState() => _PlumberBookingFormState();
}

class _PlumberBookingFormState extends State<PlumberBookingForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _submitForm() {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedTime != null) {
      _formKey.currentState!.save();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PlumberFilterScreen(
            name: _name,
            address: _address,
            date: _selectedDate!,
            time: _selectedTime!,
          ),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book a Plumber"), backgroundColor: Colors.blue, foregroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (val) => _name = val!.trim(),
                validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (val) => _address = val!.trim(),
                validator: (val) => val == null || val.isEmpty ? 'Enter address' : null,
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              ListTile(
                title: Text(_selectedTime == null
                    ? 'Select Time'
                    : 'Time: ${_selectedTime!.format(context)}'),
                trailing: Icon(Icons.access_time),
                onTap: _pickTime,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Look for Plumbers"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
