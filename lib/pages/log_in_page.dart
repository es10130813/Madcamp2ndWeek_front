import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  bool get isButtonEnabled => idController.text.isNotEmpty && passwordController.text.isNotEmpty;


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
          loginResult = '바르지 않은 계정 정보입니다.';
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
      backgroundColor: Color(0xff121212),
      body: SafeArea (
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: Divider(
                        color: Colors.white, // 선의 색상
                        height: 1.5, // 선과 텍스트의 높이 정렬
                      ),
                    ),
                  ),
                  Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      child: Divider(
                        color: Colors.white, // 선의 색상
                        height: 1.5, // 선과 텍스트의 높이 정렬
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 25.0),
              child: TextField(
                style: TextStyle(
                    color: Colors.white
                ),
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  labelStyle: TextStyle(color: Colors.white70), // 라벨 텍스트 색상 변경
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 1.5), // 기본 상태의 밑줄 색상
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0), // 포커스 됐을 때의 밑줄 색상
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백 입력 방지
                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 25.0),
              child: TextField(
                style: TextStyle(
                  color: Colors.white
                ),
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'password',
                  labelStyle: TextStyle(color: Colors.white70), // 라벨 텍스트 색상 변경
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70, width: 1.5), // 기본 상태의 밑줄 색상
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0), // 포커스 됐을 때의 밑줄 색상
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')), // 공백 입력 방지
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: (){
                  var data = {
                    "uid" : idController.text,
                    "password" : passwordController.text
                  };
                  login(data);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,  // 버튼의 배경 색상
                  onPrimary: Colors.black, // 버튼의 텍스트 색상
                  minimumSize: Size(200, 50), // 버튼의 최소 크기
                ),
                child: Text(
                  'Log In',
                  style: TextStyle(fontSize: 20), // 텍스트의 크기 조정
                ),
              ),
            ),

            SizedBox(height: 20),
            Text('$loginResult', style: TextStyle(color: Colors.red),),
          ],
        ),
      ),
    );
  }
}
