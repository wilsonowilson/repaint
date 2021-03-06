import 'package:flutter/rendering.dart';
import 'package:repaint/models/layer/text.dart';

class TextLayerHelper {
  static TextLayer applyHeightToLayer(TextLayer layer) {
    final span = TextSpan(text: layer.text, style: layer.style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: layer.size.width);
    final newLayer = layer.copyWith(
      text: layer.text,
      size: Size(
        layer.size.width,
        tp.size.height,
      ),
    );
    return newLayer;
  }
}
