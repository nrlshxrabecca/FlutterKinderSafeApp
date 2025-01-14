import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfile extends StatefulWidget {
  final String studentId; // ID of the student to fetch details
  const StudentProfile({Key? key, required this.studentId}) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentData();
  }

  Future<void> _fetchStudentData() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('students') // Ensure this matches your Firestore collection
          .doc(widget.studentId)
          .get();

      if (doc.exists) {
        setState(() {
          studentData = doc.data();
        });
      } else {
        _showSnackBar('Student not found');
      }
    } catch (e) {
      _showSnackBar('Error fetching data: ${e.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : studentData == null
              ? const Center(child: Text('No data available'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _getProfileImage(studentData!['profileImage']),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Student Details
                      ..._buildStudentDetails(),

                      const SizedBox(height: 20),

                      // Attendance Table Section
                      const Text(
                        'Attendance',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildAttendanceTable(),
                    ],
                  ),
                ),
    );
  }

  ImageProvider _getProfileImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const AssetImage('assets/icons/default_profile.png');
    }
    try {
      return NetworkImage(imageUrl);
    } catch (e) {
      return const AssetImage('assets/icons/default_profile.png');
    }
  }

  List<Widget> _buildStudentDetails() {
    final details = {
      'Name': studentData?['name'] ?? 'N/A',
      'Full Name': studentData?['fullName'] ?? 'N/A',
      'Date of Birth': studentData?['dob'] ?? 'N/A',
      'Gender': studentData?['gender'] ?? 'N/A',
      'Address': studentData?['address'] ?? 'N/A',
      'Phone': studentData?['phone'] ?? 'N/A',
      'Emergency Contact Name': studentData?['emergencyContactDetails'] ?? 'N/A',
      'Emergency Contact Phone': studentData?['emergencyContactPhone'] ?? 'N/A',
      'Parent Email': studentData?['parentEmail'] ?? 'N/A',
      'Class Name': studentData?['classname'] ?? 'N/A',
    };

    return details.entries
        .map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: _buildDetailRow(entry.key, entry.value),
            ))
        .toList();
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceTable() {
    // Replace with actual attendance data when available
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          'Attendance data is not available.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }
}
