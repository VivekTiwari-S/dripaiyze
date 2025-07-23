import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_screen.dart';
import 'booking_history_screen.dart';
import 'privacy_policy_screen.dart';
import 'about_us_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _userName = "User";
  String _userEmail = "";
  String? _userPhotoUrl;
  bool _notificationsEnabled = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadSettings();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Try to get user data from Firestore first for more complete info
        try {
          final userData = await _firestore.collection('users').doc(user.uid).get();
          if (userData.exists) {
            setState(() {
              _userName = userData.data()?['name'] ?? user.displayName ?? 'User';
              _userEmail = userData.data()?['email'] ?? user.email ?? '';
              _userPhotoUrl = userData.data()?['photoURL'] ?? user.photoURL;
            });
          } else {
            // Fallback to Firebase Auth user data
            setState(() {
              _userName = user.displayName ?? 'User';
              _userEmail = user.email ?? '';
              _userPhotoUrl = user.photoURL;
            });
          }
        } catch (e) {
          print("Error loading user data from Firestore: $e");
          // Fallback to Firebase Auth user data
          setState(() {
            _userName = user.displayName ?? 'User';
            _userEmail = user.email ?? '';
            _userPhotoUrl = user.photoURL;
          });
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      });
    } catch (e) {
      print("Error loading settings: $e");
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

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      // Navigate to auth screen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
            (route) => false,
      );
    } catch (e) {
      print("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to log out. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Profile picture
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blue.shade100,
                      backgroundImage: _userPhotoUrl != null
                          ? NetworkImage(_userPhotoUrl!)
                          : null,
                      child: _userPhotoUrl == null
                          ? Text(
                        _userName.isNotEmpty
                            ? _userName[0].toUpperCase()
                            : 'U',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      )
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // User name
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // User email
                    Text(
                      _userEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Edit profile button
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement edit profile functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit profile coming soon!'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Preferences',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Preferences section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                children: [
                  // Notifications toggle
                  SwitchListTile(
                    title: const Text('Notifications'),
                    subtitle: const Text('Enable push notifications'),
                    value: _notificationsEnabled,
                    onChanged: (value) => _toggleNotifications(),
                    secondary: Icon(
                      _notificationsEnabled
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: _notificationsEnabled
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),
                  // const Divider(),


                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'General Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Account section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Column(
                children: [

                  // Show booking history
                  ListTile(
                    leading: const Icon(Icons.history, color: Colors.blue),
                    title: const Text('Plumber booking history'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Navigate to privacy policy
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BookingHistoryScreen()),
                      );
                    },
                  ),
                  const Divider(),

                  // Privacy policy
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: Colors.blue),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Navigate to privacy policy
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                      );
                    },
                  ),
                  const Divider(),

                  // About Us
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.blue),
                    title: const Text('About Us'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // TODO: Navigate to terms of service
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AboutUsScreen()),
                      );
                    },
                  ),
                  const Divider(),

                  // App version
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Colors.blue),
                    title: const Text('App Version'),
                    trailing: const Text("1.0.0"),
                  ),
                  const Divider(),

                  // Logout
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    onTap: _logout,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // App info
            Center(
              child: Column(
                children: [
                  Text(
                    'DripAIyze',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '© ${DateTime.now().year} DripAIyze. All rights reserved.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}