import 'package:flutter/material.dart';

class ParentLoginPage extends StatelessWidget {
  const ParentLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Login'),
      ),
      body: const Center(
        child: Text(
          'Parent Login Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
