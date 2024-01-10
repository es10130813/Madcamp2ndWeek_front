import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:madcamp_2nd_week/game/game_play.dart';
import 'package:madcamp_2nd_week/pages/friends_page.dart';
import 'package:madcamp_2nd_week/pages/log_in_page.dart';
import 'package:madcamp_2nd_week/pages/main_page.dart';
import 'package:madcamp_2nd_week/pages/sign_up_page.dart';
import 'package:madcamp_2nd_week/pages/start_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  KakaoSdk.init(nativeAppKey: "138b2870d6fd69311bfa6d3fed1c9762");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<Widget> getInitialPage() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      return MainPage(userId: userId, userName: '',);
    } else {
      return StartPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<Widget>(
        future: getInitialPage(), // getInitialPage를 비동기로 호출
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StartPage(); // 데이터가 있으면 해당 페이지를, 없으면 시작 페이지를 반환 // 임시로 바꿔놓음
          } else {
            // 데이터를 기다리는 동안 로딩 화면을 표시합니다.
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      routes: {
        '/signup': (context) => SignUpPage(),
        '/login' : (context) => LogInPage(),
        '/main' : (context) => MainPage(userId: '', userName: '',),
        '/start' : (context) => StartPage(),
        '/friends' : (context) => FriendsPage(),
      },
    );
  }
}