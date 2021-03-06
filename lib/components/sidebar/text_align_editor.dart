import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/text_layer_helper.dart';
import 'package:repaint/models/layer/text.dart';

class TextAlignmentEditor extends StatelessWidget {
  static final _alignments = <TextAlignment>[
    TextAlignment(TextAlign.start, FontAwesomeIcons.alignLeft),
    TextAlignment(TextAlign.center, FontAwesomeIcons.alignCenter),
    TextAlignment(TextAlign.end, FontAwesomeIcons.alignRight),
    TextAlignment(TextAlign.justify, FontAwesomeIcons.alignJustify),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);

    final selectedAlignment = _alignments.firstWhere(
      (element) => element.align == (selectedLayer?.data as TextLayer).align,
      orElse: () => _alignments.first,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Text Align',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          PopupMenuButton<TextAlignment>(
            tooltip: 'Pick an Alignment',
            onSelected: (e) {
              final layer = selectedLayer!.data as TextLayer;
              final editedLayer = layer.copyWith(
                align: e.align,
              );
              final newLayer = TextLayerHelper.applyHeightToLayer(editedLayer);
              context.read<CanvasCubit>().editLayer(
                    selectedLayer.copyWith(
                      data: newLayer,
                    ),
                  );
            },
            itemBuilder: (e) {
              final items = _alignments
                  .map(
                    (e) => PopupMenuItem(
                      height: 30,
                      value: e,
                      child: Center(child: Icon(e.icon)),
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
              child: Icon(selectedAlignment.icon, color: Colors.white),
              height: 35,
              width: 140,
            ),
          ),
        ],
      ),
    );
  }
}

class TextAlignment {
  TextAlignment(this.align, this.icon);
  final IconData icon;
  final TextAlign align;

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TextAlignment && o.align == align;
  }

  @override
  int get hashCode => icon.hashCode ^ align.hashCode;
}
