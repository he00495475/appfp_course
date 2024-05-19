import 'package:flutter/material.dart';

class IconButtonConfirmActionWidget extends StatelessWidget {
  final String titleMessage;
  final String? subMessage;
  final VoidCallback onConfirm;

  const IconButtonConfirmActionWidget({
    super.key,
    required this.titleMessage,
    this.subMessage = '',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: () {
        _showConfirmationDialog(context);
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titleMessage),
          content: Text(subMessage as String),
          actions: <Widget>[
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("確認"),
              onPressed: () {
                // Call the provided callback
                onConfirm();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
