import 'package:appfp_course/models/courseCreate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiService {
  final String baseUrl = 'http://your-api-base-url.com'; // 將此替換為您的實際 API 基本 URL

  // 學生登入
  static Future<Map<String, dynamic>?> studentLogin(
      String account, String password) async {
    final user = await Supabase.instance.client
        .from('customers')
        .select('*, students(*)')
        .eq('account', account)
        .eq('password', password)
        .eq('type', 'student')
        .maybeSingle();

    return user;
  }

  // 老師登入
  static Future<Map<String, dynamic>?> teacherLogin(
      String account, String password) async {
    final user = await Supabase.instance.client
        .from('customers')
        .select('*, teachers(*)')
        .eq('account', account)
        .eq('password', password)
        .eq('type', 'teacher')
        .maybeSingle();

    return user;
  }

  // 取得所有課程清單
  static Future<List<Map<String, dynamic>>?> getCourseList() async {
    final courseList = await Supabase.instance.client
        .from('courses')
        .select('*, teachers(*, jobs(*)), classroom(*)');

    return courseList;
  }

  // 取得老師清單
  static Future<List<Map<String, dynamic>>?> getTeacherList() async {
    final teacherList = await Supabase.instance.client
        .from('teachers')
        .select('*, jobs(*), courses(*)');

    return teacherList;
  }

  // 取得房間清單
  static Future<List<Map<String, dynamic>>?> getRoomList() async {
    final roomList =
        await Supabase.instance.client.from('classroom').select('*');

    return roomList;
  }

  // 老師新增課程
  void courseCreate(CourseCreate courseCreate) async {
    await Supabase.instance.client.from('courses').insert(courseCreate);
  }
}
