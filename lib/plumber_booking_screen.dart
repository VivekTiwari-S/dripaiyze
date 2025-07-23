import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlumberBookingScreen extends StatefulWidget {
  const PlumberBookingScreen({Key? key}) : super(key: key);

  @override
  State<PlumberBookingScreen> createState() => _PlumberBookingScreenState();
}

class _PlumberBookingScreenState extends State<PlumberBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _selectedPlumber;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Filter variables
  String _selectedLocation = 'All Locations';
  String _selectedPriceRange = 'All Prices';
  double _minRating = 0.0;
  bool _showFilters = false;

  // List of all available locations
  final List<String> _locations = [
    'All Locations',
    'Downtown',
    'Uptown',
    'Westside',
    'Eastside',
    'Northside',
    'Southside',
    'Suburbs'
  ];

  // List of price ranges
  final List<String> _priceRanges = [
    'All Prices',
    'Under \$50/hour',
    '\$50-\$75/hour',
    '\$75-\$100/hour',
    'Over \$100/hour'
  ];

  // Complete list of plumbers with detailed information
  final List<Map<String, dynamic>> _allPlumbers = [
    {
      'name': 'John Smith',
      'rating': 4.8,
      'experience': '8 years',
      'price': '\$50/hour',
      'priceValue': 50,
      'location': 'Downtown',
      'availability': 'Available today',
      'specialization': 'Residential plumbing',
      'image': 'https://randomuser.me/api/portraits/men/1.jpg',
    },
    {
      'name': 'Sarah Johnson',
      'rating': 4.9,
      'experience': '12 years',
      'price': '\$65/hour',
      'priceValue': 65,
      'location': 'Uptown',
      'availability': 'Available tomorrow',
      'specialization': 'Commercial plumbing',
      'image': 'https://randomuser.me/api/portraits/women/2.jpg',
    },
    {
      'name': 'Mike Williams',
      'rating': 4.7,
      'experience': '5 years',
      'price': '\$45/hour',
      'priceValue': 45,
      'location': 'Westside',
      'availability': 'Available today',
      'specialization': 'Emergency repairs',
      'image': 'https://randomuser.me/api/portraits/men/3.jpg',
    },
    {
      'name': 'Emily Davis',
      'rating': 4.6,
      'experience': '7 years',
      'price': '\$55/hour',
      'priceValue': 55,
      'location': 'Eastside',
      'availability': 'Available in 2 days',
      'specialization': 'Leak detection and repair',
      'image': 'https://randomuser.me/api/portraits/women/4.jpg',
    },
    {
      'name': 'Robert Johnson',
      'rating': 4.9,
      'experience': '15 years',
      'price': '\$75/hour',
      'priceValue': 75,
      'location': 'Downtown',
      'availability': 'Available tomorrow',
      'specialization': 'Pipe installation and repair',
      'image': 'https://randomuser.me/api/portraits/men/5.jpg',
    },
    {
      'name': 'Jennifer Lopez',
      'rating': 4.5,
      'experience': '6 years',
      'price': '\$60/hour',
      'priceValue': 60,
      'location': 'Northside',
      'availability': 'Available today',
      'specialization': 'Bathroom remodeling',
      'image': 'https://randomuser.me/api/portraits/women/6.jpg',
    },
    {
      'name': 'David Wilson',
      'rating': 4.3,
      'experience': '4 years',
      'price': '\$40/hour',
      'priceValue': 40,
      'location': 'Southside',
      'availability': 'Available today',
      'specialization': 'Drain cleaning',
      'image': 'https://randomuser.me/api/portraits/men/7.jpg',
    },
    {
      'name': 'Amanda Clark',
      'rating': 4.7,
      'experience': '9 years',
      'price': '\$70/hour',
      'priceValue': 70,
      'location': 'Uptown',
      'availability': 'Available in 3 days',
      'specialization': 'Water heater installation',
      'image': 'https://randomuser.me/api/portraits/women/8.jpg',
    },
    {
      'name': 'Thomas Brown',
      'rating': 4.8,
      'experience': '11 years',
      'price': '\$80/hour',
      'priceValue': 80,
      'location': 'Westside',
      'availability': 'Available tomorrow',
      'specialization': 'Commercial plumbing',
      'image': 'https://randomuser.me/api/portraits/men/9.jpg',
    },
    {
      'name': 'Jessica Martinez',
      'rating': 4.4,
      'experience': '5 years',
      'price': '\$55/hour',
      'priceValue': 55,
      'location': 'Eastside',
      'availability': 'Available today',
      'specialization': 'Residential plumbing',
      'image': 'https://randomuser.me/api/portraits/women/10.jpg',
    },
    {
      'name': 'Daniel Taylor',
      'rating': 4.9,
      'experience': '14 years',
      'price': '\$90/hour',
      'priceValue': 90,
      'location': 'Downtown',
      'availability': 'Available in 2 days',
      'specialization': 'High-end installations',
      'image': 'https://randomuser.me/api/portraits/men/11.jpg',
    },
    {
      'name': 'Sophia Anderson',
      'rating': 4.6,
      'experience': '7 years',
      'price': '\$65/hour',
      'priceValue': 65,
      'location': 'Suburbs',
      'availability': 'Available tomorrow',
      'specialization': 'Leak detection',
      'image': 'https://randomuser.me/api/portraits/women/12.jpg',
    },
    {
      'name': 'James Wilson',
      'rating': 4.2,
      'experience': '3 years',
      'price': '\$45/hour',
      'priceValue': 45,
      'location': 'Northside',
      'availability': 'Available today',
      'specialization': 'General plumbing',
      'image': 'https://randomuser.me/api/portraits/men/13.jpg',
    },
    {
      'name': 'Olivia Garcia',
      'rating': 4.7,
      'experience': '8 years',
      'price': '\$70/hour',
      'priceValue': 70,
      'location': 'Southside',
      'availability': 'Available in 3 days',
      'specialization': 'Bathroom fixtures',
      'image': 'https://randomuser.me/api/portraits/women/14.jpg',
    },
    {
      'name': 'William Harris',
      'rating': 5.0,
      'experience': '20 years',
      'price': '\$120/hour',
      'priceValue': 120,
      'location': 'Downtown',
      'availability': 'Available next week',
      'specialization': 'Master plumber, all services',
      'image': 'https://randomuser.me/api/portraits/men/15.jpg',
    },
    {
      'name': 'Emma Lewis',
      'rating': 4.5,
      'experience': '6 years',
      'price': '\$60/hour',
      'priceValue': 60,
      'location': 'Uptown',
      'availability': 'Available tomorrow',
      'specialization': 'Residential repairs',
      'image': 'https://randomuser.me/api/portraits/women/16.jpg',
    },
    {
      'name': 'Michael Robinson',
      'rating': 4.3,
      'experience': '5 years',
      'price': '\$50/hour',
      'priceValue': 50,
      'location': 'Westside',
      'availability': 'Available today',
      'specialization': 'Drain cleaning',
      'image': 'https://randomuser.me/api/portraits/men/17.jpg',
    },
    {
      'name': 'Ava Walker',
      'rating': 4.8,
      'experience': '10 years',
      'price': '\$85/hour',
      'priceValue': 85,
      'location': 'Eastside',
      'availability': 'Available in 2 days',
      'specialization': 'Kitchen remodeling',
      'image': 'https://randomuser.me/api/portraits/women/18.jpg',
    },
    {
      'name': 'Ethan Young',
      'rating': 4.1,
      'experience': '2 years',
      'price': '\$40/hour',
      'priceValue': 40,
      'location': 'Suburbs',
      'availability': 'Available today',
      'specialization': 'Assistant plumber',
      'image': 'https://randomuser.me/api/portraits/men/19.jpg',
    },
    {
      'name': 'Isabella King',
      'rating': 4.9,
      'experience': '13 years',
      'price': '\$95/hour',
      'priceValue': 95,
      'location': 'Downtown',
      'availability': 'Available next week',
      'specialization': 'Commercial systems',
      'image': 'https://randomuser.me/api/portraits/women/20.jpg',
    },
  ];

  // Filtered list of plumbers based on selected filters
  List<Map<String, dynamic>> _filteredPlumbers = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered plumbers with all plumbers
    _filteredPlumbers = List.from(_allPlumbers);

    // Pre-fill user information if available
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userData = await _firestore.collection('users').doc(user.uid).get();
        if (userData.exists) {
          final data = userData.data() as Map<String, dynamic>;
          setState(() {
            _nameController.text = user.displayName ?? data['name'] ?? '';
            // If there's a phone number stored, use it
            if (data.containsKey('phone')) {
              _phoneController.text = data['phone'];
            }
            // If there's an address stored, use it
            if (data.containsKey('address')) {
              _addressController.text = data['address'];
            }
          });
        }
      } catch (e) {
        // Handle error silently
        debugPrint('Error loading user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Apply filters to the plumber list
  void _applyFilters() {
    setState(() {
      _filteredPlumbers = _allPlumbers.where((plumber) {
        // Filter by location
        bool locationMatch = _selectedLocation == 'All Locations' ||
            plumber['location'] == _selectedLocation;

        // Filter by price range
        bool priceMatch = true;
        if (_selectedPriceRange != 'All Prices') {
          int price = plumber['priceValue'];

          if (_selectedPriceRange == 'Under \$50/hour') {
            priceMatch = price < 50;
          } else if (_selectedPriceRange == '\$50-\$75/hour') {
            priceMatch = price >= 50 && price <= 75;
          } else if (_selectedPriceRange == '\$75-\$100/hour') {
            priceMatch = price > 75 && price <= 100;
          } else if (_selectedPriceRange == 'Over \$100/hour') {
            priceMatch = price > 100;
          }
        }

        // Filter by rating
        bool ratingMatch = plumber['rating'] >= _minRating;

        return locationMatch && priceMatch && ratingMatch;
      }).toList();
    });
  }

  // Reset all filters
  void _resetFilters() {
    setState(() {
      _selectedLocation = 'All Locations';
      _selectedPriceRange = 'All Prices';
      _minRating = 0.0;
      _filteredPlumbers = List.from(_allPlumbers);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('EEEE, MMMM d, yyyy').format(picked);
      });

      // After selecting a date, prompt for time
      _selectTime(context);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;

        // Update the date text to include the time
        if (_selectedDate != null) {
          _dateController.text = '${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!)} at ${picked.format(context)}';
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedPlumber != null && _selectedDate != null && _selectedTime != null) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Find the selected plumber details
        final selectedPlumberDetails = _allPlumbers.firstWhere(
              (plumber) => plumber['name'] == _selectedPlumber,
          orElse: () => _allPlumbers[0],
        );

        // Get current user
        final user = _auth.currentUser;
        if (user == null) {
          Navigator.of(context).pop(); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You must be logged in to book a plumber')),
          );
          return;
        }

        // Create booking data
        final bookingData = {
          'userId': user.uid,
          'userName': _nameController.text,
          'userPhone': _phoneController.text,
          'userAddress': _addressController.text,
          'notes': _notesController.text,
          'plumberName': _selectedPlumber,
          'plumberDetails': selectedPlumberDetails,
          'bookingDate': Timestamp.fromDate(_selectedDate!),
          'bookingTime': '${_selectedTime!.hour}:${_selectedTime!.minute}',
          'status': 'Pending',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'hasFeedback': false,
        };

        // Save to Firestore
        final docRef = await _firestore.collection('bookings').add(bookingData);

        // Update user profile with phone and address if not already saved
        await _firestore.collection('users').doc(user.uid).update({
          'phone': _phoneController.text,
          'address': _addressController.text,
        });

        // Close loading dialog
        Navigator.of(context).pop();

        // Navigate to confirmation screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlumberConfirmationScreen(
              bookingId: docRef.id,
              plumberName: _selectedPlumber!,
              plumberDetails: selectedPlumberDetails,
              bookingDate: _selectedDate!,
              bookingTime: _selectedTime!,
              customerName: _nameController.text,
              address: _addressController.text,
              phone: _phoneController.text,
              notes: _notesController.text,
            ),
          ),
        );
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();

        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else if (_selectedPlumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a plumber')),
      );
    } else if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Plumber'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.plumbing,
                        size: 40,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Professional Plumbing Service',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Book a certified plumber to fix your leaks',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  'Your Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Phone field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Address field
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: const Icon(Icons.home),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Date field
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Preferred Date & Time',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_month),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date and time';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Notes field
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Describe the issue or any special instructions',
                    prefixIcon: const Icon(Icons.note),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),

                const SizedBox(height: 24),

                // Plumber selection section with filters
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select a Plumber',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                      },
                      icon: Icon(_showFilters ? Icons.filter_list_off : Icons.filter_list),
                      label: Text(_showFilters ? 'Hide Filters' : 'Show Filters'),
                    ),
                  ],
                ),

                // Filters section
                if (_showFilters) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Filter Plumbers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location filter
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            prefixIcon: Icon(Icons.location_on),
                          ),
                          value: _selectedLocation,
                          items: _locations.map((location) {
                            return DropdownMenuItem(
                              value: location,
                              child: Text(location),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedLocation = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Price range filter
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Price Range',
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          value: _selectedPriceRange,
                          items: _priceRanges.map((range) {
                            return DropdownMenuItem(
                              value: range,
                              child: Text(range),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedPriceRange = value;
                              });
                            }
                          },
                        ),

                        const SizedBox(height: 16),

                        // Rating filter
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Minimum Rating: ${_minRating.toStringAsFixed(1)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Slider(
                              value: _minRating,
                              min: 0,
                              max: 5,
                              divisions: 10,
                              label: _minRating.toStringAsFixed(1),
                              onChanged: (value) {
                                setState(() {
                                  _minRating = value;
                                });
                              },
                            ),
                            Row(
                              children: [
                                for (int i = 0; i <= 5; i++)
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        i.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Filter action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _resetFilters,
                                child: const Text('Reset'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _applyFilters,
                                child: const Text('Apply Filters'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Show filter results count
                  Text(
                    'Showing ${_filteredPlumbers.length} plumbers',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Plumber selection list
                if (_filteredPlumbers.isEmpty) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No plumbers match your filters',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your filter criteria',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: _resetFilters,
                            child: const Text('Reset Filters'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredPlumbers.length,
                    itemBuilder: (context, index) {
                      final plumber = _filteredPlumbers[index];
                      final isSelected = _selectedPlumber == plumber['name'];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: RadioListTile<String>(
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(plumber['image']),
                                radius: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  plumber['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(left: 32.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Colors.amber,
                                    ),
                                    Text(
                                      ' ${plumber['rating']} • ${plumber['experience']} experience',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.blue.shade700,
                                    ),
                                    Text(
                                      ' ${plumber['location']} • ${plumber['price']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.work,
                                      size: 16,
                                      color: Colors.green.shade700,
                                    ),
                                    Expanded(
                                      child: Text(
                                        ' ${plumber['specialization']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.orange.shade700,
                                    ),
                                    Text(
                                      ' ${plumber['availability']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          value: plumber['name'],
                          groupValue: _selectedPlumber,
                          onChanged: (value) {
                            setState(() {
                              _selectedPlumber = value;
                            });
                          },
                          activeColor: Colors.blue,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      );
                    },
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Book Plumber',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlumberConfirmationScreen extends StatefulWidget {
  final String bookingId;
  final String plumberName;
  final Map<String, dynamic> plumberDetails;
  final DateTime bookingDate;
  final TimeOfDay bookingTime;
  final String customerName;
  final String address;
  final String phone;
  final String notes;

  const PlumberConfirmationScreen({
    Key? key,
    required this.bookingId,
    required this.plumberName,
    required this.plumberDetails,
    required this.bookingDate,
    required this.bookingTime,
    required this.customerName,
    required this.address,
    required this.phone,
    required this.notes,
  }) : super(key: key);

  @override
  State<PlumberConfirmationScreen> createState() => _PlumberConfirmationScreenState();
}

class _PlumberConfirmationScreenState extends State<PlumberConfirmationScreen> {
  bool _showFeedbackForm = false;
  bool _feedbackSubmitted = false;
  bool _showEditForm = false;

  final _feedbackFormKey = GlobalKey<FormState>();
  final _editFormKey = GlobalKey<FormState>();

  final TextEditingController _feedbackController = TextEditingController();
  late TextEditingController _editDateController;
  late TextEditingController _editNotesController;

  double _rating = 5.0;
  DateTime? _editDate;
  TimeOfDay? _editTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _editDateController = TextEditingController(
        text: '${DateFormat('EEEE, MMMM d, yyyy').format(widget.bookingDate)} at ${widget.bookingTime.format(context)}'
    );
    _editNotesController = TextEditingController(text: widget.notes);
    _editDate = widget.bookingDate;
    _editTime = widget.bookingTime;
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _editDateController.dispose();
    _editNotesController.dispose();
    super.dispose();
  }

  Future<void> _selectEditDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _editDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _editDate) {
      setState(() {
        _editDate = picked;
        _editDateController.text = DateFormat('EEEE, MMMM d, yyyy').format(picked);
      });

      // After selecting a date, prompt for time
      _selectEditTime(context);
    }
  }

  Future<void> _selectEditTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _editTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue.shade700,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _editTime) {
      setState(() {
        _editTime = picked;

        // Update the date text to include the time
        if (_editDate != null) {
          _editDateController.text = '${DateFormat('EEEE, MMMM d, yyyy').format(_editDate!)} at ${picked.format(context)}';
        }
      });
    }
  }

  Future<void> _submitFeedback() async {
    if (_feedbackFormKey.currentState!.validate()) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Save feedback to Firestore
        await _firestore.collection('feedback').add({
          'bookingId': widget.bookingId,
          'plumberName': widget.plumberName,
          'rating': _rating,
          'feedback': _feedbackController.text,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Update booking to mark feedback as submitted
        await _firestore.collection('bookings').doc(widget.bookingId).update({
          'hasFeedback': true,
        });

        // Close loading dialog
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thank you for your feedback!')),
        );

        setState(() {
          _showFeedbackForm = false;
          _feedbackSubmitted = true;
        });
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();

        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting feedback: $e')),
        );
      }
    }
  }

  Future<void> _saveEditedBooking() async {
    if (_editFormKey.currentState!.validate() && _editDate != null && _editTime != null) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Update booking in Firestore
        await _firestore.collection('bookings').doc(widget.bookingId).update({
          'bookingDate': Timestamp.fromDate(_editDate!),
          'bookingTime': '${_editTime!.hour}:${_editTime!.minute}',
          'notes': _editNotesController.text,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Close loading dialog
        Navigator.of(context).pop();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking updated successfully!')),
        );

        setState(() {
          _showEditForm = false;
        });
      } catch (e) {
        // Close loading dialog
        Navigator.of(context).pop();

        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating booking: $e')),
        );
      }
    }
  }

  Future<void> _cancelBooking() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              // Close dialog
              Navigator.pop(context);

              try {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                // Update booking status in Firestore
                await _firestore.collection('bookings').doc(widget.bookingId).update({
                  'status': 'Cancelled',
                  'updatedAt': FieldValue.serverTimestamp(),
                });

                // Close loading dialog
                Navigator.of(context).pop();

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking cancelled successfully')),
                );

                // Navigate back to home screen
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              } catch (e) {
                // Close loading dialog
                Navigator.of(context).pop();

                // Show error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error cancelling booking: $e')),
                );
              }
            },
            child: const Text('Yes, Cancel'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_showEditForm) ...[
              _buildEditForm(),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Plumber Booked Successfully!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your booking has been confirmed',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.plumberDetails['image']),
                          radius: 30,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.plumberName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                  Text(
                                    ' ${widget.plumberDetails['rating']} • ${widget.plumberDetails['experience']} experience',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Date',
                      DateFormat('EEEE, MMMM d, yyyy').format(widget.bookingDate),
                    ),
                    const Divider(height: 24),
                    _buildInfoRow('Time', widget.bookingTime.format(context)),
                    const Divider(height: 24),
                    _buildInfoRow('Service Rate', widget.plumberDetails['price']),
                    const Divider(height: 24),
                    _buildInfoRow('Location', widget.plumberDetails['location']),
                    const Divider(height: 24),
                    _buildInfoRow('Specialization', widget.plumberDetails['specialization']),

                    const SizedBox(height: 24),
                    const Text(
                      'Customer Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name', widget.customerName),
                    const Divider(height: 24),
                    _buildInfoRow('Phone', widget.phone),
                    const Divider(height: 24),
                    _buildInfoRow('Address', widget.address),
                    if (widget.notes.isNotEmpty) ...[
                      const Divider(height: 24),
                      _buildInfoRow('Notes', widget.notes),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You will receive a confirmation email with all the details. The plumber will contact you before the visit.',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Edit and Cancel buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showEditForm = true;
                        });
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Booking'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _cancelBooking,
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel Booking'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Feedback section
              if (!_showFeedbackForm && !_feedbackSubmitted) ...[
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _showFeedbackForm = true;
                    });
                  },
                  icon: const Icon(Icons.feedback),
                  label: const Text('Submit Feedback'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ] else if (_feedbackSubmitted) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Thanks for the feedback!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else if (_showFeedbackForm) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Form(
                    key: _feedbackFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Service Feedback',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'How would you rate your experience?',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Star rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 1; i <= 5; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _rating = i.toDouble();
                                  });
                                },
                                child: Icon(
                                  i <= _rating ? Icons.star : Icons.star_border,
                                  color: Colors.amber,
                                  size: 40,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Feedback text field
                        TextFormField(
                          controller: _feedbackController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Your Feedback',
                            hintText: 'Tell us about your experience with the plumber',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your feedback';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Submit and cancel buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _showFeedbackForm = false;
                                  });
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _submitFeedback,
                                child: const Text('Submit Feedback'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to home screen
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Go to Home',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _editFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Booking',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Plumber info (non-editable)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.plumberDetails['image']),
                  radius: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plumberName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.plumberDetails['specialization'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Date and time field (editable)
          TextFormField(
            controller: _editDateController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Date & Time',
              prefixIcon: const Icon(Icons.calendar_today),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _selectEditDate(context),
              ),
            ),
            onTap: () => _selectEditDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a date and time';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Notes field (editable)
          TextFormField(
            controller: _editNotesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Describe the issue or any special instructions',
              prefixIcon: const Icon(Icons.note),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _showEditForm = false;
                    });
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveEditedBooking,
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}