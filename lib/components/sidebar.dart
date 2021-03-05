import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/models/layer/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final layer = TextLayer(
      offset: Offset(0, 0),
      style: GoogleFonts.raleway(
        fontSize: 32,
        color: Colors.black,
      ),
      text: 'Text',
    );
    return Container(
      height: double.maxFinite,
      width: 300,
      color: Color(0xff1b1b1b),
      child: ListView(
        children: [
          Draggable<TextLayer>(
            data: layer,
            feedback: Center(
              child: Material(
                color: Colors.transparent,
                child: Text(
                  'Text',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            child: ListTile(
              onTap: () => context.read<CanvasCubit>().addLayer(layer),
              title: Text(
                'Text',
                style: GoogleFonts.raleway(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
