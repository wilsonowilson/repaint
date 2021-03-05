import 'package:flutter/material.dart';

class InteractiveCanvasViewer extends StatelessWidget {
  const InteractiveCanvasViewer({
    Key? key,
    required this.controller,
    required this.scaleController,
    required this.child,
    this.scale = false,
  }) : super(key: key);
  final Widget child;
  final bool scale;

  final TransformationController controller;
  final TransformationController scaleController;

  @override
  Widget build(BuildContext context) {
    var viewer = InteractiveViewer(
      transformationController: scale ? scaleController : controller,
      constrained: scale ? true : false,
      scaleEnabled: scale,
      panEnabled: false,
      child: child,
    );

    return viewer;
  }
}
