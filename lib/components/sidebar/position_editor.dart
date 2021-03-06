import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/widgets/number_field.dart';

class LayerPositionEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    final textLayer = selectedLayer?.data;
    void _increasePosition(Offset e) {
      final layer = selectedLayer!.data;
      final editedLayer = layer.copyWith(offset: e);

      context.read<CanvasCubit>().editLayer(
            selectedLayer.copyWith(data: editedLayer),
          );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
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
              text: textLayer?.offset.dx.toInt().toString() ?? '',
              onValue: (e) {
                _increasePosition(
                  textLayer!.offset + Offset(e.toDouble(), 0),
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
              text: textLayer?.offset.dy.toInt().toString() ?? '',
              onValue: (e) {
                _increasePosition(
                  textLayer!.offset + Offset(0, e.toDouble()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
