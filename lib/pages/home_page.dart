import 'package:flutter/material.dart';
import 'find_room_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 16.0),
            height: 100,
            child: PageView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  color: index % 2 == 0 ? Colors.blue : Colors.green,
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        print('Button pressed: ${index % 2 == 0 ? '방 찾기' : '방 만들기'}'); // 프린트문 추가
                        if (index % 2 == 0) {
                          // '방 찾기' 페이지로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FindRoomPage()),
                          );
                        } else {
                          // '방 만들기'에 대한 동작 추가
                        }
                      },
                      child: Text(
                        index % 2 == 0 ? '방 찾기' : '방 만들기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

