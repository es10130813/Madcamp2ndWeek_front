import 'package:flutter/material.dart';
import 'package:madcamp_2nd_week/pages/log_in_page.dart';
import 'package:madcamp_2nd_week/pages/main_page.dart';
import 'package:madcamp_2nd_week/pages/sign_up_page.dart';
import 'package:madcamp_2nd_week/pages/start_page.dart';

void main() {
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