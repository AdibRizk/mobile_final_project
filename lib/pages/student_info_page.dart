import 'dart:math';
import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/students_service.dart';
import 'all_students.dart';

class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({super.key});

  @override
  State<StudentInfoPage> createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();

  final List<Map<String, String>> majors = [
    {"name": "Computer Science", "code": "CS"},
    {"name": "Information Technology", "code": "IT"},
    {"name": "Mathematics", "code": "MATH"},
    {"name": "Business Administration", "code": "BA"},
    {"name": "Mechanical Engineering", "code": "ME"},
    {"name": "Civil Engineering", "code": "CE"},
    {"name": "Nursing", "code": "NUR"},
    {"name": "Psychology", "code": "PSY"},
    {"name": "Graphic Design", "code": "GD"},
    {"name": "Accounting", "code": "ACC"},
  ];

  String? selectedMajorName;
  String? selectedMajorCode;

  // Keep last created student (optional for future use)
  Student? savedStudent;

  bool loading = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _generateStudentId() {
    final random = Random().nextInt(900000) + 100000;
    return "${selectedMajorCode!}-$random";
  }

  bool validateInputs() {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        dobController.text.trim().isEmpty ||
        selectedMajorCode == null) {
      showMessage("Please fill all fields and select the major");
      return false;
    }
    return true;
  }

  Future<void> createStudent() async {
    if (!validateInputs()) return;

    final studentId = _generateStudentId();

    final newStudent = Student(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      dateOfBirth: dobController.text.trim(),
      major: selectedMajorCode!,
      studentId: studentId,
    );

    try {
      setState(() {
        loading = true;
      });

      // POST student to database
      final res = await StudentsService.createStudent(newStudent);

      savedStudent = newStudent;

      setState(() {
        loading = false;
      });

      showMessage(res);

      // Clear UI after attempt
      firstNameController.clear();
      lastNameController.clear();
      phoneController.clear();
      dobController.clear();

      setState(() {
        selectedMajorName = null;
        selectedMajorCode = null;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      showMessage("Connection failed");
    }
  }

  void goToAllStudentsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AllStudentsPage()),
    );
  }

  Widget input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget majorDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        key: ValueKey(selectedMajorName),
        initialValue: selectedMajorName,
        decoration: const InputDecoration(
          labelText: "Major",
          border: OutlineInputBorder(),
        ),
        items: majors.map((m) {
          return DropdownMenuItem<String>(
            value: m["name"],
            child: Text("${m["name"]} (${m["code"]})"),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedMajorName = value;
            final found = majors.firstWhere((m) => m["name"] == value);
            selectedMajorCode = found["code"];
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Information")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            input("First Name", firstNameController),
            input("Last Name", lastNameController),
            input("Phone Number", phoneController),
            input("Date of Birth", dobController),
            majorDropdown(),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : createStudent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: loading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text("Create"),
              ),
            ),

            const SizedBox(height: 12),

            // Button to open database student details page
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: goToAllStudentsPage,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Go to Students Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
