import 'package:equatable/equatable.dart';
import 'dart:ui';

class RCanvas extends Equatable {
  RCanvas({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  List<Object> get props => [width, height, color];

  RCanvas copyWith({
    double? width,
    double? height,
    Color? color,
  }) {
    return RCanvas(
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
    );
  }
}
