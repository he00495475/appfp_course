class ClassRoom {
  final int id;
  final String name;

  ClassRoom({
    required this.id,
    required this.name,
  });

  factory ClassRoom.fromJson(Map<String, dynamic> json) {
    return ClassRoom(
      id: json['id'],
      name: json['name'],
    );
  }
}
