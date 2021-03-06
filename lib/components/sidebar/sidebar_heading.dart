import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SidebarHeading extends StatelessWidget {
  const SidebarHeading({
    Key? key,
    required this.title,
    this.padding = 18.0,
  }) : super(key: key);
  final String title;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.white70,
          )
        ],
      ),
    );
  }
}
