import 'package:flutter/material.dart';
import 'package:kindersafeapp/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'staff_login.dart'; // Replace with your actual login screen implementation

class StaffDashboard extends StatelessWidget {
  StaffDashboard({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  // Sign-out method
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

  // Dashboard title
  Widget buildTitle() {
    return const Text(
      'Staff Dashboard',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  // Display user's email
  Widget buildUserEmail() {
    return Text(
      'Logged in as: ${user?.email ?? 'Unknown'}',
      style: const TextStyle(
        fontSize: 16,
        color: Colors.grey,
      ),
      textAlign: TextAlign.center,
    );
  }

  // Sign-out button
  Widget buildSignOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => signOut(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Sign Out',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 20),
              buildUserEmail(),
              const SizedBox(height: 40),
              buildSignOutButton(context),
            ],
          ),
        ),
      ),
    );
  }
}
