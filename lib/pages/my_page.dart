import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals.dart';
import 'dart:io';

class MyPage extends StatefulWidget {
  final String userId;

  const MyPage({super.key, required this.userId});

  @override
  MyPageStaet createState() => MyPageStaet();
}

class MyPageStaet extends State<MyPage> {
  final ImagePicker _picker = ImagePicker();

  int statusCode = 0;
  String username = "";
  String? profilePictureUrl = "http://143.248.219.140:3000/images/loading.png";

  Future<void> getUserData(Map udata) async {
    try {
      print(udata);
      final response = await http.post(
        Uri.parse('$serverUrl/mypage'),
        body: jsonEncode(udata),
        headers: {"Content-Type": "application/json"},
      );

      statusCode = response.statusCode;
      print(statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        username = data['username'];
        profilePictureUrl = data['profilePictureUrl']; // 프로필 사진 URL 추가
        print("username: $username");
        print("profilePictureUrl: $profilePictureUrl");
      } else {
        username = "유저정보를 가져오지 못했습니다.";
        profilePictureUrl = null; // 오류 시 null로 설정
      }
    } catch (e) {
      // 예외 처리
      print("Error: $e");
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      // Step 1: Picking the image
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Step 2: Uploading the image
        var request =
            http.MultipartRequest('POST', Uri.parse('$serverUrl/profile'));

        request.fields['uid'] = widget.userId;

        request.files
            .add(await http.MultipartFile.fromPath('image', pickedFile.path));

        var response = await request.send();

        if (response.statusCode == 200) {
          // Step 3: Receiving the URL
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          var data = json.decode(responseString);
          var imageUrl = data['imageUrl'];

          // Step 4: Updating the state
          setState(() {
            profilePictureUrl = imageUrl; // Update the profile picture URL
          });
        } else {
          print("Failed to upload image");
        }
      }
    } catch (e) {
      print("Error picking and uploading image: $e");
    }
  }

  Future<void> showLogoutDialog() async {
    // showDialog 함수를 사용하여 대화상자를 표시합니다.
    bool confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'),
          content: Text('정말 로그아웃하시겠습니까?'),
          actions: <Widget>[
            // '취소' 버튼
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(false); // 대화상자를 닫고 false 반환
              },
            ),
            // '확인' 버튼
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(true); // 대화상자를 닫고 true 반환
              },
            ),
          ],
        );
      },
    ) ?? false; // showDialog가 null을 반환할 경우를 대비하여 false를 기본값으로 설정

    // 사용자가 '확인'을 선택한 경우 로그아웃을 진행합니다.
    if (confirmLogout) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId'); // 'userId' 키에 대한 값을 삭제
      Navigator.of(context).pushReplacementNamed('/start'); // 로그인 페이지로 이동
    }
  }



  @override
  void initState() {
    super.initState();
    print('UserId: ${widget.userId}');
    var data = {"uid": widget.userId};

    getUserData(data).then((_) {
      setState(() {
        // 여기에서 profilePictureUrl과 username 상태를 업데이트
        profilePictureUrl; // 서버로부터 받은 URL
        username; // 서버로부터 받은 사용자 이름
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff121212),
        title: Text(
          "MY PAGE",
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),
      body: Column(
        children: [
          Card(
            elevation: 5.0,
            color: Colors.white10,
            margin: EdgeInsets.all(20.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center, // 내용을 중앙 정렬
                children: <Widget>[
                  CircleAvatar(
                    radius: 50, // 이미지를 원형으로 만들고 반지름을 50으로 설정
                    backgroundImage: NetworkImage(
                      profilePictureUrl!, // 네트워크 이미지 URL
                    ),
                    child: InkWell(
                      onTap: pickAndUploadImage,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset(
                          "assets/images/icon_edit.png",
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8), // 이름과 UID 사이에 여백 추가
                  Text(
                    username, // 사용자 이름을 여기에 입력
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12), // UID 박스 위에 여백 추가
                  Row(
                    children: [
                      Expanded(
                        // 가로 길이를 Expanded로 설정하여 나머지 공간을 채우도록 함
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 4,
                            bottom: 4,
                            right: 5,
                            left: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff121212), // 회색 배경
                            borderRadius: BorderRadius.circular(50), // 모서리 둥글게
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // 공간 분할
                            children: [
                              SelectableText(
                                "${widget.userId}", // 여기에 실제 UID 값을 넣습니다.
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                    fontSize: 15),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.copy,
                                  size: 20,
                                  color: Colors.white70,
                                ),
                                onPressed: () {
                                  // 클립보드에 UID 복사하는 기능 구현
                                  final data =
                                      ClipboardData(text: "${widget.userId}");
                                  Clipboard.setData(data);
                                  final snackBar = SnackBar(
                                      content: Text('UID copied to clipboard'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            color: Colors.white10,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: InkWell(
              onTap: (){
                Navigator.pushNamed(context, '/friends');
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center, // 내용을 중앙 정렬
                  children: [
                    Row(
                      children: [
                        Expanded(
                          // 가로 길이를 Expanded로 설정하여 나머지 공간을 채우도록 함
                          child: Container(
                              padding: EdgeInsets.only(
                                top: 4,
                                bottom: 4,
                                right: 5,
                                left: 10,
                              ),

                              child:Text("친구창", style: TextStyle(color: Colors.white, fontSize: 16), )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Card(
            elevation: 5.0,
            color: Colors.white10,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                final userId = prefs.getString('userId');
                print("$userId입니다");
                showLogoutDialog;
              },
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center, // 내용을 중앙 정렬
                  children: [
                    Row(
                      children: [
                        Expanded(
                          // 가로 길이를 Expanded로 설정하여 나머지 공간을 채우도록 함
                          child: Container(
                            padding: EdgeInsets.only(
                              top: 4,
                              bottom: 4,
                              right: 5,
                              left: 10,
                            ),
              
                            child:Text("로그아웃", style: TextStyle(color: Colors.red, fontSize: 16), )
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
