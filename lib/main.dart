import 'package:appfp_course/view_models/room_view_model.dart';
import 'package:appfp_course/view_models/teacher_view_model.dart';
import 'package:appfp_course/views/teachers_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'view_models/customer_view_model.dart';
import 'view_models/course_view_model.dart';
import 'views/login_page.dart';
import 'views/student_page.dart';
import 'views/courses_page.dart';

enum BottomNavItem {
  student,
  course,
  teacher,
}

const supabaseUrl = 'https://yigvkdionhriaysvncqo.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpZ3ZrZGlvbmhyaWF5c3ZuY3FvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU1MzU0ODIsImV4cCI6MjAzMTExMTQ4Mn0._teNWz-hP5End8gxDk9AHcfZK7HCOnOvArJH7gAKJXA';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: supabaseUrl,
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpZ3ZrZGlvbmhyaWF5c3ZuY3FvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU1MzU0ODIsImV4cCI6MjAzMTExMTQ4Mn0._teNWz-hP5End8gxDk9AHcfZK7HCOnOvArJH7gAKJXA');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseViewModel()),
        ChangeNotifierProvider(create: (_) => CustomerViewModel()),
        ChangeNotifierProvider(create: (_) => TeacherViewModel()),
        ChangeNotifierProvider(create: (_) => ClassRoomViewModel()),
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

  final List<Widget> _widgetOptions = <Widget>[
    const StudentHomePage(),
    const CoursesPage(),
    const TeachersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerViewModel>(
      builder: (context, userViewModel, child) {
        if (userViewModel.customer != null) {
          return Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedItem.index),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedItem.index,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '個人資訊',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app),
                  label: '我的課程',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.exit_to_app),
                  label: '講師清單',
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
