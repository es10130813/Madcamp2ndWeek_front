import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/room.dart';

class GameRoomPage extends StatefulWidget {
  final String userId;
  final String userName;
  final IO.Socket socket;
  final Room room;

  GameRoomPage({Key? key, required this.userId, required this.userName, required this.socket, required this.room})
      : super(key: key);

  @override
  _GameRoomPageState createState() => _GameRoomPageState();
}

class _GameRoomPageState extends State<GameRoomPage> {
  List<String> playerNames = [];

  @override
  void initState() {
    super.initState();
    playerNames = widget.room.playerNames;

    widget.socket.on('updateRooms', (data) {
      var updatedRoom = data.firstWhere(
              (r) => r['roomCode'] == widget.room.roomCode,
          orElse: () => null);

      if (updatedRoom != null) {
        setState(() {
          playerNames = List<String>.from(updatedRoom['playerNames']);
        });
      }
    });
  }

  void leaveRoom(BuildContext context) {
    widget.socket.emit('roomQuit', {'roomCode': widget.room.roomCode, 'userId': widget.userId});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        leaveRoom(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.room.roomName),
        ),
        body: Column(
          children: [
            // 참가자 목록
            Expanded(
              child: ListView.builder(
                itemCount: playerNames.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(playerNames[index]),
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
              onPressed: () => leaveRoom(context),
              child: Text('Leave Room'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.socket.off('playerJoined');
    widget.socket.off('playerLeft');
    super.dispose();
  }
}
