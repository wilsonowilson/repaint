import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/application/utils/popup.dart';
import 'package:repaint/components/sidebar/sidebar_heading.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/text.dart';
import 'package:repaint/widgets/default_popup.dart';

class EditingSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;

    return Container(
      margin: EdgeInsets.only(top: 20),
      child: state.selectedOption.isTextLayer
          ? TextLayerEditSidebar(identityLayer: state.selectedOption)
          : SizedBox(),
    );
  }
}

class TextLayerEditSidebar extends StatelessWidget {
  const TextLayerEditSidebar({
    Key? key,
    required this.identityLayer,
  }) : super(key: key);
  final IdentityLayer identityLayer;

  @override
  Widget build(BuildContext context) {
    final layer = identityLayer.data as TextLayer;
    return Column(
      children: [
        SidebarHeading(
          title: 'CONTENT',
          padding: 5,
        ),
        SizedBox(height: 15),
        TextContentEditor(
          layer: layer,
          identityLayer: identityLayer,
        ),
        SizedBox(height: 15),
        SidebarHeading(
          title: 'STYLE',
          padding: 5,
        ),
        SizedBox(height: 15),
        Divider(color: Colors.blueGrey.shade700),
        SizedBox(height: 5),
        TextFontSelector(),
        SizedBox(height: 5),
        Divider(color: Colors.blueGrey.shade700)
      ],
    );
  }
}

class TextContentEditor extends StatelessWidget {
  const TextContentEditor({
    Key? key,
    required this.layer,
    required this.identityLayer,
  }) : super(key: key);

  final TextLayer layer;
  final IdentityLayer identityLayer;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: layer.text,
      maxLines: null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.blueGrey.shade800,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueGrey.shade700,
            width: 2,
          ),
        ),
      ),
      style: TextStyle(color: Colors.white),
      onChanged: (e) {
        final editedLayer = layer.copyWith(
          text: e,
        );

        final newLayer = _applyHeightToLayer(editedLayer);

        context
            .read<CanvasCubit>()
            .editLayer(identityLayer.copyWith(data: newLayer));
      },
    );
  }
}

TextLayer _applyHeightToLayer(TextLayer layer) {
  final span = TextSpan(text: layer.text, style: layer.style);
  final tp = TextPainter(
    text: span,
    textDirection: TextDirection.ltr,
  );
  tp.layout(maxWidth: layer.size.width);
  final newLayer = layer.copyWith(
    text: layer.text,
    size: Size(
      layer.size.width,
      tp.size.height,
    ),
  );
  return newLayer;
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
              final newLayer = _applyHeightToLayer(editedLayer);
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

class TextFontSelectorDialog extends StatelessWidget {
  const TextFontSelectorDialog({
    Key? key,
  }) : super(key: key);

  static Future<FontFamily?> show(BuildContext context) {
    return showPopup<FontFamily>(
      context: context,
      anchor: Anchor(
        target: Alignment.bottomRight,
        source: Alignment.topRight,
      ),
      popup: TextFontSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPopupContainer(
      child: ListView(),
    );
  }
}
