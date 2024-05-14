import 'package:appfp_course/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
}
