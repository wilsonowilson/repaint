import 'package:flutter/material.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/text.dart';

class EditingSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;

    return Container(
      margin: EdgeInsets.only(top: 30),
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
        Container(
          child: TextFormField(
            initialValue: layer.text,
            maxLines: null,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blueGrey.shade800,
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white),
            onChanged: (e) {
              final span = TextSpan(text: layer.text, style: layer.style);
              final tp = TextPainter(
                text: span,
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
              );
              tp.layout(maxWidth: layer.size.width);
              final newLayer = layer.copyWith(
                  text: e, size: Size(layer.size.width, tp.size.height));
              context
                  .read<CanvasCubit>()
                  .editLayer(identityLayer.copyWith(data: newLayer));
            },
          ),
        ),
      ],
    );
  }
}
