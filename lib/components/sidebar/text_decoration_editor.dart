import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/text_layer_helper.dart';
import 'package:repaint/models/layer/text.dart';

class TextDecorationEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);

    final textLayer = selectedLayer!.data as TextLayer;
    final isItalic = textLayer.style.fontStyle == FontStyle.italic;
    final isUnderlined = textLayer.style.decoration == TextDecoration.underline;
    final hasStrikeThrough =
        textLayer.style.decoration == TextDecoration.lineThrough;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Text Features',
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FeatureToggle(
                icon: Icons.format_italic,
                isToggled: isItalic,
                onTap: (e) {
                  final editedLayer = textLayer.copyWith(
                    style: textLayer.style.copyWith(
                      fontStyle: e ? FontStyle.italic : FontStyle.normal,
                    ),
                  );
                  final newLayer =
                      TextLayerHelper.applyHeightToLayer(editedLayer);
                  cubit.editLayer(
                    selectedLayer.copyWith(
                      data: newLayer,
                    ),
                  );
                },
              ),
              SizedBox(width: 5),
              FeatureToggle(
                icon: Icons.format_underline,
                isToggled: isUnderlined,
                onTap: (e) {
                  var decoration = textLayer.style.decoration;
                  if (e)
                    decoration = TextDecoration.underline;
                  else
                    decoration = TextDecoration.none;

                  final editedLayer = textLayer.copyWith(
                    style: textLayer.style.copyWith(
                      decoration: decoration,
                    ),
                  );
                  final newLayer =
                      TextLayerHelper.applyHeightToLayer(editedLayer);
                  cubit.editLayer(
                    selectedLayer.copyWith(
                      data: newLayer,
                    ),
                  );
                },
              ),
              SizedBox(width: 5),
              FeatureToggle(
                icon: Icons.format_strikethrough,
                isToggled: hasStrikeThrough,
                onTap: (e) {
                  var decoration = textLayer.style.decoration;
                  if (e)
                    decoration = TextDecoration.lineThrough;
                  else
                    decoration = TextDecoration.none;

                  final editedLayer = textLayer.copyWith(
                    style: textLayer.style.copyWith(
                      decoration: decoration,
                    ),
                  );
                  final newLayer =
                      TextLayerHelper.applyHeightToLayer(editedLayer);
                  cubit.editLayer(
                    selectedLayer.copyWith(
                      data: newLayer,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FeatureToggle extends StatelessWidget {
  final IconData icon;
  final bool isToggled;
  final ValueChanged<bool> onTap;

  const FeatureToggle({
    Key? key,
    required this.icon,
    required this.isToggled,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(!isToggled);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.blueGrey.shade800,
          ),
          color: isToggled ? Colors.blueGrey.shade800 : null,
        ),
        padding: EdgeInsets.all(4),
        child: Center(
          child: Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
