import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/text.dart';

class EditBar extends StatelessWidget {
  const EditBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
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
      child: state.selectedLayer.isNone()
          ? null
          : Row(
              children: [
                if (selectedLayer?.data is TextLayer)
                  ..._buildTextEditComponents(context, selectedLayer!)
              ],
            ),
    );
  }

  Iterable<Widget> _buildTextEditComponents(
    BuildContext context,
    IdentityLayer selectedLayer,
  ) sync* {
    final layer = selectedLayer.data as TextLayer;
    yield Container(
      width: 200,
      child: TextFormField(
        initialValue: layer.text,
        maxLines: null,
        decoration: InputDecoration(
          filled: true,
          border: InputBorder.none,
        ),
        onFieldSubmitted: (e) {},
        onChanged: (e) {
          final newLayer = layer.copyWith(text: e);
          context.read<CanvasCubit>().editLayer(
                selectedLayer.copyWith(
                  data: newLayer,
                ),
              );
        },
      ),
    );
  }
}
