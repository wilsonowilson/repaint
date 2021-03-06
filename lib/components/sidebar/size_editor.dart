import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/widgets/number_field.dart';

class LayerSizeEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    final textLayer = selectedLayer?.data;
    void _increaseSize(Size e) {
      final layer = selectedLayer!.data;
      final editedLayer = layer.copyWith(size: e);

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
              'W',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: NumberField(
              text: textLayer?.size.width.toInt().toString() ?? '',
              onValue: (e) {
                _increaseSize(
                  textLayer!.size + Offset(e.toDouble(), 0),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'H',
              style: TextStyle(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: NumberField(
              text: textLayer?.size.height.toInt().toString() ?? '',
              onValue: (e) {
                _increaseSize(
                  textLayer!.size + Offset(0, e.toDouble()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
