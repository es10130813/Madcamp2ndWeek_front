import 'package:flutter/material.dart';
import 'find_room_page.dart';

class HomePage extends StatefulWidget {
  final String userId;
  final String userName;
  const HomePage({super.key, required this.userId, required this.userName});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Container(
              alignment: Alignment.center,
              child: Text(
                "One Card",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 44.0
                ),
              ),
            )),
            Expanded(
              flex: 2,
              child:Container(
                margin: EdgeInsets.symmetric(vertical: 30.0),
                height: 300,
                child: PageView.builder(
                  itemCount: 2,
                  controller: PageController(
                    viewportFraction: 0.8, // 페이지가 화면에서 차지하는 비율을 조정
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.white10,
                      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    print('Button pressed: ${index % 2 == 0 ? '방 찾기' : '방 만들기'}');
                                    if (index % 2 == 0) {
                                      // '방 찾기' 페이지로 이동
                                      Navigator.push(
                                        context,
                                      MaterialPageRoute(builder: (context) => FindRoomPage(userId: widget.userId, userName: widget.userName,)),
                                      );
                                    } else {
                                      // '방 만들기'에 대한 동작 추가
                                    }
                                  },
                                  child: Text(
                                    index % 2 == 0 ? '방 찾기' : '방 만들기',
                                    style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                SizedBox(height: 10), // 텍스트 버튼과 이미지 사이에 간격을 조절하려면 SizedBox를 추가합니다.
                                Container(
                                  width: 230, // Stack의 너비 설정
                                  height: 260, // Stack의 높이 설정
                                  child: Stack(
                                    children: index % 2 == 0
                                        ? [
                                      // 첫 번째 페이지의 이미지들
                                      Positioned(
                                        top: 50,
                                        left: 110,
                                        child: Transform.rotate(
                                          angle: 20 * 3.14159265359 / 180,
                                          child: Image.asset('assets/images/AS_elevation.png', width: 90, height: 126,),
                                        ),
                                      ),
                                      Positioned(
                                        top: 80,
                                        left: 30,
                                        child: Transform.rotate(
                                          angle: -20 * 3.14159265359 / 180,
                                          child: Image.asset('assets/images/card_back_elevation.png', width: 90, height: 126,),
                                        ),
                                      ),
                                    ]
                                        : [
                                      // 두 번째 페이지의 다른 이미지들
                                      Positioned(
                                        top: 50,
                                        left: 105,
                                        child: Transform.rotate(
                                          angle: 20 * 3.14159265359 / 180,
                                          child: Image.asset('assets/images/card_back_elevation.png', width: 90, height: 126,), // 다른 이미지
                                        ),
                                      ),
                                      Positioned(
                                        top: 75,
                                        left: 35,
                                        child: Transform.rotate(
                                          angle: -20 * 3.14159265359 / 180,
                                          child: Image.asset('assets/images/KH.png', width: 90, height: 126,), // 다른 이미지
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                      ),
                    );
                  },
                ),
              ), ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}
