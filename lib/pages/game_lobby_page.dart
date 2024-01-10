import 'package:flutter/material.dart';
import 'package:madcamp_2nd_week/game/game_play_2.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../game/game_play.dart';
import '../game/game_play_3.dart';
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
        } else if (playerNames.length==3){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GamePlay3(playerNames: playerNames, playerIDs:playerIDs, userId:widget.userId)), // _GamePlay 페이지로 이동
          );
        }else
        {
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
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.deepPurple[300]),
          backgroundColor: Color(0xFF121212), // AppBar 배경색도 설정
          title: Text(widget.room.roomName, style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            SizedBox(height: 10,),
            // 참가자 목록
            Expanded(
              child: ListView.builder(
                itemCount: playerNames.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      color: Colors.white10,
                      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                      child: ListTile(
                        title: Text(playerNames[index], style: TextStyle(color: Colors.white),),
                      ),
                    ),
                  );
                },
              ),
            ),
            // 게임 시작 버튼

            // 카운트 다운 표시
            Text(
              'Game starts in $countdownSeconds seconds...',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
            // 방 나가기 버튼
            SizedBox(height: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple[300], // 버튼 배경색 변경
                onPrimary: Colors.black, // 버튼 텍스트 색상 변경
              ),
              onPressed: () => leaveRoom(context),
              child: Text('Leave Room'),
            ),
            SizedBox(height: 20,)
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
