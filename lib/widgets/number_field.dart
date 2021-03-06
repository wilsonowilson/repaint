import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

class NumberField extends StatelessWidget {
  const NumberField({
    Key? key,
    required this.onValue,
    required this.text,
    this.updateValue = 1.0,
  }) : super(key: key);

  final ValueChanged<double> onValue;
  final String text;
  final double updateValue;

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
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Text(
                text,
                style:
                    TextStyle(color: Colors.white, fontSize: 18, fontFeatures: [
                  FontFeature.tabularFigures(),
                  // FontFeature.liningFigures(),
                ]),
                textAlign: TextAlign.center,
              ),
            ),
            NumberIncrementer(
              updateValue: updateValue,
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
    required this.updateValue,
  }) : super(key: key);
  final ValueChanged<double> onIncrement;
  final ValueChanged<double> onDecrement;
  final double updateValue;

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
              widget.onIncrement(widget.updateValue);
            },
            onTapDown: (TapDownDetails details) {
              timer = Timer.periodic(Duration(milliseconds: 20), (t) {
                widget.onIncrement(widget.updateValue);
              });
            },
            onTapUp: (TapUpDetails details) {
              timer?.cancel();
            },
            onTapCancel: () {
              timer?.cancel();
            },
            child: Container(
              color: Colors.blueGrey.shade300,
              child: Icon(
                Icons.arrow_drop_up_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.onDecrement(widget.updateValue);
            },
            onTapDown: (TapDownDetails details) {
              timer = Timer.periodic(Duration(milliseconds: 50), (t) {
                widget.onDecrement(widget.updateValue);
              });
            },
            onTapUp: (TapUpDetails details) {
              timer?.cancel();
            },
            onTapCancel: () {
              timer?.cancel();
            },
            child: Container(
              color: Colors.blueGrey.shade400,
              child: Icon(
                Icons.arrow_drop_down_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
