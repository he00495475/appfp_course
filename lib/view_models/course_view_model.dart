import 'package:flutter/material.dart';
import '../models/course.dart';

class CourseViewModel extends ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  void fetchCourses() {
    // Logic to fetch courses from backend
    // For demo purpose, let's assume courses are already loaded
    _courses = [
      Course(id: '1', name: 'Flutter Course', instructorId: '1'),
      Course(id: '2', name: 'Dart Course', instructorId: '2'),
    ];
    notifyListeners();
  }
}
