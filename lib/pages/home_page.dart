import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageStaet createState() => HomePageStaet();
}

class HomePageStaet  extends State<HomePage>{
  @override
  Widget build(BuildContext context
      ) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: Center(
          child:
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0),
              height: 100,
              child: PageView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    // 각 페이지의 크기를 지정
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    width: MediaQuery.of(context).size.width * 0.8, // 전체 너비의 80%
                    height: MediaQuery.of(context).size.height * 0.6, // 전체 높이의 60%
                    color: index % 2 == 0 ? Colors.blue : Colors.green,
                    child: Center(
                      child:  index % 2 == 0 ? Text('방 찾기'):  Text('방 만들기'),
                    ),
                  );
                },
              ),
            )
        ),
      ),
    );
  }

}