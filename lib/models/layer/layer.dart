import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:repaint/models/layer/image.dart';
import 'package:repaint/models/layer/paint.dart';
import 'package:repaint/models/layer/text.dart';

abstract class RLayer extends Equatable {
  Offset get offset;
  double get opacity;
  Size? get size;
}

class IdentityLayer<T extends RLayer> extends Equatable {
  IdentityLayer({
    required this.id,
    required this.data,
  });

  final String id;
  final T data;

  IdentityLayer<T> copyWith({
    String? id,
    T? data,
  }) {
    return IdentityLayer<T>(
      id: id ?? this.id,
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [id, data];
}
