import 'package:appfp_course/helper/databaseHelper.dart';
import 'package:appfp_course/main.dart';
import 'package:appfp_course/view_models/customer_view_model.dart';
import 'package:appfp_course/views/login_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({super.key});

  @override
  State<_HomePage> createState() => _HomeHomePageState();
}

class _HomeHomePageState extends State<_HomePage> {
  // sqfLite
  late DatabaseHelper databaseHelper;
  String name = '';

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    loadData();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void loadData() async {
    final customers = await databaseHelper.getData();
    if (customers.isNotEmpty) {
      setState(() {
        name = customers.first['name'];
      });
    }
  }

  void logOut() async {
    databaseHelper.clearTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('選課系統'),
      ),
      body: const Center(
        child: Text(
          "歡迎使用選課系統",
          style: TextStyle(fontSize: 20),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('登出'),
              onTap: () {
                logOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
