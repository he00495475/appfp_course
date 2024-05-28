import 'package:appfp_course/service/api_service.dart';
import 'package:appfp_course/widgets/textFormFieldWidget/textFormFieldWidget.dart';
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
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void submit() async {
    if (_passwordController.text != _passwordConfirmController.text) {
      showErrorPassWord();
      return;
    }

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
        'image': '',
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
    Navigator.of(context).pop();
  }

  void showErrorPassWord() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('密碼與確認密碼需一致！！'),
      backgroundColor: Colors.red,
    ));
  }

  void showError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('此帳號已註冊！！'),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('老師帳號註冊'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              textFormField(
                controller: _nameController,
                labelText: '姓名',
                validatorText: '請輸入姓名！',
              ),
              const SizedBox(height: 16),
              textFormField(
                controller: _accountController,
                labelText: '帳號',
                validatorText: '請輸入帳號！',
              ),
              const SizedBox(height: 16),
              textFormField(
                controller: _passwordController,
                labelText: '密碼',
                obscure: true,
                validatorText: '請輸入密碼！',
              ),
              textFormField(
                controller: _passwordConfirmController,
                labelText: '確認密碼',
                obscure: true,
                validatorText: '請輸入確認密碼！',
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    // 如果表單驗證通過，執行提交邏輯
                    submit();
                  }
                },
                child: const Text('確認'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
