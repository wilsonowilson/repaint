import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/text_layer_helper.dart';
import 'package:repaint/models/layer/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFontEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    final selectFamily = availableFonts
        .where(
          (element) => (selectedLayer?.data as TextLayer).font == element,
        )
        .first;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Font Family',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Pick a Font',
            onSelected: (e) {
              final layer = selectedLayer!.data as TextLayer;
              final editedLayer = layer.copyWith(font: e);
              final newLayer = TextLayerHelper.applyHeightToLayer(editedLayer);
              context.read<CanvasCubit>().editLayer(
                    selectedLayer.copyWith(
                      data: newLayer,
                    ),
                  );
            },
            itemBuilder: (e) {
              final items = availableFonts
                  .map(
                    (e) => PopupMenuItem<String>(
                      height: 30,
                      value: e,
                      child: Text(
                        e,
                        style: GoogleFonts.getFont(e),
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  selectFamily,
                  style: GoogleFonts.getFont(
                    selectFamily,
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
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

class FontFamily {
  final String name;
  final TextStyle style;

  FontFamily(this.name, this.style);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FontFamily &&
        ((o.name.contains(name) || name.contains(o.name)) ||
            o.style.fontFamily == style.fontFamily);
  }

  @override
  int get hashCode => name.hashCode ^ style.hashCode;

  @override
  String toString() => '$name';
}

extension FontFamilyExtension on TextStyle {
  FontFamily get asFontFamily => FontFamily(this.fontFamily ?? '', this);
}
