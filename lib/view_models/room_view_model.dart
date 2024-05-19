import 'package:appfp_course/service/api_service.dart';
import 'package:flutter/material.dart';
import '../models/class_room.dart';

class ClassRoomViewModel extends ChangeNotifier {
  List<ClassRoom> _classRooms = [];

  List<ClassRoom> get classRooms => _classRooms;

  //取得所有課程
  Future<void> fetchClassRooms() async {
    final classRooms = await ApiService.getRoomList();

    if (classRooms == null) {
      return;
    }

    _classRooms = classRooms.map((e) => ClassRoom.fromJson(e)).toList();

    notifyListeners();
  }
}
