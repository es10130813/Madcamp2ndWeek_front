import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  MyPageStaet createState() => MyPageStaet();
}

class MyPageStaet  extends State<MyPage>{
  @override
  Widget build(BuildContext context
      ) {
    return Scaffold(
      backgroundColor: Colors.pink,
    );
  }

}