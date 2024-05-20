import 'package:appfp_course/helper/databaseHelper.dart';
import 'package:appfp_course/view_models/room_view_model.dart';
import 'package:appfp_course/view_models/teacher_view_model.dart';
import 'package:appfp_course/views/home_page.dart';
import 'package:appfp_course/views/teachers_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'view_models/customer_view_model.dart';
import 'view_models/course_view_model.dart';
import 'views/login_page.dart';
import 'views/courses_page.dart';

enum BottomNavItem {
  home,
  course,
  teacher,
}

const supabaseUrl = 'https://yigvkdionhriaysvncqo.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpZ3ZrZGlvbmhyaWF5c3ZuY3FvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU1MzU0ODIsImV4cCI6MjAzMTExMTQ4Mn0._teNWz-hP5End8gxDk9AHcfZK7HCOnOvArJH7gAKJXA';

Future<void> main() async {
  await Supabase.initialize(
      url: supabaseUrl,
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlpZ3ZrZGlvbmhyaWF5c3ZuY3FvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU1MzU0ODIsImV4cCI6MjAzMTExMTQ4Mn0._teNWz-hP5End8gxDk9AHcfZK7HCOnOvArJH7gAKJXA');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // sqfLite
  late DatabaseHelper databaseHelper;
  Map<String, dynamic> customer = {};

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    loadData();
  }

  Future<void> loadData() async {
    final customers = await databaseHelper.getData();
    if (customers.isNotEmpty) {
      customer = customers.first;
      setState(() {});
    }
  }

  BottomNavItem _selectedItem = BottomNavItem.home;

  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    const CoursesPage(),
    const TeachersPage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavigationBarItem =
      <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '首頁',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.menu_book),
      label: '我的課程',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.people),
      label: '講師清單',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerViewModel>(
      builder: (context, userViewModel, child) {
        if (customer.isNotEmpty || userViewModel.customer != null) {
          return Scaffold(
              body: Center(
                child: _widgetOptions.elementAt(_selectedItem.index),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedItem.index,
                onTap: _onItemTapped,
                items: (userViewModel.isTeacher)
                    ? [
                        _bottomNavigationBarItem.elementAt(0),
                        _bottomNavigationBarItem.elementAt(1)
                      ]
                    : _bottomNavigationBarItem,
              ));
        } else {
          return Scaffold(
            body: LoginPage(
              onLoginCallback: () {},
            ),
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
