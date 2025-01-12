import 'package:flutter/material.dart';
import './pages/staff_login.dart';
import './pages/parent_login.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kinder Safe',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
      // Define routes if needed
      routes: {
        '/index': (context) => const IndexPage(),
        '/staffLogin': (context) => const StaffLoginPage(),
        '/parentLogin': (context) => const ParentLoginPage(),
      },
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/indexscreen.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the IndexPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const IndexPage()),
                    );
                    // Alternatively, using named routes:
                    // Navigator.pushNamed(context, '/index');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    minimumSize: const Size(220, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IndexPage extends StatelessWidget {
  const IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true, // Show back button
      ),
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/indexscreen.png',
              fit: BoxFit.cover,
            ),
          ),

          // Two buttons (Staff, Parent) aligned at the bottom
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Staff Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StaffLoginPage(),
                      ),
                    );
                    // Alternatively, using named routes:
                    // Navigator.pushNamed(context, '/staffLogin');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    minimumSize: const Size(170, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Staff',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),

                // Parent Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ParentLoginPage(),
                      ),
                    );
                    // Alternatively, using named routes:
                    // Navigator.pushNamed(context, '/parentLogin');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    minimumSize: const Size(170, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Parent',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
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

// // Placeholder for StaffLoginPage
// class StaffLoginPage extends StatelessWidget {
//   const StaffLoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple.shade700,
//       ),
//       body: Center(
//         child: Text(
//           'Staff Login Page',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

// // Placeholder for ParentLoginPage
// class ParentLoginPage extends StatelessWidget {
//   const ParentLoginPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Parent Login'),
//         backgroundColor: Colors.purple.shade700,
//       ),
//       body: Center(
//         child: Text(
//           'Parent Login Page',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
