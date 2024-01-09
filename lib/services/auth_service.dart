import 'dart:convert';
import 'package:http/http.dart' as http;
import '../globals.dart';

Future<String> signUp(Map udata) async {
  try {
    final response = await http.post(
      Uri.parse('$serverUrl/register'),
      body: jsonEncode(udata),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      print("성공");
      return "회원가입 성공";
    } else {
      print("실패");
      return "중복된 id입니다."; // 또는 response body에 따른 상세 메시지
    }
  } catch (e) {
    print("에러");
    return 'Error: $e'; // 오류 메시지 반환
  }
}

// 서버에 로그인 요청을 보내는 함수
Future<String> login(Map udata) async {
  try {
    final response = await http.post(
      Uri.parse('$serverUrl/login'),
      body: jsonEncode(udata),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return "로그인 성공";
    } else {
      return "바르지 않은 계정 정보입니다.";
    }
  } catch (e) {
    return "Error: $e";
  }
}
