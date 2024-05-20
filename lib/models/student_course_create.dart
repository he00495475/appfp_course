class StudentCourseCreate {
  final String courseWeek;
  final int courseId;
  final int studentId;

  StudentCourseCreate(
      {required this.courseWeek,
      required this.courseId,
      required this.studentId});

  Map<String, dynamic> toJson() {
    return {
      'course_week': courseWeek,
      'course_id': courseId,
      'student_id': studentId
    };
  }
}
