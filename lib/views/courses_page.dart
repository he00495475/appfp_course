import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/course_view_model.dart';
import '../models/course.dart';

class CoursesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<CourseViewModel>(context);

    // 在頁面加載時調用fetchCourses()
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      courseViewModel.fetchCourses();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: ListView.builder(
        itemCount: courseViewModel.courses.length,
        itemBuilder: (context, index) {
          final course = courseViewModel.courses[index];
          return ListTile(
            title: Text(course.name),
            subtitle: Text('Instructor: ${course.instructorId}'),
            onTap: () {
              // Logic to handle when a course is tapped
              // For example, you can navigate to course details page
            },
          );
        },
      ),
    );
  }
}
