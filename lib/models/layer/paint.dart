import 'dart:ui';

import 'package:flutter/rendering.dart' hide Layer;

import 'layer.dart';

class PaintLayer extends RLayer {
  PaintLayer({
    this.clippingPath,
    this.shadow = const Shadow(),
    required this.size,
    required this.offset,
    required this.color,
    required this.borderRadius,
  }) : assert(shadow is BoxShadow);

  @override
  final Offset offset;

  @override
  double get opacity => 1;

  @override
  final Size size;

  final Color color;

  final Path? clippingPath;

  @override
  final Shadow shadow;

  final double borderRadius;

  @override
  List<Object?> get props => [
        size,
        offset,
        opacity,
        color,
        clippingPath,
        shadow,
        borderRadius,
      ];

  PaintLayer copyWith({
    Offset? offset,
    Size? size,
    Color? color,
    Path? clippingPath,
    double? opacity,
    Shadow? shadow,
    double? borderRadius,
  }) {
    return PaintLayer(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      color: color ?? this.color,
      clippingPath: clippingPath ?? this.clippingPath,
      shadow: shadow ?? this.shadow,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }
}
