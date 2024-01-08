import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../globals.dart';
import '../pages/main_page.dart';

Future<String> signUp(Map udata, String serverUrl) async {
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

Future<void> login(BuildContext context, Map udata, Function(String) updateLoginResult) async {
  try {
    print(udata);
    final response = await http.post(
      Uri.parse('YOUR_SERVER_URL/login'),  // YOUR_SERVER_URL을 서버의 URL로 변경하세요.
      body: jsonEncode(udata),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage(userId: udata['uid'])),
            (Route<dynamic> route) => false,
      );
    } else {
      updateLoginResult('바르지 않은 계정 정보입니다.');
    }
  } catch (e) {
    updateLoginResult('Error: $e');
  }
}
