import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DraggableCard extends StatelessWidget {
  final String cardName;
  final VoidCallback onDragged;

  const DraggableCard({Key? key, required this.cardName, required this.onDragged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String asset = 'assets/images/$cardName.png';

    return Draggable<String>(
      data: cardName,
      child: Container(
        width: 80,
        height: 112,
        child: Image.asset(
          asset,
        ),
      ),
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

class BuildDragTarget extends StatefulWidget {
  final List pile;
  List num;

  BuildDragTarget({Key? key, required this.pile, required this.num}) : super(key: key);

  @override
  _BuildDragTargetState createState() => _BuildDragTargetState();
}

class _BuildDragTargetState extends State<BuildDragTarget> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAccept: (data) {
        if (widget.num.length == 1) {
          return (widget.pile.last[0] == data?[0] || widget.pile.last[1] == data?[1]);
        }
        else if (widget.num.length == 0) {
          return widget.pile.last[0] == data?[0];
        }
        else {
          return false;
        }
      },
      onAccept: (data) {
        if (data?[0]=="K") widget.num.add("turn");
        widget.pile.add(data);
        if (widget.num.isNotEmpty) widget.num.removeLast();
        print(widget.pile);
        print(widget.num);
        print('Card $data dropped!');
      },
      builder: (BuildContext context, List<String?> candidateData, List<dynamic> rejectedData) {
        return  Stack( //Pile
          alignment: Alignment.center,
          children: List.generate(widget.pile.length, (index) {
            final double shift = index * 0.8;
            return Positioned(
                bottom: shift,
                child: CardWidget(
                  cardName: widget.pile.last,
                ));
          }),
        );
      },
    );
  }
}


