import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_2nd_week/pages/main_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState  extends State<LogInPage>{
    //final String serverUrl = 'http://143.248.196.86:3000';
    final String serverUrl = 'http://143.248.219.153:3000';

  String loginResult = '';
  int statusCode = 0;

  var idController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> login(Map udata) async {
    try {
      print(udata);
      final response = await http.post(
        Uri.parse('$serverUrl/login'),
        body: jsonEncode(udata),
        headers: {"Content-Type": "application/json"},
      );

      statusCode = response.statusCode;
      print(statusCode);
      if (response.statusCode == 200) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage(userId: idController.text)), // NewPage는 이동하려는 새 페이지
              (Route<dynamic> route) => false, // 이 조건이 false를 반환하면 모든 페이지를 제거
        );
      } else {
        setState(() {
          loginResult = '로그인 실패: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        loginResult = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea (
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                var data = {
                  "uid" : idController.text,
                  "password" : passwordController.text
                };
                login(data);
              },
              child: Text('Log In'),
            ),
            SizedBox(height: 20),
            Text('LogIn 결과: $loginResult'),
          ],
        ),
      ),
    );
  }
}
