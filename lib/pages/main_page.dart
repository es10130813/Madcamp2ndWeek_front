import 'package:flutter/material.dart';
import 'package:madcamp_2nd_week/pages/ranking_page.dart';
import 'home_page.dart';
import 'my_page.dart';

class MainPage extends StatefulWidget {
  final String userId;
  const MainPage({super.key, required this.userId});

  @override
  MainPageState createState() => MainPageState();
}
class MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  List<Widget> get _navIndex => [
    RankingPage(),
    HomePage(),
    MyPage(userId: widget.userId), // MyPage 생성자에 userId 전달
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: _navIndex.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff121212),
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: '랭킹',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
