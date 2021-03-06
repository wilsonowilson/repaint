import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  const NumberField({
    Key? key,
    required this.onValue,
    required this.text,
  }) : super(key: key);

  final ValueChanged<double> onValue;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.blueGrey.shade800,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Text(
                text,
                style:
                    TextStyle(color: Colors.white, fontSize: 18, fontFeatures: [
                  FontFeature.tabularFigures(),
                  FontFeature.liningFigures(),
                ]),
                textAlign: TextAlign.center,
              ),
            ),
            NumberIncrementer(
              onIncrement: (e) {
                onValue(e.toDouble());
              },
              onDecrement: (e) {
                onValue(-e.toDouble());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NumberIncrementer extends StatefulWidget {
  const NumberIncrementer({
    Key? key,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);
  final ValueChanged<int> onIncrement;
  final ValueChanged<int> onDecrement;

  @override
  _NumberIncrementerState createState() => _NumberIncrementerState();
}

class _NumberIncrementerState extends State<NumberIncrementer> {
  Timer? timer;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onIncrement(1);
            },
            onTapDown: (TapDownDetails details) {
              timer = Timer.periodic(Duration(milliseconds: 20), (t) {
                widget.onIncrement(1);
              });
            },
            onTapUp: (TapUpDetails details) {
              timer?.cancel();
            },
            onTapCancel: () {
              timer?.cancel();
            },
            child: Container(
              color: Colors.white,
              child: Icon(
                Icons.arrow_drop_up,
                color: Colors.black,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onIncrement(-1);
            },
            onTapDown: (TapDownDetails details) {
              timer = Timer.periodic(Duration(milliseconds: 50), (t) {
                widget.onDecrement(1);
              });
            },
            onTapUp: (TapUpDetails details) {
              timer?.cancel();
            },
            onTapCancel: () {
              timer?.cancel();
            },
            child: Container(
              color: Colors.white,
              child: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
