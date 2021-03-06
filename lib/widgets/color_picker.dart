import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class RepaintColorPicker extends StatelessWidget {
  const RepaintColorPicker({
    Key? key,
    required this.pickerColor,
    required this.child,
    required this.onColorChanged,
  }) : super(key: key);

  final Color pickerColor;
  final Widget child;
  final ValueChanged<Color> onColorChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Color>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            enabled: false,
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
          ),
        ];
      },
      child: child,
    );
  }
}
