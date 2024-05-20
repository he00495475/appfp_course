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
      course: json['courses'] != null ? Course.fromJson(json['courses']) : null,
      student:
          json['students'] != null ? Student.fromJson(json['students']) : null,
    );
  }

  static List<StudentCourse> fromList(List jsonList) {
    return jsonList.map((json) => StudentCourse.fromJson(json)).toList();
  }
}
