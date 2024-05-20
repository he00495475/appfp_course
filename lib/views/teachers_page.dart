import 'package:appfp_course/view_models/course_view_model.dart';
import 'package:appfp_course/views/courses_add_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/teacher_view_model.dart';
import '../models/teacher.dart';

class TeachersPage extends StatelessWidget {
  const TeachersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final teacherViewModel = Provider.of<TeacherViewModel>(context);

    // 在頁面加載時調用fetchTeachers()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      teacherViewModel.fetchTeachers();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('講師清單'),
      ),
      body: ListView.builder(
        key: Key(teacherViewModel.expandedIndex.toString()),
        itemCount: teacherViewModel.teachers.length,
        itemBuilder: (context, index) {
          final teacher = teacherViewModel.teachers[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0), // 垂直方向上的间距为8.0
            child: TeacherListItem(
              teacherViewModel: teacherViewModel,
              teacher: teacher,
              index: index,
            ),
          );
        },
      ),
    );
  }
}

class TeacherListItem extends StatefulWidget {
  final TeacherViewModel teacherViewModel;
  final Teacher teacher;
  final int index;

  const TeacherListItem(
      {super.key,
      required this.teacher,
      required this.index,
      required this.teacherViewModel});

  @override
  State<TeacherListItem> createState() => _TeacherListItemState();
}

class _TeacherListItemState extends State<TeacherListItem> {
  late final bool isExpanded;

  void loadData() {
    isExpanded = widget.teacherViewModel.expandedIndex == widget.index;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        children: [
          ExpansionTile(
            title: Text(
              widget.teacher.job?.name ?? '',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            subtitle: Text(
              widget.teacher.name,
              style: const TextStyle(fontSize: 16),
            ),
            leading: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/${widget.teacher.image}'), // 圖片來源
            ),
            trailing: Icon(
              isExpanded ? Icons.remove : Icons.add,
            ),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            childrenPadding: EdgeInsets.zero,
            initiallyExpanded: isExpanded,
            onExpansionChanged: (value) {
              setState(() {
                if (value) {
                  widget.teacherViewModel.setExpandedIndex(widget.index);
                } else {
                  widget.teacherViewModel.setExpandedIndex(-1);
                }
              });
            },
            children: <Widget>[
              const Divider(
                color: Colors.grey,
                thickness: 1.0,
                height: 15.0,
                indent: 15.0,
                endIndent: 15.0,
              ),
              ListView.builder(
                shrinkWrap: true, // 讓內層 ListView 根據內容大小調整高度
                physics:
                    const NeverScrollableScrollPhysics(), // 禁止內層 ListView 滾動
                itemCount: widget.teacher.courses!.length,
                itemBuilder: (context, innerIndex) {
                  return ListTile(
                    title: Text(widget.teacher.courses![innerIndex].name),
                    subtitle: Text(
                        '每週${widget.teacher.courses![innerIndex].courseWeek} ${widget.teacher.courses![innerIndex].courseStartTime} - ${widget.teacher.courses![innerIndex].courseEndTime}'),
                    leading: Image.asset(
                      'assets/images/calendar.jpg',
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover, // 圖片的填充方式
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 18,
                    ),
                    dense: true,
                    onTap: () {
                      // widget.courseViewModel.coursePageType =
                      //     CoursePageType.modify;
                      // widget.courseViewModel.modifyIndex = widget.index;
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const CourseAddsPage()));
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
