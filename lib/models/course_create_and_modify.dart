class CourseCreateAndModify {
  String? id = ''; //supabase送出id為空字串為新增
  final String name;
  final String descript;
  final String courseWeek;
  final String courseStartTime;
  final String courseEndTime;
  final int classRoomId;
  final int teacherId;

  CourseCreateAndModify(
      {this.id,
      required this.name,
      required this.descript,
      required this.courseWeek,
      required this.courseStartTime,
      required this.courseEndTime,
      required this.classRoomId,
      required this.teacherId});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
