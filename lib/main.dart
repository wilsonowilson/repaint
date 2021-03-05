import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layout/layout.dart';
import 'package:repaint/pages/welcome_page.dart';

void main() {
  runApp(Repaint());
}

class Repaint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp(
        title: 'Repaint',
        theme: ThemeData(
          primaryColor: Color(0xff29f19c),
          accentColor: Color(0xff29f19c),
          textTheme: GoogleFonts.ralewayTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: WelcomePage(),
      ),
    );
  }
}
