import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/components/layer_targets.dart';
import 'package:repaint/models/core/canvas.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/text.dart';
import 'package:repaint/widgets/interactive_canvas_viewer.dart';

import 'edit_bar.dart';

class PaintingArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditBar(),
        Expanded(
          child: GestureCanvas(),
        ),
      ],
    );
  }
}

class GestureCanvas extends StatefulWidget {
  const GestureCanvas({
    Key? key,
  }) : super(key: key);

  @override
  _GestureCanvasState createState() => _GestureCanvasState();
}

class _GestureCanvasState extends State<GestureCanvas> {
  TransformationController controller = TransformationController();
  TransformationController scaleController = TransformationController();
  GlobalKey canvasKey = GlobalKey();
  Offset initialTranslation = Offset(0, 0);
  Size _effectiveCanvasSize = Size.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final canvas = context.read<CanvasCubit>().state.canvas;
      _effectiveCanvasSize = _getEffectiveCanvasSize(canvas);
      _positionCanvas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final canvas = cubit.state.canvas;
    return Listener(
      onPointerSignal: _calculateTranslation,
      onPointerDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
        cubit.deselectLayer();
      },
      child: Container(
        color: Color(0xffeaeaea),
        child: InteractiveCanvasViewer(
          scale: false,
          controller: controller,
          scaleController: scaleController,
          child: Center(
            child: LayerTargets(
              canvasKey: canvasKey,
              child: CanvasComponent(
                canvasKey: canvasKey,
                effectiveCanvasSize: _effectiveCanvasSize,
                canvas: canvas,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Size _getEffectiveCanvasSize(RCanvas canvas) {
    final screenSize = MediaQuery.of(context).size;
    final canvasSize = Size(canvas.width, canvas.height);

    var scale = 1.0;
    final effectiveSize = Size(screenSize.width - 300, screenSize.height - 120);
    if (canvasSize.width > effectiveSize.width ||
        canvasSize.height > effectiveSize.height) {
      final ratioX = canvasSize.width / screenSize.width;
      final ratioY = canvasSize.height / screenSize.height;
      scale = 0.8 / max(ratioX, ratioY);
    }
    return canvasSize * scale;
  }

  void _calculateTranslation(PointerSignalEvent event) {
    final canvas = context.read<CanvasCubit>().state.canvas;
    if (event is PointerScrollEvent) {
      final delta = event.scrollDelta;
      final translation = controller.value.getTranslation();
      final dx = translation[0];
      final dy = translation[1];
      final resolvedTranslation =
          Offset(dx - initialTranslation.dx, dy - initialTranslation.dy);
      final maxTranslation =
          initialTranslation + Offset(canvas.width / 6, canvas.height / 6);
      var translationX = -delta.dx;
      var translationY = -delta.dy;

      if (resolvedTranslation.dx < -maxTranslation.dx && !delta.dx.isNegative ||
          resolvedTranslation.dx > maxTranslation.dx && delta.dx.isNegative) {
        translationX = 0;
      }
      if (resolvedTranslation.dy < -maxTranslation.dy && !delta.dy.isNegative ||
          resolvedTranslation.dy > maxTranslation.dy && delta.dy.isNegative) {
        translationY = 0;
      }
      setState(() {
        controller.value = controller.value
          ..translate(translationX, translationY);
      });
    }
  }

  void _positionCanvas() {
    final screenSize = MediaQuery.of(context).size;

    var scale = 1.0;
    final effectiveSize = Size(screenSize.width - 300, screenSize.height - 120);
    final canvasSize = _effectiveCanvasSize;
    final transY = (effectiveSize.height / 2) - (canvasSize.height / 2) * scale;
    final transX = (effectiveSize.width / 2) - (canvasSize.width / 2) * scale;
    initialTranslation = Offset(transX, transY);
    setState(() => controller.value.translate(transX, transY));
  }
}

class CanvasComponent extends StatelessWidget {
  const CanvasComponent({
    Key? key,
    required this.canvasKey,
    required Size effectiveCanvasSize,
    required this.canvas,
  })   : _effectiveCanvasSize = effectiveCanvasSize,
        super(key: key);

  final GlobalKey canvasKey;
  final Size _effectiveCanvasSize;
  final RCanvas canvas;

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: canvasKey,
      children: [
        Container(
          width: _effectiveCanvasSize.width,
          height: _effectiveCanvasSize.height,
          decoration: BoxDecoration(
            color: canvas.color,
          ),
        ),
        ..._getLayers(context),
      ],
    );
  }

  Iterable<Widget> _getLayers(BuildContext context) sync* {
    // ignore: close_sinks
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final identityLayers = state.layers;

    for (final identityLayer in identityLayers) {
      // final selected = state.selectedLayer.fold(() => null, (a) => a)?.id ==
      //     identityLayer.id;
      final layer = identityLayer.data;

      if (layer is TextLayer) {
        yield TextCanvas(
          identityLayer: identityLayer,
        );
      }
    }
  }
}

class TextCanvas extends StatefulWidget {
  TextCanvas({
    Key? key,
    required this.identityLayer,
  }) : super(key: key);
  final IdentityLayer identityLayer;

  @override
  _TextCanvasState createState() => _TextCanvasState();
}

class _TextCanvasState extends State<TextCanvas> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selected = state.selectedLayer.fold(() => null, (a) => a)?.id ==
        widget.identityLayer.id;
    final layer = widget.identityLayer.data as TextLayer;

    var placeHolder = Text(
      layer.text,
      style: layer.style,
    );

    return Transform.translate(
      offset: layer.offset,
      child: SelectableComponent(
        layer: widget.identityLayer,
        isSelected: selected,
        focusNode: focusNode,
        child: GestureDetector(
          onTap: () {
            if (!selected) {
              cubit.selectLayer(widget.identityLayer);
              focusNode.requestFocus();
            } else {
              cubit.deselectLayer();
              focusNode.nextFocus();
            }
          },
          child: Container(
            width: layer.size?.width,
            height: layer.size?.height,
            child: Draggable<IdentityLayer>(
              data: widget.identityLayer,
              childWhenDragging: Opacity(
                opacity: 0.2,
                child: placeHolder,
              ),
              feedback: Material(
                color: Colors.transparent,
                child: placeHolder,
              ),
              child: placeHolder,
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteIntent extends Intent {}

class SelectableComponent extends StatelessWidget {
  const SelectableComponent({
    Key? key,
    this.resizable = false,
    required this.layer,
    required this.child,
    required this.focusNode,
    required this.isSelected,
  }) : super(key: key);
  final Widget child;
  final IdentityLayer layer;
  final bool isSelected;
  final bool resizable;
  final FocusNode focusNode;
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: focusNode,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.backspace): DeleteIntent(),
      },
      actions: {
        DeleteIntent: CallbackAction(
            onInvoke: (_) => context.read<CanvasCubit>()
              ..deselectLayer()
              ..removeLayer(layer)),
      },
      child: Stack(
        children: [
          Container(
            width: layer.data.size?.width,
            height: layer.data.size?.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: isSelected
                  ? Border.all(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      width: 2,
                    )
                  : null,
            ),
            child: Opacity(
              opacity: 0,
              child: child,
            ),
          ),
          child,
          if (resizable) ..._buildPills(context),
        ],
      ),
    );
  }

  Iterable<Widget> _buildPills(BuildContext context) sync* {
    yield Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Pill(
          width: 7,
          height: 20,
          onPanUpdate: (e) {
            print(e);
          },
        ),
      ),
    );
    yield Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Center(
        child: Pill(
          width: 20,
          height: 7,
        ),
      ),
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({
    Key? key,
    required this.width,
    required this.height,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
  }) : super(key: key);
  final double width;
  final double height;
  final Function(DragStartDetails)? onPanStart;
  final Function(DragUpdateDetails)? onPanUpdate;
  final Function(DragEndDetails)? onPanEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
            ),
          ],
        ),
      ),
    );
  }
}

  // takeScreenShot() async {
  //   await Future.delayed(Duration(milliseconds: 2000));
  //   final boundary =
  //       canvasKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
  //   ui.Image image = await boundary.toImage();

  //   final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   final pngBytes = byteData!.buffer.asUint8List();

  //   FileSaver().saveAs(pngBytes, "untitled.png");
  // }

// class FileSaver {
//   void saveAs(List<int> bytes, String fileName) =>
//       js.context.callMethod("saveAs", [
//         html.Blob([bytes]),
//         fileName
//       ]);
// }
