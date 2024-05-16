import 'package:appfp_course/models/classRoom.dart';
import 'package:appfp_course/models/courseCreate.dart';
import 'package:appfp_course/service/api_service.dart';
import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseViewModel extends ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  int _expandedIndex = -1; // 初始值為-1，表示沒有展開的ExpansionTile
  int get expandedIndex => _expandedIndex;

  //控制課程的展開縮放畫面功能
  void setExpandedIndex(int index) {
    _expandedIndex = index;
    notifyListeners();
  }

  //取得所有課程
  void fetchCourses() async {
    final courses = await ApiService.getCourseList();

    if (courses == null) {
      return;
    }

    _courses = courses.map((e) => Course.fromJson(e)).toList();

    notifyListeners();
  }

  // 老師新增課程
  void submitData({
    required String name,
    required String descript,
    required String courseWeek,
    required String courseStartTime,
    required String courseEndTime,
    required int classRoomId,
    required int teacherId,
  }) {
    // 在这里执行数据提交操作，例如将数据发送到服务器
    final newCourse = CourseCreate(
      name: name,
      descript: descript,
      courseWeek: courseWeek.replaceAll('(', '').replaceAll(')', ''),
      courseStartTime: courseStartTime,
      courseEndTime: courseEndTime,
      classRoomId: classRoomId,
      teacherId: teacherId,
    );

    ApiService().courseCreate(newCourse);
  }
}
