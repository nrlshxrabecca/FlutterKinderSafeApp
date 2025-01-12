import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const WidgetTree());
}

class WidgetTree extends StatelessWidget {
  const WidgetTree ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinder Safe App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const WidgetTree(),
    );
  }
}
