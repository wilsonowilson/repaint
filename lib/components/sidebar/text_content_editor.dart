import 'package:flutter/material.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/text_layer_helper.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/models/layer/text.dart';

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

        final newLayer = TextLayerHelper.applyHeightToLayer(editedLayer);

        context
            .read<CanvasCubit>()
            .editLayer(identityLayer.copyWith(data: newLayer));
      },
    );
  }
}
