import 'package:appfp_course/service/api_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyWidget();
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({
    super.key,
  });

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  Widget textForm(TextEditingController textEditingController,
      String decoration, bool obscureText) {
    return TextFormField(
      obscureText: obscureText,
      controller: textEditingController,
      decoration: InputDecoration(label: Text(decoration)),
    );
  }

  void submit() async {
    final dynamic json = {
      'customer': {
        'account': _accountController.text,
        'password': _passwordController.text,
        'type': 'teacher',
        'relative_id': 0
      },
      'teacher': {
        'name': _nameController.text,
        'job_id': 1, //預設1 為一般講師
      },
    };

    try {
      final reData = await ApiService.accountCheck(_accountController.text);
      if (reData != null) {
        showError();
      } else {
        await ApiService.teacherCreate(json);
        showSuccess();
      }
    } catch (e) {
      print(e);
    }
  }

  void showSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('註冊成功！！'),
      backgroundColor: Colors.green, // 設置成功提示的背景色
    ));
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('此帳號已註冊！！'),
      backgroundColor: Colors.red, // 設置成功提示的背景色
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('老師帳號註冊'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            textForm(_accountController, '帳號', false),
            const SizedBox(height: 16),
            textForm(_passwordController, '密碼', true),
            const SizedBox(height: 16),
            textForm(_nameController, '姓名', false),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                submit();
              },
              child: const Text('確認'),
            ),
          ],
        ),
      ),
    );
  }
}
