import 'package:appfp_course/helper/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/customer_view_model.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback? onLoginCallback;
  const LoginPage({super.key, this.onLoginCallback});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<CustomerViewModel>(context);
    return MyWidget(
        userViewModel: userViewModel, onLoginCallback: onLoginCallback);
  }
}

class MyWidget extends StatefulWidget {
  final VoidCallback? onLoginCallback;
  final CustomerViewModel userViewModel;
  const MyWidget(
      {super.key,
      required CustomerViewModel this.userViewModel,
      this.onLoginCallback});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  //sqfLite
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  //登入判斷 '學生' or '老師'
  int _selectedLoginIndex = 0; //0：學生 1：老師
  void _selectTab(int index) {
    setState(() {
      _selectedLoginIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //登入帳號寫入sqflite
    Future<void> setSqfLite() async {
      databaseHelper.clearTable(); //每次登入只存一筆登入人資訊
      final type = widget.userViewModel.customer?.type;

      if (type == 'student') {
        final student = widget.userViewModel.customer?.student;
        await databaseHelper.insertData(
            {'id': student?.id, 'name': student?.name, 'type': 'student'});
      } else if (type == 'teacher') {
        final teacher = widget.userViewModel.customer?.teacher;
        await databaseHelper.insertData(
            {'id': teacher?.id, 'name': teacher?.name, 'type': 'teacher'});
      }
    }

    void checkLogin() {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); //預先關閉提示，防止重複彈出
      Future<String> result;
      if (_selectedLoginIndex == 0) {
        //學生登入
        result = widget.userViewModel
            .studentLogin(_accountController.text, _passwordController.text);
      } else {
        //老師登入
        result = widget.userViewModel
            .teacherLogin(_accountController.text, _passwordController.text);
      }
      result.then((errMessage) => {
            if (errMessage != '')
              {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(errMessage)))
              }
            else
              {
                setSqfLite(),
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('登入成功'),
                  backgroundColor: Colors.green,
                ))
              }
          });
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('登入'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectTab(0);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        _selectedLoginIndex == 0 ? Colors.white : null,
                    backgroundColor:
                        _selectedLoginIndex == 0 ? Colors.blue : null,
                  ),
                  child: const Text('學生登入'),
                ),
                const SizedBox(width: 20), // Spacer between buttons
                ElevatedButton(
                  onPressed: () {
                    _selectTab(1);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        _selectedLoginIndex == 1 ? Colors.white : null,
                    backgroundColor:
                        _selectedLoginIndex == 1 ? Colors.blue : null,
                  ),
                  child: const Text('老師登入'),
                ),
              ],
            ),
            TextFormField(
              controller: _accountController,
              decoration: const InputDecoration(label: Text('帳號')),
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(label: Text('密碼')),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                checkLogin();
                if (widget.onLoginCallback != null) {
                  widget.onLoginCallback!();
                }
              },
              child: const Text('登入'),
            ),
          ],
        ),
      ),
    );
  }
}
