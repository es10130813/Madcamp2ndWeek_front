import 'package:flutter/material.dart';
import '../services/kakaotalk_login.dart';

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
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    Text("One Card", style: TextStyle(fontSize: 40, color: Colors.white),),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(width:250,height:350,child: Image.asset("assets/images/start_logo.png"),),
                    ),
                  ],
                ), // 빈 컨테이너를 추가하여 아래의 위젯들이 화면의 아래에 정렬되도록 함
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 10.0, // 좌측 마진
                  top: 0.0, // 상단 마진
                  right: 10.0, // 우측 마진
                  bottom: 4.0, // 하단 마진
                ),
                child: Material(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
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
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      kakaotalk_login(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60.0,
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(width:50, height:50,child: Image.asset("assets/images/Kakao_logo.jpg")),
                          ),
                          SizedBox(width: 27,),
                          Text(
                            "Continue with Kakao",
                            style: TextStyle(
                                color: Color(0xff3A1D1D),
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                          ),
                        ],
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
