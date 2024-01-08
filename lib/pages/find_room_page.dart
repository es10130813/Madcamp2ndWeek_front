import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'socketService.dart';

class FindRoomPage extends StatelessWidget {
  late IO.Socket socket;

  FindRoomPage({super.key}) {
    // 서버에 연결
    print("연결");
    socket = IO.io('http://143.248.196.37:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    print("연결2");
    socket.connect();

    print("연결3");
    socket.on('connect', (_){
      print('connect: ${socket.id}');
    });

    print("연결4");
  }

  @override
  Widget build(BuildContext context) {
    List<String> roomList = ["방 1", "방 2", "방 3", "방 4"];

    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: Center(
        child: ListView.builder(
          itemCount: roomList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                roomList[index],
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // 방 탭시 서버에 'joinRoom' 이벤트 전송
                socket.emit('joinRoom', {'room': roomList[index]});
                print('${roomList[index]}에 참여 요청');
              },
            );
          },
        ),
      ),
    );
  }
}
