// api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String baseUrl = "http://143.248.196.88:3000/"; // 실제 서버 IP와 포트 번호를 입력하세요

  static Future<void> adduser(Map udata) async {
    var url = Uri.parse(baseUrl + "register");

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(udata),
      );

      if (res.statusCode == 201) {
        var data = jsonDecode(res.body);
        print("User added: $data");
      } else {
        print("Failed to add user: ${res.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}