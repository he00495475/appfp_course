import 'package:appfp_course/models/course.dart';
import 'package:appfp_course/models/job.dart';

class Teacher {
  final int id;
  final String name;
  final String createdAt;
  final Job? job;
  final List<Course>? courses;
  final String image;

  Teacher({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.job,
    required this.courses,
    required this.image,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
      job: json['jobs'] != null ? Job.fromJson(json['jobs']) : null,
      courses:
          json['courses'] != null ? Course.fromList(json['courses']) : null,
      image: json['image'] as String,
    );
  }
}
