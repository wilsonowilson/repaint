import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/text_layer_helper.dart';
import 'package:repaint/models/layer/text.dart';

class TextSizeEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    final textLayer = selectedLayer?.data as TextLayer;
    void _increaseTextSize(double e) {
      final layer = selectedLayer!.data as TextLayer;

      final editedLayer =
          layer.copyWith(style: layer.style?.copyWith(fontSize: e));
      final newLayer = TextLayerHelper.applyHeightToLayer(editedLayer);
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
            'Font Size',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.blueGrey.shade800,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle, size: 18),
                  onPressed: () {
                    final layer = selectedLayer?.data as TextLayer;
                    final currentSize = layer.style?.fontSize ?? 14;
                    _increaseTextSize(currentSize - 2);
                  },
                  color: Colors.white,
                ),
                Expanded(
                  child: PopupMenuButton<double>(
                    onSelected: _increaseTextSize,
                    tooltip: 'Pick a Size',
                    itemBuilder: (e) {
                      return _avalaibleTextSizes
                          .map(
                            (e) => PopupMenuItem<double>(
                              value: e,
                              child: Text('${e.toInt()}px'),
                            ),
                          )
                          .toList();
                    },
                    child: Text(
                      '${textLayer.style?.fontSize?.toInt()}px',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle, size: 18),
                  onPressed: () {
                    final layer = selectedLayer?.data as TextLayer;
                    final currentSize = layer.style?.fontSize ?? 14;
                    _increaseTextSize(currentSize + 2);
                  },
                  color: Colors.white,
                ),
              ],
            ),
            width: 140,
          ),
        ],
      ),
    );
  }
}

const _avalaibleTextSizes = <double>[
  4,
  8,
  12,
  16,
  20,
  24,
  32,
  48,
  64,
  72,
  84,
  92,
  124,
  148,
];
