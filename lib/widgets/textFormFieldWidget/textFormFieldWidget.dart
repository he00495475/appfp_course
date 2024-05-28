//---------- Widget
import 'package:flutter/material.dart';

Widget textFormField(
    {required TextEditingController controller,
    bool enabled = true,
    required String labelText,
    String validatorText = '',
    bool obscure = false}) {
  return TextFormField(
    controller: controller,
    enabled: enabled,
    maxLines: obscure ? 1 : null,
    obscureText: obscure,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 16),
      border: !enabled ? InputBorder.none : null, // 去除边框
      disabledBorder: !enabled ? InputBorder.none : null, // 禁用时去除边框
      contentPadding: const EdgeInsets.only(bottom: 10, top: 10), // 去除内边距
      filled: true, // 使用填充颜色
      fillColor: Colors.transparent, // 填充颜色设为透明
    ),
    style: const TextStyle(
      color: Colors.black, // 文字颜色
    ),
    validator: (value) {
      if (enabled && (value == null || value.isEmpty)) {
        return validatorText;
      }
      return null;
    },
  );
}
