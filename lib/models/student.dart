/// Simple model class to store student information
/// This is NOT a database
class Student {
  String firstName;
  String lastName;
  String phoneNumber;
  String dateOfBirth;
  String major;
  String studentId;

  Student({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.major,
    required this.studentId,
  });
}
