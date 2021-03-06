import 'package:flutter/material.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/components/sidebar/sidebar_heading.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/text.dart';

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
        final span = TextSpan(text: layer.text, style: layer.style);
        final tp = TextPainter(
          text: span,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: layer.size.width);
        final newLayer = layer.copyWith(
          text: e,
          size: Size(
            layer.size.width,
            tp.size.height,
          ),
        );
        context
            .read<CanvasCubit>()
            .editLayer(identityLayer.copyWith(data: newLayer));
      },
    );
  }
}
