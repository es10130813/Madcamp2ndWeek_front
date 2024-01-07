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
