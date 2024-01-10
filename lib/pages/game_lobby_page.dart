import 'package:flutter/material.dart';
import 'package:madcamp_2nd_week/game/game_play_2.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../game/game_play.dart';
import '../model/room.dart';
import 'dart:async';

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
  List<String> playerIDs = [];
  Timer? gameStartTimer;
  int countdownSeconds = 5;

  @override
  void initState() {
    super.initState();
    playerNames = widget.room.playerNames;
    playerIDs = widget.room.playerIDs;

    widget.socket.on('updateRoom', (data) {
      if (mounted && data['roomCode'] == widget.room.roomCode) {
        setState(() {
          playerNames = List<String>.from(data['playerNames']);
          playerIDs = List<String>.from(data['playerIDs']);
        });

        // 사람 수가 numOfPlayer와 같아지면 5초 카운트 시작
        if (playerNames.length == widget.room.numOfPlayer) {
          startGameCountdown();
        } else {
          // 사람 수가 변경될 때 카운트 취소
          cancelGameCountdown();
        }
      }
    });
  }

  void startGameCountdown() {
    gameStartTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countdownSeconds = countdownSeconds - 1;
      });

      if (countdownSeconds == 0) {
        // 카운트 다운 종료 후 게임 시작
        gameStartTimer?.cancel();
        if (playerNames.length==2){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GamePlay2(playerNames: playerNames, playerIDs:playerIDs, userId:widget.userId, socket: widget.socket)), // _GamePlay 페이지로 이동
          );
        }else{
          Navigator.push(
            context,
          MaterialPageRoute(builder: (context) => GamePlay(playerNames: playerNames, playerIDs: playerIDs, userId: widget.userId)), // _GamePlay 페이지로 이동
          );
        }
      }
    });
  }

  void cancelGameCountdown() {
    gameStartTimer?.cancel();
    setState(() {
      countdownSeconds = 5; // 카운트 초기화
    });
  }

  void leaveRoom(BuildContext context) {
    // 카운트 다운 취소
    cancelGameCountdown();

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
            // 카운트 다운 표시
            Text(
              'Game starts in $countdownSeconds seconds',
              style: TextStyle(fontSize: 18),
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
    widget.socket.off('updateRoom');
    gameStartTimer?.cancel(); // 페이지가 dispose될 때 타이머도 취소
    super.dispose();
  }
}
