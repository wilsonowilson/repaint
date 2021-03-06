import 'package:flutter/material.dart';
import 'package:repaint/application/cubit/canvas_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditingSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CanvasCubit>();

    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [],
      ),
    );
  }
}

class TextLayerEditSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
