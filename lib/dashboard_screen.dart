import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'leak_detection_screen.dart';
import 'plumber_booking_form.dart';
import 'settings_screen.dart';
import 'auth_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _notificationsEnabled = true;
  String _userName = "User";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadNotificationPreference();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user and refresh token
      final user = _auth.currentUser;
      if (user == null) {
        // If no user is logged in, navigate to auth screen
        _navigateToAuth();
        return;
      }

      // Try to reload user to get fresh data
      try {
        await user.reload();
      } catch (e) {
        print("Error reloading user: $e");
        // Continue with existing user data
      }

      // Get display name
      final displayName = user.displayName;
      if (displayName != null && displayName.isNotEmpty) {
        setState(() {
          _userName = displayName.split(' ')[0]; // Get first name
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      // Handle error - maybe show a snackbar
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToAuth() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false,
    );
  }

  Future<void> _loadNotificationPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      });
    } catch (e) {
      print("Error loading notification preferences: $e");
    }
  }

  Future<void> _toggleNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _notificationsEnabled = !_notificationsEnabled;
      });
      await prefs.setBool('notifications_enabled', _notificationsEnabled);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_notificationsEnabled
              ? 'Notifications enabled'
              : 'Notifications disabled'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print("Error toggling notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'lib/assets/logo.png',
              height: 40,
              width: 40,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.water_drop,
                color: Colors.blue.shade700,
                size: 30,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DripAIyze',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Because, every drop counts!',
                  style: TextStyle(
                    color: Colors.blue.shade400,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _notificationsEnabled
                  ? Icons.notifications_active_outlined
                  : Icons.notifications_off_outlined,
              color: _notificationsEnabled ? Colors.blue : Colors.grey,
            ),
            onPressed: _toggleNotifications,
            tooltip: _notificationsEnabled ? 'Disable notifications' : 'Enable notifications',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen())
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome back, $_userName!',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ClipRRect(
                borderRadius: BorderRadius.circular(16), // Adjust the value as needed
                child: Image.asset(
                  'lib/assets/water_scarcity.jpg',
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 24),

              // Fact tile
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.blueAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'The Water Fact',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'While Earth is covered in water, a staggering 97% is saltwater, and only 3% is freshwater, with two-thirds of that locked away in glaciers and ice caps, leaving less than 1% readily accessible for human use.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),

              const SizedBox(height: 16),

              // Feature cards
              _buildFeatureCard(
                'Detect Leak',
                'Start monitoring for water leaks in real-time',
                Icons.warning_amber_rounded,
                Colors.red.shade400,
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetectLeakScreen())
                  );
                },
              ),

              const SizedBox(height: 16),
              _buildFeatureCard(
                'Book a Plumber',
                'Schedule a professional plumber visit',
                Icons.plumbing,
                Colors.blue.shade400,
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PlumberBookingForm())
                  );
                },
              ),

              const SizedBox(height: 16),
              _buildFeatureCard(
                'Settings',
                'Manage your profile, notifications and preferences',
                Icons.settings,
                Colors.grey.shade700,
                    () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen())
                  );
                },
              ),

              const SizedBox(height: 24),
              // Water saving tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.amber.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Water Saving Tip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fix that dripping tap! A tap that drips once per second can waste more than 3,000 gallons of water per year.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      String title,
      String description,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 1),
              blurRadius: 10,
              offset: const Offset(0, 4),

            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}