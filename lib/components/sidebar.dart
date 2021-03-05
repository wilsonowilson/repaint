import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/models/layer/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: 300,
      color: Color(0xff1b1b1b),
      child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            final layer = TextLayer(
              offset: Offset(0, 0),
              style: GoogleFonts.lobster(
                fontSize: 75,
                color: Colors.white,
              ),
              text: 'Hello, world',
            );
            return Draggable<TextLayer>(
              data: layer,
              feedback: Center(
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    'Hello, world',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              child: ListTile(
                onTap: () => context.read<CanvasCubit>().addLayer(layer),
                title: Text(
                  'Hello, world',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
