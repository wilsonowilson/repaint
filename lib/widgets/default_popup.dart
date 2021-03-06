import 'package:flutter/material.dart';

class DefaultPopupContainer extends StatelessWidget {
  const DefaultPopupContainer({
    Key? key,
    this.width = 130,
    this.height = 150,
    required this.child,
  }) : super(key: key);
  final Widget child;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            color: Colors.black38,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
