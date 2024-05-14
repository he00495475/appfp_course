class Teacher {
  final int id;
  final String name;
  final String createdAt;
  final int jobId;

  Teacher(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.jobId});

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: json['created_at'] as String,
      jobId: json['job_id'] as int,
    );
  }
}
