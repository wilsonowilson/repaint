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
