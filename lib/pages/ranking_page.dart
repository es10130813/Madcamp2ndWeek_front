import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user_model.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  RankingPageState createState() => RankingPageState();
}

class RankingPageState extends State<RankingPage> {
  final String serverUrl = 'http://143.248.219.153:3000';
  List<Map<String, dynamic>> userDataList = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();// 페이지가 열릴 때 데이터를 가져오기 위해 initState에서 fetchUserData 함수 호출
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse("$serverUrl/ranking"); // API 엔드포인트 URL로 수정
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> userData = json.decode(response.body);

        List<Map<String, dynamic>> updatedUserDataList = [];

        userData.forEach((user) {
          Map<String, dynamic> userMap = {
            'username': user['username'],
            'uid': user['uid'],
            'password': user['password'],
            'type': user['type'],
          };
          updatedUserDataList.add(userMap);
        });
        setState(() {
          userDataList =
              updatedUserDataList; // userDataList를 업데이트하고 화면을 다시 그리도록 setState 호출
        });
        //print(userDataList);
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
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
          "RANKING",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
      body: Scaffold(
        backgroundColor: Color(0xff121212),
        body: SafeArea(
          child: Container(
            color: Color(0xff121212),
            child: ListView.builder(
              itemCount: userDataList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: ListTile(
                      leading: Image.asset("assets/images/profile_pic.png"),
                      title: Text(
                        userDataList[index]["username"].toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      subtitle:
                      Text(
                        '비번: ${userDataList[index]["password"]}',
                        style: TextStyle(
                        color: Colors.white60,
                      ),
                    ),
                  ),),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
