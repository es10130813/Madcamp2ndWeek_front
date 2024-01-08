import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  LogInPageState createState() => LogInPageState();
}

class LogInPageState  extends State<LogInPage>{

    String loginResult = '';
    int statusCode = 0;

    var idController = TextEditingController();
    var passwordController = TextEditingController();

    bool get isButtonEnabled => idController.text.isNotEmpty && passwordController.text.isNotEmpty;

  @override Widget build(BuildContext context) {
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
                  login(context, data, (String result) {
                    setState(() {
                      loginResult = result;
                    });
                  });
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
