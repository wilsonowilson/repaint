import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/components/layer_targets.dart';
import 'package:repaint/models/core/canvas.dart';
import 'package:repaint/models/layer/image.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:repaint/models/layer/paint.dart';
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
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          cubit.deselectLayer();
        },
        child: Container(
          color: Color(0xffeaeaea),
          child: LayerTargets(
            canvasKey: canvasKey,
            child: InteractiveCanvasViewer(
              scale: false,
              controller: controller,
              scaleController: scaleController,
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
    final canvasSize = Size(canvas.size.width, canvas.size.height);

    var scale = 1.0;
    final effectiveSize = Size(screenSize.width - 300, screenSize.height - 120);
    if (canvasSize.width > effectiveSize.width ||
        canvasSize.height > effectiveSize.height) {
      final ratioX = canvasSize.width / screenSize.width;
      final ratioY = canvasSize.height / screenSize.height;
      scale = 0.8 / max(ratioX, ratioY);
    }
    final effectiveCanvasSize = canvasSize * scale;
    context
        .read<CanvasCubit>()
        .editCanvas(canvas.copyWith(effectiveSize: effectiveCanvasSize));
    return effectiveCanvasSize;
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
      final maxTranslation = initialTranslation +
          Offset(canvas.size.width / 6, canvas.size.height / 6);
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

class CustomRect extends CustomClipper<Rect> {
  final Size effectiveSize;

  CustomRect(this.effectiveSize);
  @override
  Rect getClip(Size size) {
    Rect rect =
        Rect.fromLTRB(0.0, 0.0, effectiveSize.width, effectiveSize.height);
    return rect;
  }

  @override
  bool shouldReclip(CustomRect oldClipper) {
    return false;
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
    return ClipRect(
      clipper: CustomRect(_effectiveCanvasSize),
      child: Stack(
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
      ),
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
      } else if (layer is ImageLayer) {
        yield ImageCanvas(
          identityLayer: identityLayer,
        );
      } else if (layer is PaintLayer) {
        yield PaintCanvas(
          identityLayer: identityLayer,
        );
      }
    }
  }
}

class ImageCanvas extends StatefulWidget {
  ImageCanvas({
    Key? key,
    required this.identityLayer,
  }) : super(key: key);
  final IdentityLayer identityLayer;

  @override
  _ImageCanvasState createState() => _ImageCanvasState();
}

class _ImageCanvasState extends State<ImageCanvas> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selected = state.selectedLayer.fold(() => null, (a) => a)?.id ==
        widget.identityLayer.id;
    final layer = widget.identityLayer.data as ImageLayer;
    final placeHolder = Container(
      width: layer.size.width,
      height: layer.size.height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: layer.shadow.blurRadius,
            color: layer.shadow.color,
            offset: layer.shadow.offset,
          ),
        ],
        borderRadius: BorderRadius.circular(layer.radius),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(
            layer.data!,
          ),
        ),
      ),
    );
    return Transform.translate(
      offset: layer.offset,
      child: DraggableLayer(
        layer: widget.identityLayer,
        child: SelectableComponent(
          layer: widget.identityLayer,
          isSelected: selected,
          resizable: true,
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
            child: placeHolder,
          ),
        ),
      ),
    );
  }
}

class DraggableLayer extends StatefulWidget {
  const DraggableLayer({
    Key? key,
    required this.layer,
    required this.child,
  }) : super(key: key);

  final IdentityLayer layer;
  final Widget child;

  @override
  _DraggableLayerState createState() => _DraggableLayerState();
}

class _DraggableLayerState extends State<DraggableLayer> {
  Offset newOffset = Offset.zero;
  Offset startingPoint = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Transform(
        transform: Matrix4.identity()..translate(newOffset.dx, newOffset.dy),
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    startingPoint = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    newOffset = details.localPosition - startingPoint;
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    final identityLayer = widget.layer;
    final layer = identityLayer.data;
    final newLayer = identityLayer.copyWith(
      data: layer.copyWith(offset: layer.offset + newOffset),
    );
    context.read<CanvasCubit>().editLayer(newLayer);
    newOffset = Offset.zero;
    setState(() {});
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
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selected = state.selectedLayer.fold(() => null, (a) => a)?.id ==
        widget.identityLayer.id;

    final layer = widget.identityLayer.data as TextLayer;
    var placeHolder = Container(
      width: layer.size.width,
      height: layer.size.height,
      child: Text(
        layer.text,
        style: GoogleFonts.getFont(
          layer.font,
          fontWeight: layer.style.fontWeight,
          fontSize: layer.style.fontSize,
          color: layer.style.color,
          fontStyle: layer.style.fontStyle,
          decoration: layer.style.decoration,
          shadows: [
            layer.shadow,
          ],
        ),
        textAlign: layer.align,
      ),
    );

    return Transform.translate(
      offset: layer.offset,
      child: DraggableLayer(
        layer: widget.identityLayer,
        child: SelectableComponent(
          layer: widget.identityLayer,
          isSelected: selected,
          focusNode: focusNode,
          resizable: true,
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
            child: placeHolder,
          ),
        ),
      ),
    );
  }
}

class PaintCanvas extends StatefulWidget {
  PaintCanvas({
    Key? key,
    required this.identityLayer,
  }) : super(key: key);
  final IdentityLayer identityLayer;

  @override
  _PaintCanvasState createState() => _PaintCanvasState();
}

class _PaintCanvasState extends State<PaintCanvas> {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selected = state.selectedLayer.fold(() => null, (a) => a)?.id ==
        widget.identityLayer.id;

    final layer = widget.identityLayer.data as PaintLayer;
    var placeHolder = Container(
      width: layer.size.width,
      height: layer.size.height,
      decoration: BoxDecoration(
          color: layer.color,
          shape: layer.shape,
          borderRadius: layer.shape == BoxShape.circle
              ? null
              : BorderRadius.circular(layer.radius),
          boxShadow: [
            BoxShadow(
              offset: layer.shadow.offset,
              blurRadius: layer.shadow.blurRadius,
              color: layer.shadow.color,
            ),
          ]),
    );

    return Transform.translate(
      offset: layer.offset,
      child: DraggableLayer(
        layer: widget.identityLayer,
        child: SelectableComponent(
          layer: widget.identityLayer,
          isSelected: selected,
          focusNode: focusNode,
          resizable: true,
          scaleProportionally: layer.shape == BoxShape.circle,
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
            child: placeHolder,
          ),
        ),
      ),
    );
  }
}

class DeleteIntent extends Intent {}

class SelectableComponent extends StatefulWidget {
  const SelectableComponent({
    Key? key,
    this.resizable = false,
    this.scaleProportionally = false,
    required this.layer,
    required this.child,
    required this.focusNode,
    required this.isSelected,
  }) : super(key: key);
  final Widget child;
  final IdentityLayer layer;
  final bool isSelected;
  final bool resizable;
  final bool scaleProportionally;
  final FocusNode focusNode;

  @override
  _SelectableComponentState createState() => _SelectableComponentState();
}

class _SelectableComponentState extends State<SelectableComponent> {
  double? startingPosition = 0;
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: widget.focusNode,
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.backspace): DeleteIntent(),
      },
      actions: {
        DeleteIntent: CallbackAction(
            onInvoke: (_) => context.read<CanvasCubit>()
              ..deselectLayer()
              ..removeLayer(widget.layer)),
      },
      child: Stack(
        children: [
          widget.child,
          IgnorePointer(
            ignoring: true,
            child: Container(
              width: widget.layer.data.size.width,
              height: widget.layer.data.size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: widget.isSelected
                    ? Border.all(
                        color: Colors.cyanAccent.withOpacity(0.5),
                        width: 2,
                      )
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
              ),
            ),
          ),
          if (widget.resizable && widget.isSelected) ..._buildPills(context),
        ],
      ),
    );
  }

  Iterable<Widget> _buildPills(BuildContext context) sync* {
    yield Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Center(
        child: Pill(
          width: 7,
          height: 20,
          onPanStart: (e) {
            startingPosition = widget.layer.data.size.width;
          },
          onPanUpdate: (e) {
            final identityLayer = widget.layer;
            final layer = identityLayer.data;

            final newWidth = startingPosition! + e.localPosition.dx;
            if (newWidth < 20) return;
            final newLayer = layer.copyWith(
              size: Size(
                newWidth,
                widget.scaleProportionally ? newWidth : layer.size.height,
              ),
            );
            context
                .read<CanvasCubit>()
                .editLayer(identityLayer.copyWith(data: newLayer));
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
          onPanStart: (e) {
            startingPosition = widget.layer.data.size.height;
          },
          onPanUpdate: (e) {
            final identityLayer = widget.layer;
            final layer = identityLayer.data;

            final newHeight = startingPosition! + e.localPosition.dy;
            if (newHeight < 20) return;

            final newLayer = layer.copyWith(
              size: Size(
                widget.scaleProportionally ? newHeight : layer.size.width,
                newHeight,
              ),
            );
            context
                .read<CanvasCubit>()
                .editLayer(identityLayer.copyWith(data: newLayer));
          },
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
      onPanEnd: onPanEnd,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(blurRadius: 5, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
