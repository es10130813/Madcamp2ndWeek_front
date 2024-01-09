import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../globals.dart';

class FindRoomPage extends StatefulWidget {
  final String userId;
  const FindRoomPage({super.key, required this.userId});

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

  void fetchRooms() {
    socket.emit('fetchRooms');
  }

  void refreshRooms() {
    fetchRooms();
  }

  void createRoom() async {
    String roomName = await _showCreateRoomDialog(context);
    if (roomName.isNotEmpty) {
      socket.emit('createRoom', {'hostName': widget.userId, 'roomName': roomName});
    }
  }
  Future<String> _showCreateRoomDialog(BuildContext context) async {
    String roomName = '';
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Room'),
          content: TextField(
            onChanged: (value) {
              roomName = value;
            },
            decoration: const InputDecoration(hintText: "Enter room name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Create'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return roomName;
  }

  void joinRoom(String roomCode) {
    socket.emit('joinRoom', {'roomCode': roomCode, 'userName': widget.userId});
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
        onPressed: createRoom,
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final room = rooms[index];
          return ListTile(
            title: Text('${room.roomName} (${room.players.length}/4)'),
            onTap: (){
              joinRoom(room.roomCode);
            }, // 아무런 동작을 하지 않음
          );
        },
      ),
    );
  }
}

class Room {
  final String roomName;
  final String roomCode;
  final String host;
  final List<String> players;
  final List<String> playerNames;
  final int numOfPlayer;

  Room({
    required this.roomName,
    required this.roomCode,
    required this.host,
    required this.players,
    required this.playerNames,
    required this.numOfPlayer,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomName: json['roomName']?.toString() ?? 'Unknown',
      roomCode: json['roomCode']?.toString() ?? 'Unknown',
      host: json['host'] ?? 'Unknown',
      players: List<String>.from(json['players'] ?? []),
      playerNames: List<String>.from(json['playerName'] ?? []),
      numOfPlayer: json['numOfPlayer'] ?? 0,
    );
  }
}
