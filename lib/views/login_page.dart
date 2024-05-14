import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/customer_view_model.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<CustomerViewModel>(context);

    return const MyWidget();
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  bool _loading = false;
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<CustomerViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('登入'),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
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
                setState(() {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  userViewModel
                      .login(_accountController.text, _passwordController.text)
                      .then((customer) => {
                            if (customer != '')
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(customer)))
                              }
                          });
                });
              },
              child: const Text('登入'),
            ),
          ],
        ),
      ),
    );
  }
}
