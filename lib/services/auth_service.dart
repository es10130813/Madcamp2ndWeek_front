import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> signUp(Map udata, String serverUrl) async {
  try {
    final response = await http.post(
      Uri.parse('$serverUrl/register'),
      body: jsonEncode(udata),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      return "회원가입 성공";
    } else {
      return "중복된 id입니다."; // 또는 response body에 따른 상세 메시지
    }
  } catch (e) {
    return 'Error: $e'; // 오류 메시지 반환
  }
}
