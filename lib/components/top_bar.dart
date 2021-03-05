import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 60,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xff29f19c),
        Color(0xff02a1f9),
      ])),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      ),
    );
  }
}
