import 'dart:ui';

import 'package:equatable/equatable.dart';

class RCanvas extends Equatable {
  RCanvas({
    required this.size,
    required this.color,
    this.effectiveSize,
  });

  final Size size;
  final Size? effectiveSize;
  final Color color;

  @override
  List<Object?> get props => [size, effectiveSize, color];

  RCanvas copyWith({
    Size? size,
    Size? effectiveSize,
    Color? color,
  }) {
    return RCanvas(
      size: size ?? this.size,
      effectiveSize: effectiveSize ?? this.effectiveSize,
      color: color ?? this.color,
    );
  }
}
