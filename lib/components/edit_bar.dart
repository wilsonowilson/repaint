import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/text.dart';

class EditBar extends StatelessWidget {
  const EditBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    return Container(
      height: 60,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 20),
          )
        ],
      ),
      child: Builder(builder: (context) {
        if (state.selectedLayer.isNone()) return SizedBox();

        if (selectedLayer?.data is TextLayer)
          return TextEditBar(
            selectedLayer: selectedLayer!,
          );

        return SizedBox();
      }),
    );
  }
}

class TextEditBar extends StatelessWidget {
  const TextEditBar({Key? key, required this.selectedLayer}) : super(key: key);

  final IdentityLayer selectedLayer;

  @override
  Widget build(BuildContext context) {
    final layer = selectedLayer.data as TextLayer;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          Container(
            width: 200,
            child: TextFormField(
              initialValue: layer.text,
              maxLines: null,
              decoration: InputDecoration(
                filled: true,
                border: InputBorder.none,
              ),
              onFieldSubmitted: (e) {},
              onChanged: (e) => _editLayerText(context, e),
            ),
          ),
          SizedBox(width: 20),
          TextSizeSelector(),
          TextFontSelector(),
        ],
      ),
    );
  }

  void _editLayerText(BuildContext context, String e) {
    final layer = selectedLayer.data as TextLayer;
    final newLayer = layer.copyWith(text: e);
    context.read<CanvasCubit>().editLayer(
          selectedLayer.copyWith(
            data: newLayer,
          ),
        );
  }
}

class TextSizeSelector extends StatefulWidget {
  const TextSizeSelector({
    Key? key,
  }) : super(key: key);

  @override
  _TextSizeSelectorState createState() => _TextSizeSelectorState();
}

class _TextSizeSelectorState extends State<TextSizeSelector> {
  static const _avalaibleTextSizes = <double>[
    4,
    8,
    12,
    16,
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
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);

    return DropdownButton<double>(
      value: (selectedLayer?.data as TextLayer).style?.fontSize,
      underline: SizedBox(),
      isDense: true,
      onChanged: (e) {
        final layer = selectedLayer!.data as TextLayer;
        final newLayer = layer.copyWith(
          style: layer.style?.copyWith(fontSize: e),
        );
        context.read<CanvasCubit>().editLayer(
              selectedLayer.copyWith(
                data: newLayer,
              ),
            );
      },
      items: _avalaibleTextSizes
          .map(
            (e) => DropdownMenuItem<double>(
              value: e,
              child: Text('${e}px'),
            ),
          )
          .toList(),
    );
  }
}

class TextFontSelector extends StatefulWidget {
  const TextFontSelector({
    Key? key,
  }) : super(key: key);

  @override
  _TextFontSelectorState createState() => _TextFontSelectorState();
}

class _TextFontSelectorState extends State<TextFontSelector> {
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
    final selectFamily = (selectedLayer?.data as TextLayer).style?.asFontFamily;
    return DropdownButton<FontFamily>(
      value: selectFamily,
      underline: SizedBox(),
      isDense: true,
      onChanged: (e) {
        final layer = selectedLayer!.data as TextLayer;
        final newLayer = layer.copyWith(
            style: e?.style.copyWith(
          fontSize: layer.style?.fontSize,
          color: layer.style?.color,
        ));
        context.read<CanvasCubit>().editLayer(
              selectedLayer.copyWith(
                data: newLayer,
              ),
            );
      },
      items: _availableFontFamilies
          .map(
            (e) => DropdownMenuItem<FontFamily>(
              value: e,
              child: Text(e.name ?? '', style: e.style),
            ),
          )
          .toList(),
    );
  }
}

class FontFamily {
  final String? name;
  final TextStyle style;

  FontFamily(this.name, this.style);

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FontFamily && o.name == name ||
        (o as FontFamily).style.fontFamily == style.fontFamily;
  }

  @override
  int get hashCode => name.hashCode ^ style.hashCode;
}

extension FontFamilyExtension on TextStyle {
  FontFamily get asFontFamily => FontFamily(fontFamily, this);
}
