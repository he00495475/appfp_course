import 'package:appfp_course/models/course_create.dart';
import 'package:appfp_course/models/course_modify.dart';
import 'package:appfp_course/models/student_course_create.dart';
import 'package:appfp_course/models/student_course_modify.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  final String baseUrl = 'http://your-api-base-url.com'; // 將此替換為您的實際 API 基本 URL

  //帳號查詢
  static Future<Map<String, dynamic>?> accountCheck(String account) async {
    final Map<String, dynamic>? user;
    try {
      user = await Supabase.instance.client
          .from('customers')
          .select('*')
          .eq('account', account)
          .maybeSingle();
      return user;
    } catch (e) {
      throw e;
    }
  }

  static Future<Map<String, dynamic>?> login(
      String account, String password, String type) async {
    final Map<String, dynamic>? user;
    try {
      user = await Supabase.instance.client
          .from('customers')
          .select('*')
          .eq('account', account)
          .eq('password', password)
          .eq('type', type) //'teacher' or 'student'
          .maybeSingle();
      return user;
    } catch (e) {
      throw e;
    }
  }

  // 取得學生資訊
  static Future<Map<String, dynamic>?> getStudent(int id) async {
    final Map<String, dynamic>? user;
    try {
      user = await Supabase.instance.client
          .from('students')
          .select('*')
          .eq('id', id)
          .maybeSingle();
      return user;
    } catch (e) {
      throw e;
    }
  }

  // 取得學生選課清單
  static Future<List<Map<String, dynamic>>?> getStudentCourses(
      int studentId) async {
    final List<Map<String, dynamic>> courseList;
    try {
      courseList = await Supabase.instance.client
          .from('student_courses')
          .select(
              '*, courses(*, teachers(*, jobs(*)), classroom(*)), students(*)')
          .eq('student_id', studentId)
          .order('id', ascending: false);
      return courseList;
    } catch (e) {
      throw e;
    }
  }

  // 學生新增課程
  Future<void> studentCourseCreate(StudentCourseCreate courseCreate) async {
    try {
      await Supabase.instance.client
          .from('student_courses')
          .insert(courseCreate);
    } catch (e) {
      throw e;
    }
  }

  // 學生修改課程
  Future<void> studentCourseModify(
      StudentCourseModify studentCourseModify) async {
    try {
      await Supabase.instance.client
          .from('student_courses')
          .update(studentCourseModify.toJson())
          .match({'id': studentCourseModify.id});
    } catch (e) {
      throw e;
    }
  }

  // 學生刪除課程
  void studentCourseDelete(int studentCourseId) async {
    try {
      await Supabase.instance.client
          .from('student_courses')
          .delete()
          .match({'id': studentCourseId});
    } catch (e) {
      throw e;
    }
  }

  //----------以下老師部分
  // 新增老師
  static Future<void> teacherCreate(dynamic json) async {
    // 新增資料
    final teacherData = json['teacher'];
    final customer = json['customer'];
    try {
      await Supabase.instance.client.from('teachers').insert(teacherData);

      final teacher = await getLastTeacher();
      customer['relative_id'] = teacher!['id'];

      await Supabase.instance.client.from('customers').insert(customer);
    } catch (e) {
      print(e);
    }
  }

  // 取得老師資訊
  static Future<Map<String, dynamic>?> getTeacher(int id) async {
    final Map<String, dynamic>? user;
    try {
      user = await Supabase.instance.client
          .from('teachers')
          .select('*')
          .eq('id', id)
          .maybeSingle();
      return user;
    } catch (e) {
      throw e;
    }
  }

  // 取得老師的課程清單
  static Future<List<Map<String, dynamic>>?> getTeacherCourses(
      int teacherId) async {
    final List<Map<String, dynamic>> courseList;
    try {
      courseList = await Supabase.instance.client
          .from('courses')
          .select(
              '*, teachers(*, jobs(*)), classroom(*), student_courses(*, students(*))')
          .eq('teacher_id', teacherId)
          .order('id', ascending: false);
      return courseList;
    } catch (e) {
      throw e;
    }
  }

  // 取得最新的老師
  static Future<Map<String, dynamic>?> getLastTeacher() async {
    final Map<String, dynamic> teacher;
    try {
      teacher = await Supabase.instance.client
          .from('teachers')
          .select('*')
          .order('id', ascending: false)
          .limit(1)
          .single();
      return teacher;
    } catch (e) {
      throw e;
    }
  }

  // 取得老師清單
  static Future<List<Map<String, dynamic>>?> getTeacherList() async {
    final List<Map<String, dynamic>> teacherList;
    try {
      teacherList = await Supabase.instance.client
          .from('teachers')
          .select('*, jobs(*), courses(*, classroom(*), teachers(*))')
          .order('id', ascending: false);
      return teacherList;
    } catch (e) {
      throw e;
    }
  }

  // 取得房間清單
  static Future<List<Map<String, dynamic>>?> getRoomList() async {
    final List<Map<String, dynamic>> roomList;
    try {
      roomList = await Supabase.instance.client
          .from('classroom')
          .select('*')
          .order('id', ascending: false);
      return roomList;
    } catch (e) {
      throw e;
    }
  }

  // 老師新增課程
  Future<void> courseCreate(CourseCreate courseCreate) async {
    try {
      await Supabase.instance.client.from('courses').insert(courseCreate);
    } catch (e) {
      throw e;
    }
  }

  // 老師修改課程
  Future<void> courseModify(CourseModify courseCreate) async {
    try {
      await Supabase.instance.client
          .from('courses')
          .update(courseCreate.toJson())
          .match({'id': courseCreate.id});
    } catch (e) {
      throw e;
    }
  }

  // 老師刪除課程
  void courseDelete(int courseId) async {
    try {
      await Supabase.instance.client
          .from('courses')
          .delete()
          .match({'id': courseId});
    } catch (e) {
      throw e;
    }
  }
}
