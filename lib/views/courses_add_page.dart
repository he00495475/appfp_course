import 'package:appfp_course/extension/elevatedButtonExtension.dart';
import 'package:appfp_course/helper/baseHelper.dart';
import 'package:appfp_course/helper/databaseHelper.dart';
import 'package:appfp_course/models/course.dart';
import 'package:appfp_course/view_models/course_view_model.dart';
import 'package:appfp_course/view_models/room_view_model.dart';
import 'package:appfp_course/widgets/coursesAddPage/roomDropdownWidget.dart';
import 'package:appfp_course/widgets/textFormFieldWidget/textFormFieldWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseAddsPage extends StatelessWidget {
  const CourseAddsPage({super.key});

  @override
  Widget build(BuildContext context) {
    //帶入模組
    final classRoomViewModel = Provider.of<ClassRoomViewModel>(context);
    final courseViewModel = Provider.of<CourseViewModel>(context);

    final pageType = courseViewModel.coursePageType;
    final title = (pageType == CoursePageType.modify)
        ? const Text('修改課程')
        : const Text('新增課程');

    return Scaffold(
        appBar: AppBar(
          title: title,
        ),
        body: CourseAddListItem(
          classRoomViewModel: classRoomViewModel,
          courseViewModel: courseViewModel,
        ));
  }
}

class CourseAddListItem extends StatefulWidget {
  final ClassRoomViewModel classRoomViewModel;
  final CourseViewModel courseViewModel;

  const CourseAddListItem({
    super.key,
    required this.classRoomViewModel,
    required this.courseViewModel,
  });

  @override
  State<CourseAddListItem> createState() => _CourseAddListItemState();
}

class _CourseAddListItemState extends State<CourseAddListItem> {
  // 表單驗證為空
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // init course
  Course course = Course();

  // sqfLite
  final DatabaseHelper databaseHelper = DatabaseHelper();

  // 畫面元件控制
  bool enable = false;
  final TextEditingController _teacherController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptController = TextEditingController();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  String selectedRoom = '';
  List<int> selectedDays = [];
  List<String> teacherDaysOfWeek = []; //老師課程的每週幾
  List<Map<String, dynamic>> sqlData = [];

  @override
  void initState() {
    super.initState();
    loadCustomer();
    loadData();
  }

  void loadCustomer() async {
    sqlData = await databaseHelper.getData();
  }

  // 頁面資料初始化
  void loadData() {
    setState(() {
      // 教室async fetch
      widget.classRoomViewModel.fetchClassRooms();
      // modify為修改 帶入course資料
      if (widget.courseViewModel.coursePageType == CoursePageType.modify) {
        course = widget.courseViewModel.course;
      }

      // 控制器預設值給予
      enable =
          (widget.courseViewModel.userType == UserType.teacher) ? true : false;
      _teacherController.text = course.teacher?.name ?? '';
      _nameController.text = course.name;
      _descriptController.text = course.descript;
      _startTime = BaseHelper.convertStringToTimeOfDay(
          course.courseStartTime.toString());
      _endTime =
          BaseHelper.convertStringToTimeOfDay(course.courseEndTime.toString());

      final roomIndex = course.classRoom?.id.toString();
      selectedRoom = roomIndex ?? '';

      final courseWeek = course.courseWeek.replaceAll(' ', '').split(',');
      // 學生選課 預先帶入老師每週課程日
      if (widget.courseViewModel.userType == UserType.student) {
        final daysOfWeek = widget.courseViewModel.studentCourseDaysOfWeek;
        final List<String> studentDayOfWeek =
            (daysOfWeek != '') ? daysOfWeek.replaceAll(' ', '').split(',') : [];
        teacherDaysOfWeek = course.courseWeek.split(',');

        selectedDays = BaseHelper.getDaysOfTwoWeekIndexs(
            studentDayOfWeek, teacherDaysOfWeek);
      } else {
        // 老師新增修改課程時的每週選課日為1~7
        teacherDaysOfWeek = BaseHelper.daysOfWeek;

        selectedDays = BaseHelper.getDaysOfWeekIndexs(courseWeek);
      }
    });
  }

  // 送出 老師新增課程
  void addCourse() {
    final customer = sqlData.first;
    widget.courseViewModel.addCourse(
      name: _nameController.text,
      descript: _descriptController.text,
      courseWeek: selectedDays
          .map((e) => BaseHelper.daysOfWeek[e])
          .join(', '), // 使用join串接選擇的天數
      courseStartTime:
          '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}', // 格式化時間
      courseEndTime:
          '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}', // 格式化時間
      classRoomId: int.parse(selectedRoom),
      teacherId: customer['id'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('新增成功'),
        backgroundColor: Colors.green, // 設置成功提示的背景色
      ),
    );
  }

  // 送出 老師修改課程
  void modifyCourse() {
    final customer = sqlData.first;
    widget.courseViewModel.modifyCourse(
      id: course.id,
      name: _nameController.text,
      descript: _descriptController.text,
      courseWeek: selectedDays
          .map((e) => BaseHelper.daysOfWeek[e])
          .join(', '), // 使用join串接選擇的天數
      courseStartTime:
          '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}', // 格式化時間
      courseEndTime:
          '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}', // 格式化時間
      classRoomId: int.parse(selectedRoom),
      teacherId: customer['id'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('修改成功'),
        backgroundColor: Colors.green, // 設置成功提示的背景色
      ),
    );
  }

  //送出表單 老師新增修改課程
  void submit() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); //預先關閉提示，防止重複彈出
    //這邊簡單做每週選擇驗證
    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請選擇每週上課日'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {
      selectedDays.sort(); // 陣列重新排序
      //送出
      final pageType = widget.courseViewModel.coursePageType;
      if (pageType == CoursePageType.modify) {
        modifyCourse();
      } else {
        addCourse();
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('發生錯誤: $e'),
          backgroundColor: Colors.red, // 設置錯誤提示的背景色
        ),
      );
    }
  }

  // 學生選課 新增
  void studentAddCourse() {
    final customer = sqlData.first;
    final selectedDay = selectedDays.map((e) => teacherDaysOfWeek[e]).join(',');
    widget.courseViewModel.addStudentCourse(
      courseWeek: selectedDay, // 使用join串接選擇的天數
      courseId: course.id,
      studentId: customer['id'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('新增成功'),
        backgroundColor: Colors.green, // 設置成功提示的背景色
      ),
    );
  }

  void studentModifyCourse() {
    final customer = sqlData.first;
    widget.courseViewModel.modifyStudentCourse(
      id: widget.courseViewModel.studentCourseId,
      courseWeek: selectedDays
          .map((e) => teacherDaysOfWeek[e])
          .join(', '), // 使用join串接選擇的天數
      courseId: course.id,
      studentId: customer['id'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('修改成功'),
        backgroundColor: Colors.green, // 設置成功提示的背景色
      ),
    );
  }

  //送出表單 學生新增修改課程
  void studentSubmit() async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); //預先關閉提示，防止重複彈出
    //這邊簡單做每週選擇驗證
    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請選擇每週上課日'),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    try {
      selectedDays.sort(); // 陣列重新排序
      //送出
      final pageType = widget.courseViewModel.studentCourseType;
      if (pageType == CoursePageType.modify) {
        studentModifyCourse();
      } else {
        studentAddCourse();
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('發生錯誤: $e'),
          backgroundColor: Colors.red, // 設置錯誤提示的背景色
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                textFormField(
                    controller: _nameController,
                    enabled: enable,
                    labelText: '課程名稱',
                    validatorText: '請輸入課程名稱！'),
                textFormField(
                  controller: _descriptController,
                  enabled: enable,
                  labelText: '課程描述',
                  validatorText: '請輸入課程描述！',
                ),
                const SizedBox(height: 16.0),
                RoomDropdown(
                  selectedRoom: selectedRoom,
                  enabled: enable,
                  onChanged: (newValue) {
                    setState(() {
                      selectedRoom = newValue.toString();
                    });
                  },
                  classRooms:
                      Provider.of<ClassRoomViewModel>(context).classRooms,
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('開始時間: ${_startTime.format(context)}'),
                    if (enable)
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('選擇時間(開始結束)'),
                      ).withTimePicker(
                        context,
                        _startTime,
                        _endTime,
                        onTimeSelected: (startTime, endTime) {
                          setState(() {
                            _startTime = startTime;
                            _endTime = endTime;
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('結束時間: ${_endTime.format(context)}'),
                  ],
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  spacing: 10.0,
                  children: List.generate(teacherDaysOfWeek.length, (index) {
                    return FilterChip(
                      label: Text('每週${teacherDaysOfWeek[index]}'),
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
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('取消'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          // 如果表單驗證通過，執行提交邏輯
                          if (widget.courseViewModel.userType ==
                              UserType.student) {
                            studentSubmit();
                          } else {
                            submit();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('確認'),
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
