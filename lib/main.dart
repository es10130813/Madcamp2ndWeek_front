import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:madcamp_2nd_week/pages/sign_up_page.dart';
import 'package:madcamp_2nd_week/pages/start_page.dart';

void main() {
  KakaoSdk.init(nativeAppKey: "138b2870d6fd69311bfa6d3fed1c9762");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StartPage(),
      routes: {
        '/signup': (context) => SignUpPage(),
        '/login' : (context) => LogInPage(),
        '/main' : (context) => MainPage(),
      },
    );
  }
}


//test2new