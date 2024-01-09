import 'package:flutter/material.dart';

class GameRoomPage extends StatelessWidget {
  final String roomName;
  final List<String> participants; // 참가자 목록

  GameRoomPage({Key? key, required this.roomName, required this.participants}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(roomName), // 방 이름 표시
      ),
      body: Column(
        children: [
          // 참가자 목록 표시
          Expanded(
            child: ListView.builder(
              itemCount: participants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(participants[index]),
                );
              },
            ),
          ),
          // 게임 시작 버튼
          ElevatedButton(
            onPressed: () {
              // 게임 시작 로직...
            },
            child: Text('Start Game'),
          ),
          // 방 나가기 버튼
          ElevatedButton(
            onPressed: () {
              // 방 나가기 로직...
              Navigator.pop(context);
            },
            child: Text('Leave Room'),
          ),
        ],
      ),
    );
  }
}
