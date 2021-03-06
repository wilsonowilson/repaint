import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/text_layer_helper.dart';
import 'package:repaint/models/layer/text.dart';

class TextWeightEditor extends StatelessWidget {
  static final _weights = <Weight>[
    Weight('Light', FontWeight.w200),
    Weight('Regular', FontWeight.normal),
    Weight('Bold', FontWeight.bold),
    Weight('Black', FontWeight.w900),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);

    final selectedWeight = _weights.firstWhere(
      (element) =>
          element.weight == (selectedLayer?.data as TextLayer).style.fontWeight,
      orElse: () => _weights[1],
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Font Weight',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          PopupMenuButton<Weight>(
            tooltip: 'Pick a Weight',
            onSelected: (e) {
              final layer = selectedLayer!.data as TextLayer;
              final editedLayer = layer.copyWith(
                  style: layer.style.copyWith(fontWeight: e.weight));
              final newLayer = TextLayerHelper.applyHeightToLayer(editedLayer);
              context.read<CanvasCubit>().editLayer(
                    selectedLayer.copyWith(
                      data: newLayer,
                    ),
                  );
            },
            itemBuilder: (e) {
              final items = _weights
                  .map(
                    (e) => PopupMenuItem(
                      height: 30,
                      value: e,
                      child: Center(
                        child: Text(
                          e.name,
                          style: GoogleFonts.getFont(
                            'Raleway',
                            fontWeight: e.weight,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList();
              return items;
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.blueGrey.shade800,
                  )),
              alignment: Alignment.center,
              child: Text(
                selectedWeight.name,
                style: GoogleFonts.getFont(
                  'Raleway',
                  color: Colors.white,
                  fontWeight: selectedWeight.weight,
                ),
              ),
              height: 35,
              width: 140,
            ),
          ),
        ],
      ),
    );
  }
}

class Weight {
  Weight(this.name, this.weight);
  final String name;
  final FontWeight weight;
}
