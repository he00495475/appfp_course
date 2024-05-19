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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Map<String, dynamic>> data = await databaseHelper.getData();
      final customer = data.first;
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
      appBar: AppBar(
        title: const Text('我的課程'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 在按下按鈕時跳轉到添加課程頁面
              courseViewModel.coursePageType = CoursePageType.add;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CourseAddsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        key: Key(courseViewModel.expandedIndex.toString()),
        itemCount: courseViewModel.courses.length,
        itemBuilder: (context, index) {
          final course = courseViewModel.courses[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // 垂直方向上的間距為8.0
            child: CourseListItem(
              courseViewModel: courseViewModel,
              course: course,
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class CourseListItem extends StatefulWidget {
  final CourseViewModel courseViewModel;
  final Course course;
  final int index;

  const CourseListItem(
      {super.key,
      required this.courseViewModel,
      required this.course,
      required this.index});

  @override
  State<CourseListItem> createState() => _CourseListItemState();
}

class _CourseListItemState extends State<CourseListItem> {
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

  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.courseViewModel.expandedIndex == widget.index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          ExpansionTile(
            title: Text(widget.course.name),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            childrenPadding: EdgeInsets.zero,
            subtitle: Text(
                '每週${widget.course.courseWeek} ${widget.course.courseStartTime} - ${widget.course.courseEndTime}'),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButtonConfirmActionWidget(
                titleMessage: '是否刪除課程??',
                subMessage: '課程名稱：${widget.course.name}',
                onConfirm: () {
                  deleteCourse(widget.course.id);
                },
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  //點擊跳轉詳細頁
                  widget.courseViewModel.coursePageType = CoursePageType.modify;
                  // widget.courseViewModel.courseId = widget.course.id;
                  widget.courseViewModel.course = widget.course;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CourseAddsPage()));
                },
              ),
              Icon(
                isExpanded ? Icons.remove : Icons.add,
              )
            ]),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (value) {
              if (value) {
                widget.courseViewModel.setExpandedIndex(widget.index);
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
              listTile('地點：', widget.course.classRoom?.name ?? ''),
              listTile('老師：', widget.course.teacher?.name ?? ''),
              listTile('課程說明：', widget.course.descript),
            ],
          ),
        ],
      ),
    );
  }
}
