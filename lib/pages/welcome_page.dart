import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:layout/layout.dart';
import 'package:repaint/pages/create_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: <Color>[
        Color(0xff29f19c),
        Color(0xff02a1f9),
      ],
    );
    return Scaffold(
      backgroundColor: Color(
        0xff151520,
      ),
      body: Margin(
        margin: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Welcome to ',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
                child: Text(
                  'Repaint',
                  style: GoogleFonts.raleway(
                    fontSize: 100,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 280,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push<Null>(
                      MaterialPageRoute(
                        builder: (context) => CreatePage.create(context),
                      ),
                    );
                  },
                  child: Text('Get started'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff202030),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
