class Student {
  final int id;
  final String name;
  final String createdAt;
  final String? gender;

  Student({
    required this.id,
    required this.name,
    required this.createdAt,
    this.gender,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'],
      createdAt: json['created_at'],
      gender: json['gender'],
    );
  }

  static List<Student> fromList(List jsonList) {
    return jsonList.map((json) => Student.fromJson(json)).toList();
  }
}
