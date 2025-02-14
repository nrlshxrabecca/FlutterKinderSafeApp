import 'package:flutter/material.dart';
import 'package:kindersafeapp/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kindersafeapp/pages/report_page.dart';
import 'staff_login.dart';
import 'staff_profile.dart';
import '../screens/qr_scanner.dart';

class StaffDashboard extends StatefulWidget {
  const StaffDashboard({Key? key}) : super(key: key);

  @override
  _StaffDashboardState createState() => _StaffDashboardState();
}

class _StaffDashboardState extends State<StaffDashboard> {
  final User? user = Auth().currentUser;
  String userName = 'Loading...';
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> _fetchUserData() async {
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      setState(() {
        userName = userDoc.data()?['name'] ?? 'No Name Found';
        _profileImage = userDoc.data()?['profileImage'];
      });
    }
  }

  // Sign out the user
  Future<void> signOut(BuildContext context) async {
    try {
      await Auth().signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const StaffLoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing out: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/dashboard.png',
              fit: BoxFit.cover,
            ),
          ),

          // Top-left logout button
          Positioned(
            top: 40,
            left: 20,
            child: ElevatedButton(
              onPressed: () => signOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Foreground content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 105.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Row
                Row(
                  children: [
                    // Profile Picture
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: _profileImage != null
                          ? NetworkImage(_profileImage!) // Use uploaded image URL
                          : const AssetImage('assets/icons/profile_icon.png')
                              as ImageProvider, // Fallback default
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(width: 20),

                    // Welcome and Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome!',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Recent Profiles Section
                const RecentProfiles(
                  size: 70,
                  backgroundColor: Colors.lightBlueAccent,
                ),
                const SizedBox(height: 20),

                // Profile Settings and Report Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(
                      imagePath: 'assets/icons/report.png',
                      label: 'Report',
                      color: Colors.red,
                      size: MediaQuery.of(context).size.width * 0.4,
                      backgroundColor: Colors.red.shade50,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const ReportPage()),
                        );
                      },
                    ),
                    _ActionButton(
                      imagePath: 'assets/icons/profile.png',
                      label: 'Profile Settings',
                      color: Colors.orange,
                      size: MediaQuery.of(context).size.width * 0.4,
                      backgroundColor: Colors.orange.shade50,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const ProfileSettingsPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Scanner Section
                Center(
                  child: _ActionButton(
                    icon: Icons.qr_code_scanner,
                    label: 'Scanner',
                    color: Colors.black,
                    size: MediaQuery.of(context).size.width * 0.4,
                    backgroundColor: Colors.green.shade50,
                    // onPressed: () {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(content: Text("Scanner Coming Soon!")),
                    //   );
                    // },
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QRScannerScreen()),
                      );

                      if (result != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Scanned QR: $result")),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for Recent Profiles
class RecentProfiles extends StatefulWidget {
  final double size;
  final Color backgroundColor;

  const RecentProfiles({
    Key? key,
    required this.size,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _RecentProfilesState createState() => _RecentProfilesState();
}

class _RecentProfilesState extends State<RecentProfiles> {
  List<Map<String, dynamic>> recentProfiles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentProfiles();
  }

  Future<void> _fetchRecentProfiles() async {
    try {
      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day);
      
      final querySnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .orderBy('timestamp', descending: true) // Latest first
          .limit(4) // Limit to 4 recent profiles
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          recentProfiles =
              querySnapshot.docs.map((doc) => doc.data()).toList();
        });
      } else {
        setState(() {
          recentProfiles = [];
        });
      }
    } catch (e) {
      print("Error fetching recent profiles: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : recentProfiles.isEmpty
              ? const Center(
                  child: Text(
                    "No recent record found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : Stack(
                  children: [
                    Row(
                      children: recentProfiles.map((profile) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            radius: widget.size / 2,
                            backgroundImage: _getProfileImage(profile['profileImage']),
                            backgroundColor: Colors.grey[300],
                          ),
                        );
                      }).toList(),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to full list of profiles
                        },
                        child: const Text(
                          'See More',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  ImageProvider _getProfileImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const AssetImage('assets/icons/profile_icon.png');
    }
    return NetworkImage(imageUrl);
  }
}

// Custom Action Button Widget
class _ActionButton extends StatelessWidget {
  final IconData? icon;
  final String? imagePath;
  final String label;
  final Color color;
  final double size;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  const _ActionButton({
    Key? key,
    this.icon,
    this.imagePath,
    required this.label,
    required this.color,
    required this.size,
    required this.backgroundColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                width: size * 0.4,
                height: size * 0.4,
                fit: BoxFit.contain,
              )
            else if (icon != null)
              Icon(
                icon,
                size: size * 0.3,
                color: color,
              ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: size * 0.08,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
