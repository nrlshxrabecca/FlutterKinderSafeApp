import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_profile.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Report',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/report.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim().toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search student name',
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 20),

                // List of Student Reports
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('students')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text('No reports found.'));
                      }

                      final filteredDocs = snapshot.data!.docs.where((doc) {
                        final name = (doc['name'] as String).toLowerCase();
                        return name.contains(_searchQuery);
                      }).toList();

                      return ListView.separated(
                        itemCount: filteredDocs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final student = filteredDocs[index];
                          return _buildStudentReportCard(student);
                        },
                      );
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

  Widget _buildStudentReportCard(DocumentSnapshot student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture Placeholder and Name Below
          Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                child: student['profileImage'] != null && student['profileImage'].isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          student['profileImage'],
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    : ClipOval(
                        child: Image.asset(
                          'assets/icons/profile_icon.png',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 8),  // Space between image and name
              Text(
                student['name'] ?? 'N/A',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),

          // Student Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student['fullname'] ?? 'N/A',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Text(
                  'Parent: ${student['parentName'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Text(
                  'Phone: ${student['phone'] ?? 'N/A'}',
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          // Print Icon (Navigate to Student Profile)
          IconButton(
            icon: const Icon(Icons.print, color: Colors.black54, size: 50),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StudentProfile(
                    studentId: student.id,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
