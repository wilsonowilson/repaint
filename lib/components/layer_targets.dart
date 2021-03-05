import 'package:flutter/material.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LayerTargets extends StatelessWidget {
  const LayerTargets({
    Key? key,
    required this.canvasKey,
    required this.child,
  }) : super(key: key);
  final GlobalKey canvasKey;
  final Widget child;

  Offset _localPosition(Offset offset) {
    final canvas = canvasKey.currentContext?.findRenderObject() as RenderBox;
    return canvas.globalToLocal(offset);
  }

  @override
  Widget build(BuildContext context) {
    /// Handle layer additions
    return DragTarget<RLayer>(onAcceptWithDetails: (e) {
      if (e.data is TextLayer) {
        final cubit = context.read<CanvasCubit>();
        final layer = (e.data as TextLayer).copyWith(
          offset: _localPosition(e.offset),
        );
        cubit.addLayer(layer);
      }
    }, builder: (context, objects, _) {
      /// Handle layer position edits
      return DragTarget<IdentityLayer>(onAcceptWithDetails: (e) {
        if (e.data.data is TextLayer) {
          final newLayer = (e.data.data as TextLayer)
              .copyWith(offset: _localPosition(e.offset));
          context
              .read<CanvasCubit>()
              .editLayer(e.data.copyWith(data: newLayer));
        }
      }, builder: (context, _, __) {
        return child;
      });
    });
  }
}
