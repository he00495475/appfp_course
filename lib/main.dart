import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_models/user_view_model.dart';
import 'view_models/course_view_model.dart';
import 'views/login_page.dart';
import 'views/student_page.dart';
import 'views/courses_page.dart';

enum BottomNavItem {
  student,
  course,
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
      ],
      child: MaterialApp(
        title: 'Flutter MVVM Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BottomNavItem _selectedItem = BottomNavItem.student;

  static List<Widget> _widgetOptions = <Widget>[
    StudentHomePage(),
    CoursesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        if (userViewModel.user != null) {
          return Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedItem.index),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedItem.index,
              onTap: _onItemTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '個人資訊',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app),
                  label: '我的課程',
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: LoginPage(),
          );
        }
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      // 根据索引设置选中的项目
      _selectedItem = BottomNavItem.values[index];
    });
  }
}
