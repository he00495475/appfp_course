import 'package:appfp_course/service/api_service.dart';
import 'package:flutter/material.dart';
import '../models/teacher.dart';

class TeacherViewModel extends ChangeNotifier {
  List<Teacher> _teachers = [];

  List<Teacher> get teachers => _teachers;

  int _expandedIndex = -1; // 初始值為-1，表示沒有展開的ExpansionTile
  int get expandedIndex => _expandedIndex;

  //控制課程的展開縮放畫面功能
  void setExpandedIndex(int index) {
    _expandedIndex = index;
    notifyListeners();
  }

  //取得所有課程
  void fetchTeachers() async {
    final teachers = await ApiService.getTeacherList();

    if (teachers == null) {
      return;
    }

    _teachers = teachers.map((e) => Teacher.fromJson(e)).toList();

    notifyListeners();
  }
}
