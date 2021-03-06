import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
