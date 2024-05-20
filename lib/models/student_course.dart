import 'package:appfp_course/models/course.dart';
import 'package:appfp_course/models/student.dart';

class StudentCourse {
  final int id;
  final String courseWeek;
  final Course? course;
  final Student? student;

  StudentCourse({
    required this.id,
    required this.courseWeek,
    required this.course,
    required this.student,
  });

  factory StudentCourse.fromJson(Map<String, dynamic> json) {
    return StudentCourse(
      id: json['id'],
      courseWeek: json['course_week'],
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
    );
  }
}
