import 'package:flutter/material.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/image_picker.dart';
import 'package:repaint/models/layer/image.dart';
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

  bool _withinBounds(Offset offset, RLayer layer) {
    final canvas = canvasKey.currentContext?.findRenderObject() as RenderBox;
    final canvasSize = canvas.size;

    final rect = Rect.fromLTRB(-layer.size.width, -layer.size.height,
        canvasSize.width, canvasSize.height);
    final localPosition = _localPosition(offset);

    return rect.contains(localPosition);
  }

  void _actOnLayerWithinBounds(
    Function() fn,
    Offset offset,
    RLayer layer, {
    required BuildContext context,
    bool editing = false,
    IdentityLayer? identityLayer,
  }) {
    if (_withinBounds(offset, layer))
      fn.call();
    else {
      if (editing) {
        assert(identityLayer != null);
        context.read<CanvasCubit>().removeLayer(identityLayer!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Handle layer additions
    return DragTarget<RLayer>(
      onLeave: (e) {
        print(e);
      },
      onAcceptWithDetails: (e) async {
        if (!_withinBounds(e.offset, e.data)) return;
        if (e.data is TextLayer) {
          final cubit = context.read<CanvasCubit>();
          final layer = (e.data as TextLayer).copyWith(
            offset: _localPosition(e.offset),
          );
          cubit.addLayer(layer);
        } else if (e.data is ImageLayer) {
          final bytes = await ImagePicker.pickImage();
          if (bytes == null) return;
          final cubit = context.read<CanvasCubit>();
          final layer = (e.data as ImageLayer).copyWith(
            offset: _localPosition(e.offset),
            data: bytes,
          );

          cubit.addLayer(layer);
        }
      },
      builder: (context, objects, _) {
        /// Handle layer position edits
        return DragTarget<IdentityLayer>(onAcceptWithDetails: (e) {
          final cubit = context.read<CanvasCubit>();

          if (e.data.data is TextLayer) {
            final newLayer = (e.data.data as TextLayer)
                .copyWith(offset: _localPosition(e.offset));

            _actOnLayerWithinBounds(
              () => cubit.editLayer(e.data.copyWith(data: newLayer)),
              e.offset,
              e.data.data,
              context: context,
              editing: true,
              identityLayer: e.data,
            );
          }
          if (e.data.data is ImageLayer) {
            final newLayer = (e.data.data as ImageLayer)
                .copyWith(offset: _localPosition(e.offset));
            _actOnLayerWithinBounds(
              () => cubit.editLayer(e.data.copyWith(data: newLayer)),
              e.offset,
              e.data.data,
              context: context,
              editing: true,
              identityLayer: e.data,
            );
          }
        }, builder: (context, _, __) {
          return child;
        });
      },
    );
  }
}
