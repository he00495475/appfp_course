class Job {
  final int id;
  final String name;
  final String createdAt;

  Job({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
    );
  }
}
