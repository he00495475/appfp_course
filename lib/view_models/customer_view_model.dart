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

  Future<String> login(String account, String password, String type) async {
    final customer = await ApiService.login(account, password, type);

    if (customer == null) {
      // 處理錯誤
      return '登入失敗';
    }

    _customer = Customer(
      id: customer['id'],
      account: customer['account'],
      type: customer['type'],
      relativeId: customer['relative_id'],
    );
    notifyListeners();

    return '';
  }

  // 取得學生資訊
  Future<String> getStudent(int id) async {
    final customer = await ApiService.getStudent(id);

    if (customer == null) {
      // 處理錯誤
      return '登入失敗';
    }

    _customer?.student = Student.fromJson(customer);
    notifyListeners();

    return '';
  }

  // 取得老師資訊
  Future<String> getTeacher(int id) async {
    final customer = await ApiService.getTeacher(id);

    if (customer == null) {
      // 處理錯誤
      return '登入失敗';
    }

    _customer?.teacher = Teacher.fromJson(customer);
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
