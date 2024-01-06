import 'package:flutter/material.dart';
import 'package:madcamp_2nd_week/pages/ranking_page.dart';
import 'home_page.dart';
import 'my_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageStaet createState() => MainPageStaet();
}

class MainPageStaet  extends State<MainPage>{
  int _currentIndex = 1;

  final List<Widget> _navIndex = [
    RankingPage(),
    HomePage(),
    MyPage(),
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
      body:  _navIndex.elementAt(_currentIndex),
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
