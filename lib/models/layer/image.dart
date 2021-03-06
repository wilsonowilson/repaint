import 'dart:typed_data';
import 'dart:ui';

import 'layer.dart';

class ImageLayer extends RLayer {
  ImageLayer({
    this.data,
    required this.size,
    required this.offset,
    this.shadow = const Shadow(),
  });

  @override
  final Offset offset;

  @override
  final double opacity = 1;

  final Uint8List? data;

  @override
  final Size size;

  @override
  final Shadow shadow;

  @override
  List<Object?> get props => [offset, opacity, data, size, shadow];

  ImageLayer copyWith({
    Offset? offset,
    Size? size,
    double? opacity,
    Uint8List? data,
    Shadow? shadow,
  }) {
    return ImageLayer(
      offset: offset ?? this.offset,
      data: data ?? this.data,
      size: size ?? this.size,
      shadow: shadow ?? this.shadow,
    );
  }
}
