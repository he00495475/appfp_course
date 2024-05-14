import 'package:appfp_course/models/class_room.dart';
import 'package:appfp_course/models/teacher.dart';
import 'package:intl/intl.dart';

class Course {
  final int id;
  final String name;
  final String descript;
  final String courseDate;
  final ClassRoom? classRoom;
  final Teacher? teacher;

  Course(
      {required this.id,
      required this.name,
      required this.descript,
      required this.courseDate,
      required this.classRoom,
      required this.teacher});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      descript: json['descript'],
      courseDate: DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.parse(json['course_date'])),
      classRoom: json['classroom'] != null
          ? ClassRoom.fromJson(json['classroom'])
          : null,
      teacher:
          json['teachers'] != null ? Teacher.fromJson(json['teachers']) : null,
    );
  }
}
