import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserViewModel extends ChangeNotifier {
// Firestore 實例
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;

  User? _user;

  User? get user => _user;

  Future<void> login(String account, String password) async {
    // final users = FirebaseFirestore.instance.collection('users');
    // final snapshot = await users.where('account', isEqualTo: account).get();

    // _user = User(id: '1', account: account, password: password);
    notifyListeners();
  }

  void logout() {
    // 将用户信息清空
    _user = null;
    // 通知監聽器进行更新
    notifyListeners();
  }
}
