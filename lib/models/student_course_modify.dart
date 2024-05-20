class StudentCourseModify {
  final int id;
  final String courseWeek;
  final int courseId;
  final int studentId;

  StudentCourseModify(
      {required this.id,
      required this.courseWeek,
      required this.courseId,
      required this.studentId});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_week': courseWeek,
      'course_id': courseId,
      'student_id': studentId
    };
  }
}
