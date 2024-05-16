import 'package:appfp_course/views/courses_add_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/course_view_model.dart';
import '../models/course.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<CourseViewModel>(context);

    // 在頁面加載時調用fetchCourses()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      courseViewModel.fetchCourses();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的課程'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // 在按下按鈕時跳轉到添加課程頁面
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseAddsPage(),
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
            padding: const EdgeInsets.symmetric(vertical: 8.0), // 垂直方向上的间距为8.0
            child: CourseListItem(
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
  final Course course;
  final int index;

  const CourseListItem({super.key, required this.course, required this.index});

  @override
  State<CourseListItem> createState() => _CourseListItemState();
}

class _CourseListItemState extends State<CourseListItem> {
  @override
  Widget build(BuildContext context) {
    final courseViewModel = Provider.of<CourseViewModel>(context);
    final isExpanded = courseViewModel.expandedIndex == widget.index;

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
                '${widget.course.courseWeek} ${widget.course.courseStartTime} - ${widget.course.courseEndTime}'),
            trailing: Icon(
              isExpanded ? Icons.remove : Icons.add,
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (value) {
              if (value) {
                courseViewModel.setExpandedIndex(widget.index);
              } else {
                courseViewModel.setExpandedIndex(-1);
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
              ListTile(
                title: const Text("地點："),
                subtitle: Text(widget.course.classRoom?.name ?? ''),
                dense: true,
              ),
              ListTile(
                title: const Text("老師："),
                subtitle: Text(widget.course.teacher?.name ?? ''),
                dense: true,
              ),
              ListTile(
                title: const Text("課程說明："),
                subtitle: Text(widget.course.descript),
                dense: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
