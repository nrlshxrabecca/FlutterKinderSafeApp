import 'package:flutter/material.dart';

class StaffLoginPage extends StatelessWidget {
  const StaffLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Login'),
      ),
      body: const Center(
        child: Text(
          'Staff Login Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
