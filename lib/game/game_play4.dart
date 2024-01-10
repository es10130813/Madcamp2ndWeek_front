import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import 'cards.dart';

class GamePlay4 extends StatefulWidget {
  final List<String> playerNames;
  final List<String> playerIDs;
  final String userId;

  GamePlay4({Key? key,required this.playerNames, required this.playerIDs, required this.userId })
      : super(key: key);

  @override
  _GamePlay4State createState() => _GamePlay4State();
}
List<String> playerNames =[];
List<String> playerIDs =[];
String userId = "";

class _GamePlay4State extends State<GamePlay4> with SingleTickerProviderStateMixin{
  int statusCode = 0;
  String? profilePictureUrl1 = "";
  String? profilePictureUrl2 = "";
  String? profilePictureUrl3 = "";


  Future<void> getUserData1(Map udata) async {
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
        profilePictureUrl1 = data['profilePictureUrl']; // 프로필 사진 URL 추가
        print("profilePictureUrl: $profilePictureUrl1");
      } else {
        profilePictureUrl1 = null; // 오류 시 null로 설정
      }
    } catch (e) {
      // 예외 처리
      print("Error: $e");
    }
  }
  Future<void> getUserData2(Map udata) async {
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
        profilePictureUrl2 = data['profilePictureUrl']; // 프로필 사진 URL 추가
        print("profilePictureUrl: $profilePictureUrl2");
      } else {
        profilePictureUrl2= null; // 오류 시 null로 설정
      }
    } catch (e) {
      // 예외 처리
      print("Error: $e");
    }
  }
  Future<void> getUserData3(Map udata) async {
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
        profilePictureUrl3 = data['profilePictureUrl']; // 프로필 사진 URL 추가
        print("profilePictureUrl: $profilePictureUrl3");
      } else {
        profilePictureUrl3= null; // 오류 시 null로 설정
      }
    } catch (e) {
      // 예외 처리
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    playerNames = widget.playerNames;
    playerIDs = widget.playerIDs;
    userId = widget.userId;
    int i = playerIDs.indexOf(userId);
    reorderList(playerIDs, i);
    reorderList(playerNames, i);

    getUserData1({"uid":playerIDs[1]}).then((_) {
      setState(() {
        profilePictureUrl1; // 서버로부터 받은 URL
      });
    });
    getUserData2({"uid":playerIDs[2]}).then((_) {
      setState(() {
        profilePictureUrl2; // 서버로부터 받은 URL
      });
    });getUserData1({"uid":playerIDs[3]}).then((_) {
      setState(() {
        profilePictureUrl1; // 서버로부터 받은 URL
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
  }

  //double cardLeft = 7;
  List<String> attacks = ["attack","attack","attack"];

  List<String> myHand_last = ["4H", "AS", "9S", "XR","XB", "8D", "6H", "TC", "JS", "KS", "6S", "AC", "KH" ];

  List<String> num = ["turn"];

  List<String> myHand =  ["4H", "AS", "9S", "XR","XB", "8D", "6H", "TC", "JS", "KS", "6S", "AC", "KH" ];
  List<String> firstHand = ["8H", "7S", "JD", "8C", "AD", "3D", "KD"];
  List<String> secondHand =  ["2D", "3C", "9D", "QH", "3S", "3H", "JC"];
  List<String> thirdHand =  ["2S", "5H", "5C", "5D", "9C", "TD"];
  List<String> deck = ["2C", "8S", "5S", "6D", "QS", "TH", "6C", "9H", "KC", "7C", "7H", "JH", "4D", "QC", "TS", "4C", "2H", "QD", "AH", "7D"];
  List<String> pile = ["4S"];

  late OverlayEntry _overlayEntry;
  late AnimationController _controller;

  bool areListsEqual(List list1, List list2) {
    if (list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }
  void reorderList<T>(List<T> list, int i) {
    int targetIndex = i;

    T target = list[i];

    if (targetIndex == -1) {
      // target이 리스트에 없는 경우, 함수를 종료
      return;
    }

    // target 이후의 원소들을 추출하고 리스트에서 제거
    List<T> afterTarget = list.sublist(targetIndex + 1);
    list.removeRange(targetIndex, list.length);

    // 추출한 원소들을 리스트의 시작 부분에 추가
    list.insertAll(0, afterTarget);

    // 마지막으로 target을 리스트의 시작 부분에 추가
    list.insert(0, target);
  }

  void _showOverlay(BuildContext context, String deckTop) {
    Size screenSize = MediaQuery.of(context).size;

    // 화면의 중앙을 계산
    double centerX = screenSize.width / 2 - 40; // 카드 너비의 절반을 뺀 값
    double centerY = screenSize.height / 2 - 112; // 카드 높이의 절반을 뺀 값

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: centerX, // 화면 중앙의 X 좌표
        top: centerY, // 화면 중앙의 Y 좌표
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _controller.value * 320), // 애니메이션 종료 위치 조정
              child: CardWidget(cardName: deckTop),
            );
          },
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _overlayEntry.remove(); // 애니메이션이 완료되면 오버레이 제거
        _controller.reset(); // 애니메이션 컨트롤러 재설정
      }
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 75,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                      )),
                  Expanded(
                    flex: 4,
                    child: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        double width = constraints.maxWidth;
                        double shift_num = 20.0;
                        double deck_length =
                            80 + shift_num * (firstHand.length - 1);
                        double stack_padding = (width - deck_length) / 2;
                        if (stack_padding < 0) {
                          stack_padding = 0;
                          shift_num = (width - 80) / (firstHand.length - 1);
                        }
                        return Container(
                          child: Padding(
                            padding:
                            EdgeInsets.only(
                              top: 0.0,    // 위쪽 패딩 설정
                              bottom: 10.0, // 아래쪽 패딩 설정
                              left: stack_padding,    // 왼쪽 패딩 설정
                              right: stack_padding,  // 오른쪽 패딩 설정
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: List.generate(firstHand.length, (index) {
                                final double shift = index * shift_num;
                                return Positioned(
                                    left: shift,
                                    child: CardWidget(
                                      cardName: "card_back",
                                    ));
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                      child: Container(
                      )),
                ],
              ),
            ),
            Container(
              height: 60,
              child: Column(
                children: [
                  Container(
                      width: 800,
                      height: 40,
                      child: CircleAvatar(
                        radius: 17.5, // 원의 반지름 설정
                        child: ClipOval( // 원형 클리핑을 위한 ClipOval
                          child: Image.network(
                            profilePictureUrl3!, // 네트워크 이미지 URL
                            fit: BoxFit.cover, // 이미지가 영역을 채우도록 조절
                            width: 40, // 원의 지름에 맞는 이미지 너비 설정
                            height: 40, // 원의 지름에 맞는 이미지 높이 설정
                          ),
                        ),
                      )),
                  Container(child: Text("${playerNames[3]}", style: TextStyle(color: Colors.white),),),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        child : Column(
                          children: [
                            Container(height: 10),
                            Expanded(
                              flex: 8,
                              child: LayoutBuilder(
                                builder:
                                    (BuildContext context, BoxConstraints constraints) {
                                  double height = constraints.maxHeight;
                                  double shift_num = 20.0;
                                  double deck_length =
                                      80 + shift_num * (secondHand.length - 1);
                                  double stack_padding = (height - deck_length) / 2;
                                  if (stack_padding < 0) {
                                    stack_padding = 0;
                                    shift_num = (height - 80) / (secondHand.length - 1);
                                  }
                                  return Container(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(
                                        top: stack_padding,    // 위쪽 패딩 설정
                                        bottom: stack_padding, // 아래쪽 패딩 설정
                                        left: 0.0,    // 왼쪽 패딩 설정
                                        right: 50.0,  // 오른쪽 패딩 설정
                                      ),
                                      child: Stack(
                                        alignment: Alignment.centerRight,
                                        children: List.generate(secondHand.length, (index) {
                                          final double shift = index * shift_num;
                                          return Positioned(
                                              top: shift,
                                              child: CardTurend(
                                                cardName: "card_back_turned",
                                              ));
                                        }),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(height: 10,),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 800,
                                          height: 40,
                                          child: CircleAvatar(
                                            radius: 17.5, // 원의 반지름 설정
                                            child: ClipOval( // 원형 클리핑을 위한 ClipOval
                                              child: Image.network(
                                                profilePictureUrl2!, // 네트워크 이미지 URL
                                                fit: BoxFit.cover, // 이미지가 영역을 채우도록 조절
                                                width: 40, // 원의 지름에 맞는 이미지 너비 설정
                                                height: 40, // 원의 지름에 맞는 이미지 높이 설정
                                              ),
                                            ),
                                          )),
                                      Container(child: Text("${playerNames[2]}", style: TextStyle(color: Colors.white),),),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 35,
                                        height: 35,
                                        child: Image.asset("assets/images/icon_sword.png"),
                                      ),
                                      Text(attacks.length.toString()),
                                    ],
                                  ),

                                )),
                          ],
                        )),
                    Expanded(
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 0),
                                      child: Stack( //Deck
                                        alignment: Alignment.center,
                                        children: List.generate(deck.length, (index) {
                                          final double shift = index * 0.8;
                                          return Positioned(
                                              bottom: shift,
                                              child: CardWidget(
                                                cardName: "card_back",
                                              ));
                                        }),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: BuildDragTarget(pile: pile, num: num, attacks: attacks,),
                                    ),
                                  )),
                            ],
                          ),
                        )),
                    Expanded(
                        child : Column(
                          children: [
                            Container(height: 10,),
                            Expanded(
                              flex: 8,
                              child: LayoutBuilder(
                                builder:
                                    (BuildContext context, BoxConstraints constraints) {
                                  double height = constraints.maxHeight;
                                  double shift_num = 20.0;
                                  double deck_length =
                                      80 + shift_num * (thirdHand.length - 1);
                                  double stack_padding = (height - deck_length) / 2;
                                  if (stack_padding < 0) {
                                    stack_padding = 0;
                                    shift_num = (height - 80) / (thirdHand.length - 1);
                                  }
                                  return Container(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(
                                        top: stack_padding,    // 위쪽 패딩 설정
                                        bottom: stack_padding, // 아래쪽 패딩 설정
                                        left: 50.0,    // 왼쪽 패딩 설정
                                        right: 0.0,  // 오른쪽 패딩 설정
                                      ),
                                      child: Stack(
                                        children: List.generate(thirdHand.length, (index) {
                                          final double shift = index * shift_num;
                                          return Positioned(
                                              top: shift,
                                              child: CardTurend(
                                                cardName: "card_back_turned",
                                              ));
                                        }),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(height: 10,),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: Column(
                                    children: [
                                      Container(
                                          width: 800,
                                          height: 40,
                                          child: CircleAvatar(
                                            radius: 17.5, // 원의 반지름 설정
                                            child: ClipOval( // 원형 클리핑을 위한 ClipOval
                                              child: Image.network(
                                                profilePictureUrl1!, // 네트워크 이미지 URL
                                                fit: BoxFit.cover, // 이미지가 영역을 채우도록 조절
                                                width: 40, // 원의 지름에 맞는 이미지 너비 설정
                                                height: 40, // 원의 지름에 맞는 이미지 높이 설정
                                              ),
                                            ),
                                          )),
                                      Container(child: Text("${playerNames[1]}", style: TextStyle(color: Colors.white),),),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: Visibility(
                                    visible: true,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(onPressed: () async {
                                        print(pile);
                                        print(num);
                                        if (areListsEqual(myHand_last,myHand)){
                                          int i = attacks.length+1;
                                          while(i!=0){
                                            String deckTop = deck.last;
                                            _showOverlay(context, deckTop);
                                            deck.removeLast();
                                            myHand.add(deckTop);
                                            if (i!=attacks.length+1&&attacks.length!=0) attacks.removeLast();
                                            setState(() {});
                                            i--;
                                            await Future.delayed(Duration(milliseconds: 300));
                                          }
                                        }
                                        setState(() {});
                                      },
                                        child: Text("턴 종료"),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )),
                  ],
                )),
            Expanded(
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                          )),
                      Expanded(
                        flex: 14,
                        child: LayoutBuilder(
                          builder:
                              (BuildContext context, BoxConstraints constraints) {
                            double width = constraints.maxWidth;
                            double shift_num = 20.0;
                            double deck_length =
                                80 + shift_num * (myHand.length - 1);
                            double stack_padding = (width - deck_length) / 2;
                            if (stack_padding < 0) {
                              stack_padding = 0;
                              shift_num = (width - 80) / (myHand.length - 1);
                            }
                            return Container(
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: stack_padding),
                                child: Stack( //myHand
                                  alignment: Alignment.center,
                                  children: List.generate(myHand.length, (index) {
                                    final double shift = index * shift_num;
                                    return Positioned(
                                        left: shift,
                                        child: DraggableCard(
                                            cardName: myHand[index],
                                            onDragged: () {
                                              setState(() {
                                                myHand.removeAt(index);
                                              });
                                            }));
                                  }),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                          child: Container(
                          )),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
