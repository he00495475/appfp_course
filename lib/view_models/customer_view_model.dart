import 'dart:async';
import 'package:appfp_course/models/student.dart';
import 'package:appfp_course/models/teacher.dart';
import 'package:appfp_course/service/api_service.dart';
import 'package:flutter/material.dart';
import '../models/customer.dart';

class CustomerViewModel extends ChangeNotifier {
  Customer? _customer;

  Customer? get customer => _customer;

  bool get isTeacher => _customer?.type == 'teacher';

  Future<String> studentLogin(String account, String password) async {
    final customer = await ApiService.studentLogin(account, password);

    if (customer == null) {
      // 處理錯誤
      return '登入失敗';
    }

    _customer = Customer(
      id: customer['id'],
      account: customer['account'],
      type: customer['type'],
      student: Student.fromJson(customer['students']),
    );
    notifyListeners();

    return '';
  }

  // 老師登入
  Future<String> teacherLogin(String account, String password) async {
    final customer = await ApiService.teacherLogin(account, password);

    if (customer == null) {
      // 處理錯誤
      return '登入失敗';
    }

    _customer = Customer(
      id: customer['id'],
      account: customer['account'],
      type: customer['type'],
      teacher: Teacher.fromJson(customer['teachers']),
    );
    notifyListeners();

    return '';
  }

  void logout() {
    // 将用户信息清空
    _customer = null;
    // 通知監聽器进行更新
    notifyListeners();
  }
}
