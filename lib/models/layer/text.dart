import 'package:flutter/material.dart';

import 'layer.dart';

class TextLayer extends RLayer {
  TextLayer({
    this.align,
    this.shadow = const Shadow(),
    required this.style,
    required this.font,
    required this.size,
    required this.offset,
    required this.text,
  });

  @override
  final Offset offset;

  @override
  final double opacity = 1;

  @override
  final Size size;
  @override
  final Shadow shadow;
  // Used to match google fonts
  final String font;

  // TODO: split style
  final TextStyle style;

  final TextAlign? align;

  final String text;

  @override
  List<Object?> get props => [
        offset,
        opacity,
        text,
        style,
        size,
        align,
        font,
        shadow,
      ];

  TextLayer copyWith({
    Offset? offset,
    TextStyle? style,
    String? text,
    double? opacity,
    Size? size,
    TextAlign? align,
    String? font,
    Shadow? shadow,
  }) {
    return TextLayer(
      offset: offset ?? this.offset,
      style: style ?? this.style,
      text: text ?? this.text,
      size: size ?? this.size,
      align: align ?? this.align,
      font: font ?? this.font,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  String toString() {
    return '$text';
  }
}

const availableFonts = <String>[
  'Raleway',
  'Montserrat',
  'Roboto',
  'Playfair Display',
  'Lobster',
  'Oswald',
  'Abril Fatface',
  'Roboto Condensed',
  'Merriweather',
];
