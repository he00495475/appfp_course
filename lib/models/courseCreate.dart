import 'package:appfp_course/models/classRoom.dart';
import 'package:appfp_course/models/course.dart';
import 'package:appfp_course/models/teacher.dart';
import 'package:intl/intl.dart';

class CourseCreate {
  final String name;
  final String descript;
  final String courseWeek;
  final String courseStartTime;
  final String courseEndTime;
  final int classRoomId;
  final int teacherId;

  CourseCreate(
      {required this.name,
      required this.descript,
      required this.courseWeek,
      required this.courseStartTime,
      required this.courseEndTime,
      required this.classRoomId,
      required this.teacherId});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'descript': descript,
      'course_week': courseWeek,
      'course_start_time': courseStartTime,
      'course_end_time': courseEndTime,
      'class_room_id': classRoomId,
      'teacher_id': teacherId
    };
  }
}
