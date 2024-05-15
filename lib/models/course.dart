import 'package:appfp_course/models/class_room.dart';
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

  Course(
      {required this.id,
      required this.name,
      required this.descript,
      required this.courseWeek,
      required this.courseStartTime,
      required this.courseEndTime,
      required this.classRoom,
      required this.teacher});

  factory Course.fromJson(Map<String, dynamic> json) {
    DateTime startTime =
        DateFormat('HH:mm:ss').parse(json['course_start_time']);
    DateTime endTime = DateFormat('HH:mm:ss').parse(json['course_end_time']);

    return Course(
      id: json['id'],
      name: json['name'],
      descript: json['descript'],
      courseWeek: json['course_week'],
      courseStartTime: DateFormat('HH:mm').format(startTime),
      courseEndTime: DateFormat('HH:mm').format(endTime),
      classRoom: json['classroom'] != null
          ? ClassRoom.fromJson(json['classroom'])
          : null,
      teacher:
          json['teachers'] != null ? Teacher.fromJson(json['teachers']) : null,
    );
  }

  static List<Course> fromList(List jsonList) {
    return jsonList.map((json) => Course.fromJson(json)).toList();
  }
}
