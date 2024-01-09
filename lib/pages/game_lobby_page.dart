import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/room.dart';

class GameRoomPage extends StatelessWidget {
  final String userId;
  final String userName;
  final IO.Socket socket; // 소켓 인스턴스 추가
  final Room room;

  GameRoomPage({Key? key,  required this.userId, required this.userName, required this.socket, required this.room})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.roomName),
      ),
      body: Column(
        children: [
          // 참가자 목록
          Expanded(
            child: ListView.builder(
              itemCount: room.playerNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('대기방'),
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
              // 방 나가기 로직
              socket.emit('roomQuit', {'roomCode': room.roomCode, 'userId': userId}); // 소켓 인스턴스 사용
              Navigator.pop(context);
            },
            child: Text('Leave Room'),
          ),
        ],
      ),
    );
  }
}
