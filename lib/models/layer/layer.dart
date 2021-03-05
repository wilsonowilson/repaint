import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class RLayer extends Equatable {
  Offset get offset;
  double get opacity;
  Size? get size;
}

class IdentityLayer extends Equatable {
  IdentityLayer({
    required this.id,
    required this.data,
  });

  final String id;
  final RLayer data;

  IdentityLayer copyWith({
    String? id,
    RLayer? data,
  }) {
    return IdentityLayer(
      id: id ?? this.id,
      data: data ?? this.data,
    );
  }

  @override
  List<Object> get props => [id, data];
}
