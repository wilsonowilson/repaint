part of 'canvas_cubit.dart';

class CanvasState extends Equatable {
  const CanvasState({
    required this.layers,
    required this.canvas,
    required this.selectedLayer,
  });
  final List<IdentityLayer> layers;
  final RCanvas canvas;
  final Option<IdentityLayer> selectedLayer;

  factory CanvasState.initial(RCanvas canvas) => CanvasState(
        layers: [],
        canvas: canvas,
        selectedLayer: none(),
      );

  @override
  List<Object> get props => [layers, selectedLayer, canvas];

  bool get isInEditMode => selectedLayer.isSome();
  IdentityLayer get selectedOption {
    assert(isInEditMode, 'Only call this method if in edit mode');
    return selectedLayer.fold(() => null, (a) => a)!;
  }

  CanvasState copyWith({
    List<IdentityLayer>? layers,
    RCanvas? canvas,
    Option<IdentityLayer>? selectedLayer,
  }) {
    return CanvasState(
      layers: layers ?? this.layers,
      canvas: canvas ?? this.canvas,
      selectedLayer: selectedLayer ?? this.selectedLayer,
    );
  }
}

extension LayerIdentificationExtension on IdentityLayer {
  bool get isTextLayer => data is TextLayer;
  bool get isImageLayer => data is ImageLayer;
}
