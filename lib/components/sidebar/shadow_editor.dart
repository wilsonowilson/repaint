import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/popup.dart';
import 'package:repaint/widgets/color_picker.dart';
import 'package:repaint/widgets/number_field.dart';

class LayerShadowEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    final textLayer = selectedLayer?.data;

    void _updateShadowOffset(Offset e) {
      final layer = selectedLayer!.data;
      final editedLayer = layer.copyWith(
        shadow: layer.shadow.copyWith(offset: e),
      );
      context.read<CanvasCubit>().editLayer(
            selectedLayer.copyWith(data: editedLayer),
          );
    }

    void _updateShadowColor(Color e) {
      final layer = selectedLayer!.data;
      final editedLayer = layer.copyWith(
        shadow: layer.shadow.copyWith(color: e),
      );
      context.read<CanvasCubit>().editLayer(
            selectedLayer.copyWith(data: editedLayer),
          );
    }

    void _updateShadowBlurRadius(double e) {
      final layer = selectedLayer!.data;
      final editedLayer = layer.copyWith(
        shadow: layer.shadow.copyWith(blurRadius: e),
      );
      context.read<CanvasCubit>().editLayer(
            selectedLayer.copyWith(data: editedLayer),
          );
    }

    void changeColor(Color color) {
      final newLayer = textLayer?.copyWith(
        shadow: textLayer.shadow.copyWith(color: color),
      );
      context.read<CanvasCubit>().editLayer(
            selectedLayer!.copyWith(
              data: newLayer,
            ),
          );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'X',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: NumberField(
                  text: textLayer?.shadow.offset.dx.toInt().toString() ?? '0',
                  onValue: (e) {
                    _updateShadowOffset(
                      (textLayer?.shadow.offset ?? Offset.zero) + Offset(e, 0),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Y',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: NumberField(
                  text: textLayer?.shadow.offset.dy.toInt().toString() ?? '',
                  onValue: (e) {
                    _updateShadowOffset(
                      (textLayer?.shadow.offset ?? Offset.zero) + Offset(0, e),
                    );
                  },
                ),
              ),
            ],
          ),
          Divider(color: Colors.blueGrey.shade800),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Blur Radius',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(width: 70),
              Expanded(
                child: NumberField(
                  updateValue: 0.1,
                  text: textLayer?.shadow.blurRadius.toStringAsFixed(2) ?? '0',
                  onValue: (e) {
                    _updateShadowBlurRadius(
                      (textLayer?.shadow.blurRadius ?? 0) + e,
                    );
                  },
                ),
              ),
            ],
          ),
          Divider(color: Colors.blueGrey.shade800),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Color',
                  style: TextStyle(
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
                        pickerColor: textLayer?.shadow.color ?? Colors.black,
                        onColorChanged: changeColor,
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: textLayer?.shadow.color ?? Colors.black,
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
          ),
          Divider(color: Colors.blueGrey.shade800),
        ],
      ),
    );
  }
}

extension ShadowExtension on Shadow? {
  Shadow copyWith({
    Color? color,
    Offset? offset,
    double? blurRadius,
  }) {
    if (this == null) return Shadow();

    return Shadow(
      color: color ?? this!.color,
      offset: offset ?? this!.offset,
      blurRadius: blurRadius ?? this!.blurRadius,
    );
  }
}
