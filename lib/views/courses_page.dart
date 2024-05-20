import 'package:appfp_course/helper/databaseHelper.dart';
import 'package:appfp_course/views/courses_add_page.dart';
import 'package:appfp_course/widgets/alertWidget/iconButtonConfirmActionWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/course_view_model.dart';
import '../models/course.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<CourseViewModel>(context);
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
        } else {
          courseViewModel.fetchCoursesByStudentId(customer['id']);
        }
      }
    });

    return Scaffold(
      body: CourseListItem(
        courseViewModel: courseViewModel,
        customer: customer,
        databaseHelper: databaseHelper,
      ),
    );
  }
}

class CourseListItem extends StatefulWidget {
  final CourseViewModel courseViewModel;
  final Map<String, dynamic> customer;
  final DatabaseHelper databaseHelper;

  const CourseListItem({
    super.key,
    required this.courseViewModel,
    required this.customer,
    required this.databaseHelper,
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

  // 刪除課程
  void deleteCourse(int index) {
    widget.courseViewModel.deleteCourse(index);
  }

  Widget listTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
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
        itemCount: widget.courseViewModel.courses.length,
        itemBuilder: (context, index) {
          final isExpanded = widget.courseViewModel.expandedIndex == index;
          final course = widget.courseViewModel.courses[index];
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
                    title: Text(course.name),
                    collapsedShape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                    ),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                    ),
                    childrenPadding: EdgeInsets.zero,
                    subtitle: Text(
                        '每週${course.courseWeek} ${course.courseStartTime} - ${course.courseEndTime}'),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButtonConfirmActionWidget(
                        titleMessage: '是否刪除課程??',
                        subMessage: '課程名稱：${course.name}',
                        onConfirm: () {
                          deleteCourse(course.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          //點擊跳轉詳細頁
                          widget.courseViewModel.coursePageType =
                              CoursePageType.modify;
                          // widget.courseViewModel.courseId = widget.course.id;
                          widget.courseViewModel.course = course;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CourseAddsPage()));
                        },
                      ),
                      Icon(
                        isExpanded ? Icons.remove : Icons.add,
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
                    children: <Widget>[
                      const Divider(
                        color: Colors.grey,
                        thickness: 1.0,
                        height: 15.0,
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                      listTile('地點：', course.classRoom?.name ?? ''),
                      listTile('老師：', course.teacher?.name ?? ''),
                      listTile('課程說明：', course.descript),
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
