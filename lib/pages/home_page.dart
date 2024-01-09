import 'package:flutter/material.dart';
import 'find_room_page.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

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
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "One Card",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 44.0
                    ),
                  ),
                )
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30.0),
                height: 300,
                child: PageView.builder(
                  itemCount: 2,
                  controller: PageController(viewportFraction: 0.8),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          color: index % 2 == 0 ? Colors.blue : Colors.green,
                          border: Border.all(color: Colors.white, width: 3.0),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () {
                                print('Button pressed: ${index % 2 == 0 ? '방 찾기' : '방 만들기'}');
                                if (index % 2 == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FindRoomPage(userId: widget.userId)),
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
                            // 여기에 이미지 및 기타 요소 추가
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}
