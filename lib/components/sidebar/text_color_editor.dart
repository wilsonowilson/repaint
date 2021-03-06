import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/popup.dart';
import 'package:repaint/models/layer/text.dart';

class TextColorEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    void changeColor(Color color) {
      final layer = selectedLayer!.data as TextLayer;
      final newLayer = layer.copyWith(
        style: layer.style?.copyWith(color: color),
      );
      context.read<CanvasCubit>().editLayer(
            selectedLayer.copyWith(
              data: newLayer,
            ),
          );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Color',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              showPopup<Null>(
                context: context,
                anchor: Anchor(
                  source: Alignment.bottomRight,
                  target: Alignment.topRight,
                  offset: Offset(120, 0),
                ),
                elevation: 0,
                popup: RepaintColorPicker(
                  pickerColor:
                      (selectedLayer?.data as TextLayer).style?.color ??
                          Colors.black,
                  onColorChanged: changeColor,
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: (selectedLayer?.data as TextLayer).style?.color ??
                    Colors.black,
                border: Border.all(
                  color: Colors.blueGrey.shade800,
                ),
              ),
              alignment: Alignment.center,
              height: 35,
              width: 140,
            ),
          ),
        ],
      ),
    );
  }
}

class RepaintColorPicker extends StatelessWidget {
  const RepaintColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          portraitOnly: true,
          onColorChanged: onColorChanged,
          pickerAreaBorderRadius: BorderRadius.circular(15),
          showLabel: true,
          pickerAreaHeightPercent: 0.8,
        ),
      ),
    );
  }
}
