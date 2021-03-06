import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/widgets/color_picker.dart';

class CanvasColorEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final canvas = state.canvas;
    void changeColor(Color color) {
      context.read<CanvasCubit>().editCanvas(canvas.copyWith(color: color));
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Canvas Color',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              // showPopup<Null>(
              //   context: context,
              //   anchor: Anchor(
              //     source: Alignment.bottomRight,
              //     target: Alignment.topRight,
              //     offset: Offset(120, 0),
              //   ),
              //   elevation: 0,
              //   popup: RepaintColorPicker(
              //     pickerColor: canvas.color,
              //     onColorChanged: changeColor,
              //   ),
              // );
            },
            child: RepaintColorPicker(
              pickerColor: canvas.color,
              onColorChanged: changeColor,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: canvas.color,
                  border: Border.all(
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                alignment: Alignment.center,
                height: 35,
                width: 110,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
