import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../globals.dart';
import '../model/room.dart';
import 'game_lobby_page.dart';

typedef RoomsUpdatedCallback = void Function();

class FindRoomPage extends StatefulWidget {
  final String userId;
  final String userName;
  const FindRoomPage({super.key, required this.userId, required this.userName});

  @override
  _FindRoomPageState createState() => _FindRoomPageState();
}

class _FindRoomPageState extends State<FindRoomPage> {
  late IO.Socket socket;
  List<Room> rooms = []; // 서버로부터 받은 방 목록으로 업데이트될 예정

  @override
  void initState() {
    super.initState();
    initializeSocket();
  }

  @override
  void dispose() {
    socket.disconnect(); // Socket 연결 해제
    socket.off('updateRooms'); // 리스너 해제
    super.dispose();
  }

  void initializeSocket() {
    socket = IO.io(serverUrl , <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.on('connect', (_) {
      print('connect: ${socket.id}');
      fetchRooms();
    });

// 추가적인 로깅을 통해 각 필드의 값을 확인합니다.
    socket.on('updateRooms', (data) {
      if (mounted) {
        setState(() {
          rooms = (data as List)
              .map((roomData) {
            return Room.fromJson(roomData as Map<String, dynamic>);
          })
              .toList();
        });
      }
    });
  }

  void fetchRooms({RoomsUpdatedCallback? onCompleted}) {
    socket.off('updateRooms');
    socket.emit('fetchRooms');
    socket.on('updateRooms', (data) {
      if (mounted) {
        setState(() {
          rooms = (data as List)
              .map((roomData) => Room.fromJson(roomData as Map<String, dynamic>))
              .toList();
        });
        if (onCompleted != null) {
          onCompleted();
        }
      }
    });
  }

  void refreshRooms() {
    fetchRooms();
  }

  void createRoom() async { var roomData = await _showCreateRoomDialog(context);
  if (roomData['roomName'].isNotEmpty && roomData['numOfPlayer'] > 0) {
    socket.emit('createRoom', {
      'hostID': widget.userId,
      'hostName': widget.userName,
      'roomName': roomData['roomName'],
      'numOfPlayer': roomData['numOfPlayer']
    });
  }
  fetchRooms();
  socket.off('roomCreated');
  socket.on('roomCreated', (roomCode) {
    joinRoom(roomCode, roomData['numOfPlayer']);
  });
  }
  Future<Map<String, dynamic>> _showCreateRoomDialog(BuildContext context) async {
    String roomName = '';
    int? numOfPlayer; // 초기값을 null로 설정
    bool isValid = false; // 입력값의 유효성을 확인하기 위한 변수

    while (!isValid) {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[850], // 배경색 변경
            title: Text(
              'Create a Room',
              style: TextStyle(color: Colors.grey[200]), // 타이틀 텍스트 색상 변경
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    roomName = value;
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter room name",
                    hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                  ),
                  style: TextStyle(color: Colors.white), // 입력 텍스트 색상 변경
                ),
                TextField(
                  onChanged: (value) {
                    numOfPlayer = int.tryParse(value);
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter max players (2~4)",
                    hintStyle: TextStyle(color: Colors.grey), // 힌트 텍스트 색상 변경
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white), // 입력 텍스트 색상 변경
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black, // 버튼 텍스트 색상 변경
                  backgroundColor: Colors.deepPurple[300], // 버튼 배경색 변경
                ),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  isValid = true; // 취소 시에는 검증을 중단
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.black, // 버튼 텍스트 색상 변경
                  backgroundColor: Colors.deepPurple[300], // 버튼 배경색 변경
                ),
                child: const Text('Create'),
                onPressed: () {
                  if (numOfPlayer != null && numOfPlayer! >= 2 && numOfPlayer! <= 4) {
                    isValid = true;
                    Navigator.of(context).pop();
                  } else {
                    // 사용자에게 유효하지 않은 입력임을 알림
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a number between 2 and 4', style: TextStyle(color: Colors.white)),
                          backgroundColor: Colors.grey[850], // 스낵바 배경색 변경
                        )
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return {'roomName': roomName, 'numOfPlayer': numOfPlayer ?? 4}; // 유효하지 않은 경우 기본값으로 설정
  }


  void joinRoom(String roomCode, int maxPlayers) {
    // 방에 참여할 수 있는 경우의 로직
    socket.emit('joinRoom', {'roomCode': roomCode, 'userID': widget.userId, 'userName': widget.userName});

    // GameRoomPage로 이동
    Room selectedRoom = rooms.firstWhere((room) => room.roomCode == roomCode, orElse: () => Room.empty());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameRoomPage(
          room: selectedRoom,
          socket: socket,
          userId: widget.userId,
          userName: widget.userName,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    List<Room> sortedRooms = List.from(rooms)..sort((a, b) {
      // a가 꽉 찼고 b가 꽉 차지 않았다면, b가 먼저 오도록 함
      if (a.playerIDs.length == a.numOfPlayer && b.playerIDs.length != b.numOfPlayer) {
        return 1;
      }
      // b가 꽉 찼고 a가 꽉 차지 않았다면, a가 먼저 오도록 함
      else if (b.playerIDs.length == b.numOfPlayer && a.playerIDs.length != a.numOfPlayer) {
        return -1;
      }
      // 그 외의 경우는 순서를 변경하지 않음
      return 0;
    });
    return Scaffold(
      backgroundColor: Color(0xFF121212), // 배경색을 #121212로 설정
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurple[300]),
        backgroundColor: Color(0xFF121212), // AppBar 배경색도 설정
        title: Text('Find a Room', style: TextStyle(color: Colors.white)), // 텍스트 색상 변경
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white), // 아이콘 색상 변경
            onPressed: refreshRooms,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[300], // FloatingActionButton 배경색 변경
        child: Icon(Icons.add, color: Colors.black), // 아이콘 색상 변경
        onPressed: createRoom,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: ListView.builder(
          itemCount: sortedRooms.length,
          itemBuilder: (context, index) {
            final room = sortedRooms[index];
            return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Card(
                  color: Colors.white10,
                  margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // 왼쪽 정렬 (점과 방 이름)
                        Row(
                          mainAxisSize: MainAxisSize.min, // Row가 자식들의 크기에 맞춰져야 함
                          children: <Widget>[
                            Icon(
                              Icons.circle,
                              color: room.playerIDs.length == room.numOfPlayer ? Colors.red : Colors.green,
                              size: 10.0,
                            ),
                            SizedBox(width: 15), // 아이콘과 텍스트 사이 간격
                            Text('${room.roomName}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        Spacer(), // 이 Spacer가 중요함
                        // 오른쪽 정렬 (괄호 부분)
                        Text('(${room.playerIDs.length}/${room.numOfPlayer})', style: TextStyle(color: Colors.white, fontSize: 14)),
                      ],
                    ),
                    onTap: () {
                      _showJoinRoomDialog(context, room);
                  },
                ),
              )

            );
          },
        ),
      ),
    );
  }

  Future<void> _showJoinRoomDialog(BuildContext context, Room room) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[850], // 배경색 변경
          title: Text(
            'Join Room',
            style: TextStyle(color: Colors.grey[300]), // 타이틀 텍스트 색상 변경
          ),
          content: Text(
            'Do you want to join "${room.roomName}"?',
            style: TextStyle(color: Colors.grey[300]), // 내용 텍스트 색상 변경
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black, // 버튼 텍스트 색상 변경
                backgroundColor: Colors.deepPurple[300], // 버튼 배경색 변경
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black, // 버튼 텍스트 색상 변경
                backgroundColor: Colors.deepPurple[300], // 버튼 배경색 변경
              ),
              child: Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                joinRoom(room.roomCode, room.numOfPlayer);
              },
            ),
          ],
        );
      },
    );
  }

}
