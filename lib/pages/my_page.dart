import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:madcamp_2nd_week/pages/main_page.dart';

class MyPage extends StatefulWidget {
  final String userId;
  const MyPage({super.key, required this.userId});

  @override
  MyPageStaet createState() => MyPageStaet();
}

class MyPageStaet  extends State<MyPage>{
  final String serverUrl = 'http://143.248.219.153:3000';
  int statusCode = 0;
  String username = "";

  Future<void> getUsername(Map udata) async {
    try {
      print(udata);
      final response = await http.post(
        Uri.parse('$serverUrl/mypage'),
        body: jsonEncode(udata),
        headers: {"Content-Type": "application/json"},
      );

      statusCode = response.statusCode;
      print(statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        username = data['message'];
        print("username: $username");
      } else {
        username = "유저정보를 가져오지 못했습니다.";
      }
    } catch (e) {

    }
  }
  @override
  void initState() {
    super.initState();
    print('UserId: ${widget.userId}');
    var data = {"uid" : widget.userId};
    getUsername(data);
  }

  @override
  Widget build(BuildContext context
      ) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff121212),
        title: Text(
          "MY PAGE",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
      body: Scaffold(
        backgroundColor: Color(0xff121212),

      ),
    );
  }

}