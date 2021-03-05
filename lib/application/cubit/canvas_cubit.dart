import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:repaint/models/core/canvas.dart';
import 'package:repaint/models/layer/layer.dart';
import 'package:uuid/uuid.dart';

part 'canvas_state.dart';

class CanvasCubit extends Cubit<CanvasState> {
  CanvasCubit(RCanvas canvas) : super(CanvasState.initial(canvas));

  void addLayer(RLayer layer) {
    final layers = state.layers.toList();

    emit(state.copyWith(
      layers: layers..add(IdentityLayer(id: Uuid().v4(), data: layer)),
    ));
  }

  void removeLayer(IdentityLayer layer) {
    final layers = state.layers.toList();
    emit(state.copyWith(
      layers: layers..removeWhere((element) => element.id == layer.id),
    ));
  }

  void editLayer(IdentityLayer layer) {
    final layers = state.layers.toList();
    final current = layers.firstWhere((element) => element.id == layer.id);
    final index = layers.indexOf(current);
    layers.remove(current);
    layers.insert(index, layer);
    emit(state.copyWith(layers: layers));
  }

  void editCanvas(RCanvas canvas) {
    emit(state.copyWith(canvas: canvas));
  }

  void selectLayer(IdentityLayer layer) {
    if (state.layers.contains(layer))
      emit(state.copyWith(selectedLayer: some(layer)));
  }

  void deselectLayer() {
    emit(state.copyWith(selectedLayer: none()));
  }
}
