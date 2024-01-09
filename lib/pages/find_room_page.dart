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
            title: const Text('Create a Room'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    roomName = value;
                  },
                  decoration: const InputDecoration(hintText: "Enter room name"),
                ),
                TextField(
                  onChanged: (value) {
                    numOfPlayer = int.tryParse(value);
                  },
                  decoration: const InputDecoration(hintText: "Enter max players (2~4)"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  isValid = true; // 취소 시에는 검증을 중단
                },
              ),
              TextButton(
                child: const Text('Create'),
                onPressed: () {
                  if (numOfPlayer != null && numOfPlayer! >= 2 && numOfPlayer! <= 4) {
                    isValid = true;
                    Navigator.of(context).pop();
                  } else {
                    // 사용자에게 유효하지 않은 입력임을 알림
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please enter a number between 2 and 4'))
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Find a Room'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshRooms,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:
          createRoom,
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return ListTile(
            title: Text('${room.roomName} (${room.playerIDs.length}/${room.numOfPlayer})'),
            onTap: () {
              String currentRoomCode = room.roomCode;
              fetchRooms(onCompleted: () {
                final newRoom = rooms.firstWhere(
                      (r) => r.roomCode == currentRoomCode,
                  orElse: () => Room.empty(),
                );

                // 방이 꽉 차지 않았을 경우에만 joinRoom 호출
                if (newRoom.playerIDs.length < newRoom.numOfPlayer) {
                  joinRoom(newRoom.roomCode, newRoom.numOfPlayer);
                } else {
                  // 방이 꽉 찼을 때 메시지 표시
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('The room is full!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              });
            },
          );
        },
      ),
    );
  }
}

