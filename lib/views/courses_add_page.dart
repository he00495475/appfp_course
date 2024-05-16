import 'package:appfp_course/view_models/course_view_model.dart';
import 'package:appfp_course/view_models/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseAddsPage extends StatelessWidget {
  const CourseAddsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final classRoomViewModel = Provider.of<ClassRoomViewModel>(context);

    // 在頁面加載時調用fetchCourseAdds()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      classRoomViewModel.fetchClassRooms();
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('新增課程'),
        ),
        body: const CourseAddListItem());
  }
}

class CourseAddListItem extends StatefulWidget {
  const CourseAddListItem({super.key});

  @override
  State<CourseAddListItem> createState() => _CourseAddListItemState();
}

class _CourseAddListItemState extends State<CourseAddListItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add a GlobalKey for ScaffoldState

  final TextEditingController _descriptController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String selectedRoom = '';

  List<String> daysOfWeek = ['一', '二', '三', '四', '五', '六', '日'];
  List<int> selectedDays = [];

  @override
  Widget build(BuildContext context) {
    final classRoomViewModel = Provider.of<ClassRoomViewModel>(context);
    final rooms = classRoomViewModel.classRooms;

    //送出表單
    void submit() {
      //這邊簡單做驗證
      if (selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('請選擇每週上課日'),
            backgroundColor: Colors.red, // 设置错误提示的背景色
          ),
        );

        return;
      }

      final courseViewModel = CourseViewModel();
      courseViewModel.submitData(
          name: _nameController.text,
          descript: _descriptController.text,
          courseWeek: selectedDays.map((e) {
            return "每週${daysOfWeek[e]} ";
          }).toString(),
          courseStartTime: '${_startTime.hour}:${_startTime.minute}',
          courseEndTime: '${_endTime.hour}:${_endTime.minute}',
          classRoomId: int.parse(selectedRoom),
          teacherId: 1);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('新增成功'),
          backgroundColor: Colors.green, // 设置错误提示的背景色
        ),
      );

      Navigator.of(context).pop();
    }

    return Scaffold(
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: '課程名稱'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入課程名稱！';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  maxLines: 3,
                  controller: _descriptController,
                  decoration: const InputDecoration(labelText: '課程描述'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '請輸入課程描述！';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField(
                  value: selectedRoom.isEmpty ? null : selectedRoom,
                  onChanged: (newValue) {
                    setState(() {
                      selectedRoom = newValue.toString();
                    });
                  },
                  items: rooms.isNotEmpty
                      ? rooms.map((room) {
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
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('開始時間: ${_startTime.format(context)}'),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                        );
                        if (selectedTime != null) {
                          setState(() {
                            _startTime = selectedTime;
                          });
                        }
                      },
                      child: const Text('選擇時間'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('結束時間: ${_endTime.format(context)}'),
                    ElevatedButton(
                      onPressed: () async {
                        final selectedTime = await showTimePicker(
                          context: context,
                          initialTime: _endTime,
                        );
                        if (selectedTime != null) {
                          setState(() {
                            _endTime = selectedTime;
                          });
                        }
                      },
                      child: const Text('選擇時間'),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  spacing: 10.0,
                  children: List.generate(7, (index) {
                    return FilterChip(
                      label: Text('每週${daysOfWeek[index]}'),
                      selected: selectedDays.contains(index),
                      onSelected: (selected) {
                        setState(() {
                          if (selectedDays.contains(index)) {
                            selectedDays.remove(index);
                          } else {
                            selectedDays.add(index);
                          }
                        });
                      },
                    );
                  }),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 取消按鈕操作
                      },
                      child: const Text('取消'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          // 如果表單驗證通過，執行提交邏輯
                          submit();
                        }
                      },
                      child: const Text('送出'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
