import 'package:flutter/material.dart';
import 'package:madcamp_2nd_week/firstpage.dart';
import 'package:madcamp_2nd_week/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
      routes: {
        '/signuppage': (context) => const CreateData(),
      },
    );
  }
}