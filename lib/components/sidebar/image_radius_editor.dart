import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/models/layer/image.dart';
import 'package:repaint/widgets/number_field.dart';

class ImageRadiusEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    final layer = selectedLayer!.data as ImageLayer;

    void updateBorderRadius(double e) {
      if (layer.radius <= 0.1 && e.isNegative) e = 0;
      final editedLayer = layer.copyWith(
        radius: e,
      );
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
              'Radius',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 70),
          Expanded(
            child: NumberField(
              text: layer.radius.toStringAsFixed(2),
              onValue: (e) {
                updateBorderRadius(
                  layer.radius + e,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
