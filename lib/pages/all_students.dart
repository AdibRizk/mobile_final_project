import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/students_service.dart';

class AllStudentsPage extends StatefulWidget {
  const AllStudentsPage({super.key});

  @override
  State<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends State<AllStudentsPage> {
  List<Student> _students = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() => _loading = true);
    _students = await StudentsService.getAllStudents();
    setState(() => _loading = false);
  }

  Future<void> _deleteStudent(int index) async {
    final studentId = _students[index].studentId;

    final res = await StudentsService.deleteStudent(studentId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(res)),
    );

    // remove locally (simple)
    setState(() {
      _students.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Students'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchStudents,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
          ? const Center(child: Text('No students found'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final s = _students[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              // ✅ delete icon in front of ID
              title: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteStudent(index),
                  ),
                  Expanded(
                    child: Text(
                      "ID: ${s.studentId}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 48.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${s.firstName} ${s.lastName}"),
                    Text("Phone: ${s.phoneNumber}"),
                    Text("DOB: ${s.dateOfBirth}"),
                    Text("Major: ${s.major}"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
