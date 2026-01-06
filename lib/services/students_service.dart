import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

/// Base URL of your AwardSpace backend
const String baseURL = 'http:///mobiledomain.atwebpages.com';

class StudentsService {

  // ---------- GET ALL STUDENTS ----------
  static Future<List<Student>> getAllStudents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/get_students.php'),
      );

      if (response.statusCode != 200) {
        return [];
      }

      final decoded = jsonDecode(response.body);

      if (decoded["success"] != true) {
        return [];
      }

      final List data = decoded["data"];

      return data.map((s) {
        return Student(
          studentId: s["student_id"],
          firstName: s["first_name"],
          lastName: s["last_name"],
          phoneNumber: s["phone_number"],
          dateOfBirth: s["date_of_birth"],
          major: s["major"],
        );
      }).toList();

    } catch (e) {
      print("GET error: $e");
      return [];
    }
  }

  // ---------- CREATE STUDENT ----------
  static Future<String> createStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/add_student.php'),
        body: {
          "student_id": student.studentId,
          "first_name": student.firstName,
          "last_name": student.lastName,
          "phone_number": student.phoneNumber,
          "date_of_birth": student.dateOfBirth,
          "major": student.major,
        },
      );

      return response.body;

    } catch (e) {
      print("CREATE error: $e");
      return "Connection failed";
    }
  }

  // ---------- DELETE STUDENT ----------
  static Future<String> deleteStudent(String studentId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseURL/delete_student.php'),
        body: {
          "student_id": studentId,
        },
      );

      return response.body;

    } catch (e) {
      print("DELETE error: $e");
      return "Connection failed";
    }
  }
}
