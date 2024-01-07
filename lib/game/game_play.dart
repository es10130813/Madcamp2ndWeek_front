import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GamePlay extends StatefulWidget {
  @override
  _GamePlayState createState() => _GamePlayState();
}

class _GamePlayState extends State<GamePlay> {
  double cardLeft = 0.0;
  List<String> cards = [
    '7D',
    '7H',
    '7S',
    '8C',
    '9C',
    'JKB',
    'JKR',
    '2S',
    '3C',
    '3D',
    'QS'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 100,
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
                            80 + shift_num * (cards.length - 1);
                        double stack_padding = (width - deck_length) / 2;
                        if (stack_padding < 0) {
                          stack_padding = 0;
                          shift_num = (width - 80) / (cards.length - 1);
                        }
                        return Container(
                          color: Colors.cyan[300],
                          child: Padding(
                            padding:
                            EdgeInsets.only(
                              top: 0.0,    // 위쪽 패딩 설정
                              bottom: 25.0, // 아래쪽 패딩 설정
                              left: stack_padding,    // 왼쪽 패딩 설정
                              right: stack_padding,  // 오른쪽 패딩 설정
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: List.generate(cards.length, (index) {
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
            Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                        child : Column(
                          children: [
                            Expanded(
                                child: Container(color: Colors.teal[100],)),
                            Expanded(
                              flex: 8,
                              child: LayoutBuilder(
                                builder:
                                    (BuildContext context, BoxConstraints constraints) {
                                  double height = constraints.maxHeight;
                                  double shift_num = 20.0;
                                  double deck_length =
                                      80 + shift_num * (cards.length - 1);
                                  double stack_padding = (height - deck_length) / 2;
                                  if (stack_padding < 0) {
                                    stack_padding = 0;
                                    shift_num = (height - 80) / (cards.length - 1);
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
                                        children: List.generate(cards.length, (index) {
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
                            Expanded(
                                child: Container(color: Colors.teal[100],)),
                            Expanded(
                                flex: 3,
                                child: Container(color: Colors.orange[200],)),
                            Expanded(
                                flex: 3,
                                child: Container(color: Colors.orange[100],)),
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
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: List.generate(52, (index) {
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
                                    color: Colors.pink[200],
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: List.generate(1, (index) {
                                          final double shift = index * 0.8;
                                          return Positioned(
                                              bottom: shift,
                                              child: CardWidget(
                                                  cardName: "QH",
                                                  ));
                                        }),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )),
                    Expanded(
                        child : Column(
                          children: [
                            Expanded(
                                child: Container(color: Colors.teal[100],)),
                            Expanded(
                              flex: 8,
                              child: LayoutBuilder(
                                builder:
                                    (BuildContext context, BoxConstraints constraints) {
                                  double height = constraints.maxHeight;
                                  double shift_num = 20.0;
                                  double deck_length =
                                      80 + shift_num * (cards.length - 1);
                                  double stack_padding = (height - deck_length) / 2;
                                  if (stack_padding < 0) {
                                    stack_padding = 0;
                                    shift_num = (height - 80) / (cards.length - 1);
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
                                        children: List.generate(cards.length, (index) {
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
                            Expanded(
                                child: Container(color: Colors.teal[100],)),
                            Expanded(
                                flex: 3,
                                child: Container(color: Colors.orange[200],)),
                            Expanded(
                                flex: 3,
                                child: Container(
                                  child: Visibility(
                                    visible: true,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(onPressed: () {  }, child: Text("턴 종료"),
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
                        flex: 4,
                        child: LayoutBuilder(
                          builder:
                              (BuildContext context, BoxConstraints constraints) {
                            double width = constraints.maxWidth;
                            double shift_num = 20.0;
                            double deck_length =
                                80 + shift_num * (cards.length - 1);
                            double stack_padding = (width - deck_length) / 2;
                            if (stack_padding < 0) {
                              stack_padding = 0;
                              shift_num = (width - 80) / (cards.length - 1);
                            }
                            return Container(
                              color: Colors.cyan[300],
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal: stack_padding),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: List.generate(cards.length, (index) {
                                    final double shift = index * shift_num;
                                    return Positioned(
                                        left: shift,
                                        child: DraggableCard(
                                            cardName: cards[index],
                                            onDragged: () {
                                              setState(() {
                                                cards.removeAt(index);
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

class DraggableCard extends StatelessWidget {
  final String cardName;
  final VoidCallback onDragged;

  const DraggableCard({Key? key, required this.cardName, required this.onDragged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String asset = 'assets/images/$cardName.png';

    return Draggable(
      data: cardName,
      childWhenDragging: Container(),
      feedback: Card(
        child: Container(
          width: 80,
          height: 112,
          child: Image.asset(
            asset,
          ),
        ),
      ),
      onDragEnd: (details) {
        if (details.wasAccepted) {
          onDragged();
        }
      },
      child: Container(
        width: 80,
        height: 112,
        child: Image.asset(
          asset,
        ),
      ),
    );
  }
}


class CardTurend extends StatelessWidget {
  final String cardName;

  const CardTurend({Key? key, required this.cardName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String asset = 'assets/images/$cardName.png';

    return Container(
      width: 112,
      height: 80,
      child: Image.asset(
        asset,
      ),
    );
  }
}
class CardWidget extends StatelessWidget {
  final String cardName;

  const CardWidget({Key? key, required this.cardName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String asset = 'assets/images/$cardName.png';

    return Container(
      width: 80,
      height: 112,
      child: Image.asset(
        asset,
      ),
    );
  }
}
