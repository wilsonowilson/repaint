import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/text_layer_helper.dart';
import 'package:repaint/models/layer/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFontEditor extends StatelessWidget {
  static final _availableFontFamilies = <FontFamily>[
    FontFamily('Raleway', GoogleFonts.raleway()),
    FontFamily('Roboto', GoogleFonts.roboto()),
    FontFamily('Playfair Display', GoogleFonts.playfairDisplay()),
    FontFamily('Montserrat', GoogleFonts.montserrat()),
    FontFamily('Lobster', GoogleFonts.lobster()),
    FontFamily('Oswald', GoogleFonts.oswald()),
    FontFamily('Abril Fatface', GoogleFonts.abrilFatface()),
    FontFamily('Roboto Condensed', GoogleFonts.robotoCondensed()),
    FontFamily('Merriweather', GoogleFonts.merriweather()),
  ];

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    final selectFamily = _availableFontFamilies
        .where(
          (element) =>
              (selectedLayer?.data as TextLayer).style?.asFontFamily == element,
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
          PopupMenuButton<FontFamily>(
            tooltip: 'Pick a Font',
            onSelected: (e) {
              final layer = selectedLayer!.data as TextLayer;
              final editedLayer = layer.copyWith(
                  style: e.style.copyWith(
                fontSize: layer.style?.fontSize,
                color: layer.style?.color,
              ));
              final newLayer = TextLayerHelper.applyHeightToLayer(editedLayer);
              context.read<CanvasCubit>().editLayer(
                    selectedLayer.copyWith(
                      data: newLayer,
                    ),
                  );
            },
            itemBuilder: (e) {
              final items = _availableFontFamilies
                  .map(
                    (e) => PopupMenuItem(
                      height: 30,
                      value: e,
                      child: Text(e.name, style: e.style),
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
                  selectFamily.name,
                  style: (selectedLayer?.data as TextLayer).style?.copyWith(
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
