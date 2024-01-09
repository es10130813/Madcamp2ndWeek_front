import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';
import '../model/user_model.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  //final String serverUrl = 'http://143.248.196.37:3000';
  List<Map<String, dynamic>> userDataList = [];

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff121212),
        title: Text(
          "FRIENDS",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
      body: Scaffold(
        backgroundColor: Color(0xff121212),
        body: Container(
          color: Color(0xff121212),
          child: ListView.builder(
            itemCount: userDataList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Card(
                  color: Colors.white10,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                  child: ListTile(
                    leading: ClipOval(
                      child: Image.network(
                        userDataList[index]["profilePictureUrl"].toString(),
                        width: 50,  // 원의 지름 설정
                        height: 50, // 원의 지름 설정
                        fit: BoxFit.cover, // 짧은 쪽에 맞추어 이미지를 조정
                      ),
                    ),

                    title: Text(
                      userDataList[index]["username"].toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'score: ${userDataList[index]['rankingScore']}',
                      style: TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
