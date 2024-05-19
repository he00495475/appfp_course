import 'package:appfp_course/models/course_create.dart';
import 'package:appfp_course/models/course_modify.dart';
import 'package:appfp_course/service/api_service.dart';
import 'package:flutter/material.dart';
import '../models/course.dart';

enum CoursePageType { add, modify }

enum UserType { teacher, student }

class CourseViewModel extends ChangeNotifier {
  List<Course> _courses = [];
  List<Course> get courses => _courses;

  Course course = Course(); //修改課程 or 加入課程用

  CoursePageType coursePageType = CoursePageType.add; //決定新增還是修改頁面

  UserType userType = UserType.teacher; //老師還是學生在操作頁面

  int _expandedIndex = -1; // 初始值為-1，表示沒有展開的ExpansionTile
  int get expandedIndex => _expandedIndex;

  //控制課程的展開縮放畫面功能
  void setExpandedIndex(int index) {
    _expandedIndex = index;
    notifyListeners();
  }

  //取得學生所有課程
  void fetchCoursesByStudentId(int studentId) async {
    final courses = await ApiService.getStudentCourses(studentId);
    if (courses == null) {
      return;
    }
    _courses = courses.map((e) => Course.fromJson(e)).toList();

    notifyListeners();
  }

  //取得老師所有課程
  void fetchCoursesByTeacherId(int teacherId) async {
    final courses = await ApiService.getTeacherCourses(teacherId);
    if (courses == null) {
      return;
    }
    _courses = courses.map((e) => Course.fromJson(e)).toList();

    notifyListeners();
  }

  // 老師新增課程
  addCourse({
    required String name,
    required String descript,
    required String courseWeek,
    required String courseStartTime,
    required String courseEndTime,
    required int classRoomId,
    required int teacherId,
  }) {
    // 在這裡執行資料提交操作，例如將資料發送到伺服器
    final course = CourseCreate(
      name: name,
      descript: descript,
      courseWeek: courseWeek.replaceAll('(', '').replaceAll(')', ''),
      courseStartTime: courseStartTime,
      courseEndTime: courseEndTime,
      classRoomId: classRoomId,
      teacherId: teacherId,
    );
    final api = ApiService();
    api.courseCreate(course);
  }

  // 老師修改課程
  modifyCourse({
    required int id,
    required String name,
    required String descript,
    required String courseWeek,
    required String courseStartTime,
    required String courseEndTime,
    required int classRoomId,
    required int teacherId,
  }) {
    // 在這裡執行資料提交操作，例如將資料發送到伺服器
    final course = CourseModify(
      id: id,
      name: name,
      descript: descript,
      courseWeek: courseWeek.replaceAll('(', '').replaceAll(')', ''),
      courseStartTime: courseStartTime,
      courseEndTime: courseEndTime,
      classRoomId: classRoomId,
      teacherId: teacherId,
    );
    final api = ApiService();
    api.courseModify(course);
  }

  Future<void> deleteCourse(int courseId) async {
    final api = ApiService();
    api.courseDelete(courseId);
  }
}
