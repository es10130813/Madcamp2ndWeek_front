import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  late int myPlayerId;
  late String mySocketID;
  bool gameStarted= false;
  late String nowRoomCode="";

  late String myPlayerName;
  late int numOfPlayer;

  SocketService(bool createJoin, String roomCode, String playerName, int numOfPlayer) {

    socket = IO.io('https://143.248.196.37:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket.connect();

    socket.on('connect_error', (error) => print('Connect error: $error'));
  }

  // 게임시작 요청
  void gameStart(){
    socket.emit('gameStart', {'roomCode': nowRoomCode});
  }


  // 방 생성 요청
  void createRoom(String hostName, int numOfPlayer) {
    socket.emit('createRoom', {'hostName': hostName, 'numOfPlayer': numOfPlayer});
    socket.on('roomCreated', (data) {
      print('Room created with code: ${data['roomCode']}');
      print('Your player ID: ${data['playerId']}');
      myPlayerId = data['playerId'];
      nowRoomCode = data['roomCode'];
      mySocketID = data['socketID'];
    });
  }

  // 방에 참여 요청
  void joinRoom(String roomCode, String userName) {
    socket.emit('joinRoom', {'roomCode': roomCode, 'userName': userName});
    socket.on('roomJoined', (data) {
      print('Joined room with code: ${data['roomCode']}');
      print('Your player ID: ${data['playerId']}');
      myPlayerId = data['playerId'];
      nowRoomCode = data['roomCode'];
      mySocketID = data['socketID'];
    });
  }

  // 게임 시작 이벤트 수신
  void onGameStarted(Function callback) {
    socket.on('gameStarted', (data) => callback(data));
  }
  // 방생성 이벤트 수신
  void onRoomCreated(Function callback) {
    socket.on('roomCreated', (data) => callback(data));
  }
  // 방참여 이벤트 수신
  void onRoomJoined(Function callback) {
    socket.on('roomJoined', (data) => callback(data));
  }
}