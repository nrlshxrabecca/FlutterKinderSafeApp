import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _teacherIdController = TextEditingController();
  final _emailController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _profileImage; // For profile picture
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch user data from Firebase
  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;

    if (user != null) {
      final userId = user.uid;

      // Fetch additional data from Firestore
      final userDoc = await _firestore.collection('users').doc(userId).get();

      setState(() {
        _emailController.text = user.email ?? ''; // Get email from FirebaseAuth

        // Populate other fields from Firestore
        if (userDoc.exists) {
          _nameController.text = userDoc['name'] ?? '';
          _phoneController.text = userDoc['phone'] ?? '';
          _teacherIdController.text = userDoc['teacherId'] ?? '';
        }
      });
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData() async {
    final userId = _auth.currentUser?.uid;

    if (userId != null) {
      await _firestore.collection('users').doc(userId).set({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'teacherId': _teacherIdController.text,
        'email': _emailController.text, // Keep email synced with FirebaseAuth
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );
    }
  }

  // Change password
  Future<void> _changePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  // Pick profile image
  Future<void> _pickProfileImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

             // Profile Picture
              Center(
                child: GestureDetector(
                  onTap: _pickProfileImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null, // No image when _profileImage is null
                        backgroundColor: _profileImage != null
                            ? Colors.transparent // Transparent when an image is selected
                            : Colors.black, // Blackout effect when no image is selected
                      ),
                      if (_profileImage == null) // Only show icon when there's no profile image
                        const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                          size: 30,
                        ),
                    ],
                  ),
                ),
              ),

              // Add spacing between the profile picture and Name field
              const SizedBox(height: 30),

              // Name Field
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Phone Field
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Teacher ID Field
              TextField(
                controller: _teacherIdController,
                decoration: const InputDecoration(
                  labelText: "Teacher ID/Position",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Email Field (Read-Only)
              TextField(
                controller: _emailController,
                readOnly: true, // Prevent editing
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Password Change Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String? newPassword = await _showPasswordChangeDialog();
                    if (newPassword != null && newPassword.isNotEmpty) {
                      _changePassword(newPassword);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Change Password",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Save Changes Button
              Center(
                child: ElevatedButton(
                  onPressed: _saveUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show Password Change Dialog
  Future<String?> _showPasswordChangeDialog() async {
    String newPassword = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: TextField(
            onChanged: (value) {
              newPassword = value;
            },
            decoration: const InputDecoration(
              labelText: "New Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(newPassword),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              child: const Text("Change"),
            ),
          ],
        );
      },
    );
  }
}
