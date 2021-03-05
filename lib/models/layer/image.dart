import 'dart:typed_data';
import 'dart:ui';

import 'layer.dart';

class ImageLayer extends RLayer {
  ImageLayer({
    this.size,
    required this.offset,
    required this.data,
  });

  @override
  final Offset offset;

  @override
  double get opacity => 1;

  final Uint8List data;

  @override
  final Size? size;

  @override
  List<Object?> get props => [offset, opacity, data, size];

  ImageLayer copyWith({
    Offset? offset,
    Uint8List? data,
    Size? size,
  }) {
    return ImageLayer(
      offset: offset ?? this.offset,
      data: data ?? this.data,
      size: size ?? this.size,
    );
  }
}
