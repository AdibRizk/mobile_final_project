import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentDetailsPage extends StatelessWidget {
  final List<Student> students;

  const StudentDetailsPage({
    super.key,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.horizontal, // allow wide table
        child: DataTable(
          columns: const [
            DataColumn(label: Text("First Name")),
            DataColumn(label: Text("Last Name")),
            DataColumn(label: Text("Phone")),
            DataColumn(label: Text("DOB")),
            DataColumn(label: Text("Major")),
            DataColumn(label: Text("Student ID")),
          ],
          rows: students.map((s) {
            return DataRow(
              cells: [
                DataCell(Text(s.firstName.isEmpty ? "Not provided" : s.firstName)),
                DataCell(Text(s.lastName.isEmpty ? "Not provided" : s.lastName)),
                DataCell(Text(s.phoneNumber.isEmpty ? "Not provided" : s.phoneNumber)),
                DataCell(Text(s.dateOfBirth.isEmpty ? "Not provided" : s.dateOfBirth)),
                DataCell(Text(s.major.isEmpty ? "Not provided" : s.major)),
                DataCell(Text(s.studentId.isEmpty ? "Not provided" : s.studentId)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
