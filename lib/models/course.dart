import 'package:appfp_course/models/class_room.dart';
import 'package:appfp_course/models/student.dart';
import 'package:appfp_course/models/student_course.dart';
import 'package:appfp_course/models/teacher.dart';
import 'package:intl/intl.dart';

class Course {
  final int id;
  final String name;
  final String descript;
  final String courseWeek;
  final String courseStartTime;
  final String courseEndTime;
  final ClassRoom? classRoom;
  final Teacher? teacher;
  final List<StudentCourse>? studentCourses;

  Course({
    this.id = 0,
    this.name = '',
    this.descript = '',
    this.courseWeek = '',
    this.courseStartTime = '',
    this.courseEndTime = '',
    this.classRoom,
    this.teacher,
    this.studentCourses,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    DateTime startTime = (json['course_start_time'] != null)
        ? DateFormat('HH:mm:ss').parse(json['course_start_time'])
        : DateTime.now();
    DateTime endTime = (json['course_end_time'] != null)
        ? DateFormat('HH:mm:ss').parse(json['course_end_time'])
        : DateTime.now();

    final classroom = json['classroom'] != null
        ? ClassRoom.fromJson(json['classroom'])
        : null;
    final teacher =
        json['teachers'] != null ? Teacher.fromJson(json['teachers']) : null;

    // final List<dynamic> studentCourseList = json['student_courses'];
    // final studentCourse = (studentCourseList.isNotEmpty)
    //     ? StudentCourse.fromJson(json['student_courses'][0])
    //     : null;

    final studentCourses = json['student_courses'] != null
        ? StudentCourse.fromList(json['student_courses'])
        : null;

    return Course(
      id: json['id'],
      name: json['name'],
      descript: json['descript'],
      courseWeek: json['course_week'],
      courseStartTime: DateFormat('HH:mm').format(startTime),
      courseEndTime: DateFormat('HH:mm').format(endTime),
      classRoom: classroom,
      teacher: teacher,
      studentCourses: studentCourses,
    );
  }

  static List<Course> fromList(List jsonList) {
    return jsonList.map((json) => Course.fromJson(json)).toList();
  }
}
