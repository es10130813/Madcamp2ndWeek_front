import 'package:flutter/material.dart';
import 'kakaotalk_login.dart';

class StartPage extends StatelessWidget{
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(), // 빈 컨테이너를 추가하여 아래의 위젯들이 화면의 아래에 정렬되도록 함
            ),
            Container(
              margin: EdgeInsets.only(
                left: 10.0, // 좌측 마진
                top: 4.0, // 상단 마진
                right: 10.0, // 우측 마진
                bottom: 4.0, // 하단 마진
              ),
              child: Material(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () {
                    print("버튼 터치");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    alignment: Alignment.center,
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
              left: 10.0, // 좌측 마진
              top: 4.0, // 상단 마진
              right: 10.0, // 우측 마진
              bottom: 4.0, // 하단 마진
            ),
              child: Material(
                borderRadius: BorderRadius.circular(15.0),
                color: Color(0xffF7E600),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15.0),
                  onTap: () {
                    kakaotalk_login();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60.0,
                    alignment: Alignment.center,
                    child: Text(
                      "Continue with Kakao",
                      style: TextStyle(
                          color: Color(0xff3A1D1D),
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: InkWell(
                onTap: (){
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text(
                  "Create new account >",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
              height: 8.0,
            )
          ]
        ),
      ),
    );
  }
}