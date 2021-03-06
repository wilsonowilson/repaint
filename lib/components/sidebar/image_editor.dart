import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:repaint/application/utils/image_picker.dart';
import 'package:repaint/models/layer/image.dart';

class ImageEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();
    final state = cubit.state;
    final selectedLayer = state.selectedLayer.fold(() => null, (a) => a);
    final layer = selectedLayer!.data as ImageLayer;
    void _updateImage() async {
      final bytes = await ImagePicker.pickImage();
      if (bytes == null) return;
      cubit.editLayer(
        selectedLayer.copyWith(
          data: layer.copyWith(data: bytes),
        ),
      );
    }

    return GestureDetector(
      onTap: _updateImage,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(layer.data!),
          ),
        ),
      ),
    );
  }
}
