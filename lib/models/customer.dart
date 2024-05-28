import 'package:appfp_course/models/student.dart';
import 'package:appfp_course/models/teacher.dart';

class Customer {
  final int id;
  final String account;
  final String? password;
  final String type;
  final int? relativeId;
  Student? student;
  Teacher? teacher;

  Customer(
      {required this.id,
      required this.account,
      this.password,
      required this.type,
      this.relativeId,
      this.student,
      this.teacher});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      account: json['name'],
      type: json['type'],
      relativeId: json['relative_id'],
      student: json['students'],
      teacher: json['teachers'],
    );
  }
}
