import 'package:appfp_course/helper/databaseHelper.dart';
import 'package:appfp_course/models/course.dart';
import 'package:appfp_course/models/student_course.dart';
import 'package:appfp_course/views/courses_add_page.dart';
import 'package:appfp_course/widgets/alertWidget/iconButtonConfirmActionWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/course_view_model.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<CourseViewModel>(context);
    List<Course> course = [];
    List<StudentCourse> studentCourse = [];
    //sqfLite
    final databaseHelper = DatabaseHelper();
    Map<String, dynamic> customer = {};

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Map<String, dynamic>> data = await databaseHelper.getData();
      customer = data.first;
      if (customer.isEmpty) {
        return;
      } else {
        if (customer['type'] == 'teacher') {
          courseViewModel.fetchCoursesByTeacherId(customer['id']);
          course = courseViewModel.courses;
        } else {
          courseViewModel.fetchCoursesByStudentId(customer['id']);
          studentCourse = courseViewModel.studentCourses;
        }
      }
    });

    return Scaffold(
      body: CourseListItem(
        courseViewModel: courseViewModel,
        customer: customer,
        databaseHelper: databaseHelper,
        studentCourse: studentCourse,
        course: course,
      ),
    );
  }
}

class CourseListItem extends StatefulWidget {
  final CourseViewModel courseViewModel;
  final Map<String, dynamic> customer;
  final DatabaseHelper databaseHelper;
  final List<StudentCourse> studentCourse;
  final List<Course> course;

  const CourseListItem({
    super.key,
    required this.courseViewModel,
    required this.customer,
    required this.databaseHelper,
    required this.studentCourse,
    required this.course,
  });

  @override
  State<CourseListItem> createState() => _CourseListItemState();
}

class _CourseListItemState extends State<CourseListItem> {
  Map<String, dynamic> customer = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    final customers = await widget.databaseHelper.getData();
    if (customers.isNotEmpty) {
      setState(() {
        customer = customers.first;
      });
    }
  }

  // 老師刪除課程
  void deleteCourse(int index) {
    try {
      widget.courseViewModel.deleteCourse(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('刪除成功'),
          backgroundColor: Colors.green, // 設置成功提示的背景色
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  // 學生刪除課程
  void deleteStudentCourse(int index) async {
    try {
      await widget.courseViewModel.deleteStudentCourse(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('刪除成功'),
          backgroundColor: Colors.green, // 設置成功提示的背景色
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  // List<Widget> studentList(List<StudentCourse>? list) {
  //   List<Widget> items = [];
  //   if (list != null) {
  //     items = List<Widget>.generate(list.length,
  //         (index) => listTile(title: list[index].student?.name ?? ''));
  //   }
  //   return items;
  // }

  void studentList(List<StudentCourse>? list) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('報名的學生'),
          content: SizedBox(
            width: double.maxFinite,
            height: 200,
            child: ListView.builder(
              itemCount: list?.length,
              itemBuilder: (BuildContext context, int index) {
                final name = list?[index].student?.name ?? '';
                return Text(name);
              },
            ),
          ),
        );
      },
    );
  }

  Widget listTile({String title = '', String subtitle = ''}) {
    return ListTile(
      title: Text(title),
      subtitle: (subtitle.isNotEmpty) ? Text(subtitle) : null,
      dense: true,
    );
  }

  Widget addIconButton() {
    return (customer.isNotEmpty && customer['type'] == 'teacher')
        ? IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 在按下按鈕時跳轉到添加課程頁面
              widget.courseViewModel.coursePageType = CoursePageType.add;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CourseAddsPage(),
                ),
              );
            },
          )
        : const Text('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的課程'),
        actions: [
          addIconButton(),
        ],
      ),
      body: ListView.builder(
        key: Key(widget.courseViewModel.expandedIndex.toString()),
        itemCount: (customer['type'] == 'teacher')
            ? widget.courseViewModel.courses.length
            : widget.courseViewModel.studentCourses.length,
        itemBuilder: (context, index) {
          final isExpanded = widget.courseViewModel.expandedIndex == index;
          final course = (customer['type'] == 'teacher')
              ? widget.courseViewModel.courses[index]
              : widget.courseViewModel.studentCourses[index].course;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // 垂直方向上的間距為8.0
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text(course?.name ?? ''),
                    collapsedShape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                    ),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                    ),
                    childrenPadding: EdgeInsets.zero,
                    subtitle: Text(
                        '每週${course?.courseWeek} ${course?.courseStartTime} - ${course?.courseEndTime}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButtonConfirmActionWidget(
                        titleMessage: '是否刪除課程??',
                        subMessage: '課程名稱：${course?.name}',
                        onConfirm: () {
                          if (customer['type'] == 'student') {
                            deleteStudentCourse(widget
                                .courseViewModel.studentCourses[index].id);
                          } else {
                            deleteCourse(course!.id);
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          //點擊跳轉詳細頁
                          widget.courseViewModel.coursePageType =
                              CoursePageType.modify;
                          widget.courseViewModel.course = course ?? Course();

                          if (customer['type'] == 'student') {
                            widget.courseViewModel.userType = UserType.student;
                            widget.courseViewModel.coursePageType =
                                CoursePageType.modify;
                            widget.courseViewModel.studentCourseType =
                                CoursePageType.modify;
                            widget.courseViewModel.studentCourseId =
                                widget.courseViewModel.studentCourses[index].id;
                            widget.courseViewModel.studentCourseDaysOfWeek =
                                widget.courseViewModel.studentCourses[index]
                                    .courseWeek;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CourseAddsPage()));
                        },
                      ),
                      if (customer['type'] == 'teacher')
                        IconButton(
                          icon: const Icon(Icons.person),
                          onPressed: () {
                            studentList(course!.studentCourses);
                          },
                        )
                    ]),
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (value) {
                      if (value) {
                        widget.courseViewModel.setExpandedIndex(index);
                      } else {
                        widget.courseViewModel.setExpandedIndex(-1);
                      }
                      setState(() {});
                    },
                    children: [
                      const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                        height: 15.0,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                      listTile(
                          title: '地點：',
                          subtitle: course?.classRoom?.name ?? ''),
                      listTile(
                          title: '老師：', subtitle: course?.teacher?.name ?? ''),
                      listTile(
                          title: '課程說明：', subtitle: course?.descript ?? ''),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
