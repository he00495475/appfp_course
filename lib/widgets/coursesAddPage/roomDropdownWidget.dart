// 在你的 Dart 文件的適當位置定義一個新的小部件
import 'package:appfp_course/models/class_room.dart';
import 'package:appfp_course/view_models/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDropdown extends StatelessWidget {
  final String selectedRoom;
  final Function(Object?) onChanged;
  final List<ClassRoom> classRooms;

  const RoomDropdown({
    super.key,
    required this.selectedRoom,
    required this.onChanged,
    required this.classRooms,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassRoomViewModel>(
      builder: (context, viewModel, child) {
        return DropdownButtonFormField<Object?>(
          value: selectedRoom.isEmpty ? null : selectedRoom,
          onChanged: onChanged,
          items: viewModel.classRooms.isNotEmpty
              ? viewModel.classRooms.map((room) {
                  return DropdownMenuItem(
                    value: room.id.toString(),
                    child: Text(room.name),
                  );
                }).toList()
              : [],
          decoration: const InputDecoration(labelText: '課程地點'),
          validator: (value) {
            if (value == null) {
              return '請選擇課程地點';
            }
            return null;
          },
        );
      },
    );
  }
}
