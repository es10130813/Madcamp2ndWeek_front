import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cards.dart';

class GamePlay extends StatefulWidget {
  final List<String> playerNames;
  final List<String> playerIDs;
  final String userId;
  final socket;

  GamePlay({Key? key, required this.userId, required this.playerNames, required this.playerIDs, required this.socket})
      : super(key: key);

  @override
  _GamePlayState createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> with SingleTickerProviderStateMixin{
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

  @override
  void initState() {
    super.initState();
    print(widget.playerNames);
    print(widget.playerIDs);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 220),
      vsync: this,
    );
  }

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
              color: Colors.deepPurple[500],
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                        color: Colors.cyan[200],
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
                          color: Colors.cyan[300],
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
                        color: Colors.cyan[200],
                      )),
                ],
              ),
            ),
            Container(
              height: 60,
              color: Colors.orange[300],
              child: Column(
                children: [
                  Container(
                    width: 800,
                    height: 40,
                    child: Image.asset("assets/images/profile_pic.png"),),
                  Container(child: Text("user1"),),
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
                            Container(height: 10,color: Colors.teal[100],),
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
                                    color: Colors.teal[300],
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
                            Container(height: 10,color: Colors.teal[100],),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.orange[300],
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 800,
                                        height: 40,
                                        child: Image.asset("assets/images/profile_pic.png"),),
                                      Container(child: Text("user2"),),
                                    ],
                                  ),
                                )),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.orange[100],
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
                                    color: Colors.pink[200],
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
                                    color: Colors.pink[100],
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
                            Container(height: 10,color: Colors.teal[100],),
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
                                    color: Colors.teal[300],
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
                            Container(height: 10,color: Colors.teal[100],),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  color: Colors.orange[300],
                                  child: Column(
                                    children: [
                                      Container(
                                        width: 800,
                                        height: 40,
                                        child: Image.asset("assets/images/profile_pic.png"),),
                                      Container(child: Text("user3"),),
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
                            color: Colors.cyan[200],
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
                              color: Colors.cyan[300],
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
                            color: Colors.cyan[200],
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
